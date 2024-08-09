import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiOps {
  static const String path = "https://sellerflow.com.br:8443";
  // static const String path = "http://127.0.0.1:8000";

  static const int maxRetries = 5;
  static const Duration retryDelay = Duration(seconds: 5);
  static const Duration requestTimeout = Duration(seconds: 30);

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: path,
      connectTimeout: requestTimeout,
      receiveTimeout: requestTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Map<String, String> filter = {};

  ApiOps() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> connected() async {
    int attempt = 0;
    const endpoint = '$path/docs';

    while (attempt < maxRetries) {
      attempt++;
      try {
        final response = await _dio.get(endpoint);
        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception('Failed to connect: ${response.statusCode}');
        }
      } catch (e) {
        if (attempt >= maxRetries) {
          throw Exception('Failed to connect after $maxRetries attempts');
        }
      }
      await Future.delayed(retryDelay);
    }
    return false;
  }

  Future<String?> getUserToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      return token;
    } else {
      throw Exception("User not found");
    }
  }

  String getUrlFilter() {
    String urlResponse = "";

    filter.forEach((key, value) {
      if (key == "date") {
        var parts = value.split("/");
        var month = parts[0];
        var year = parts[1];
        urlResponse += "&month=$month&year=$year";
      } else {
        urlResponse += "&$key=${value.replaceAll('&', '%26')}";
      }
    });

    return urlResponse;
  }

  Future<Map<String, dynamic>> mountRequest(String endpoint) async {
    final token = await getUserToken();
    endpoint = '$endpoint/?${getUrlFilter()}';

    int attempt = 0;

    while (attempt < maxRetries) {
      attempt++;
      try {
        final response = await _dio.get(
          endpoint,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
        );

        if (response.statusCode == 200) {
          return response.data as Map<String, dynamic>;
        } else {
          throw Exception('Failed to load data: ${response.statusCode}');
        }
      } on DioException catch (e) {
        if (attempt >= maxRetries) {
          throw Exception(
              'Request failed after $maxRetries attempts: ${e.message}');
        }
      }
      await Future.delayed(retryDelay);
    }
    throw Exception('Failed to load data after $maxRetries attempts');
  }

  Future<void> forceFreshFetch() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<Map<String, dynamic>> fetchDataWithCaching(
    String cacheKey,
    Future<Map<String, dynamic>> Function() fetchFunction, {
    Duration cacheTimeout = const Duration(minutes: 7),
  }) async {
    final pref = await SharedPreferences.getInstance();
    final cachedData = pref.getString(cacheKey);
    final cacheTimestamp = pref.getInt('${cacheKey}_timestamp') ?? 0;
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    if (cachedData != null &&
        (currentTimestamp - cacheTimestamp) < cacheTimeout.inMilliseconds) {
      return json.decode(cachedData) as Map<String, dynamic>;
    } else {
      final freshData = await fetchFunction();
      await pref.setString(cacheKey, json.encode(freshData));
      await pref.setInt('${cacheKey}_timestamp', currentTimestamp);
      return freshData;
    }
  }

  Future<Map<String, dynamic>> userInfo() async {
    const endpoint = '/user-info';
    return fetchDataWithCaching('user_info', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> filterInfo(
      Map<String, dynamic> variation) async {
    final query = variation['queryKey'][1] != null
        ? '?variation=${variation['queryKey'][1]}'
        : '';
    final endpoint = '/user-info/filter/$query';
    final token = await getUserToken();
    final response = await _dio.get(
      endpoint,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> mktshareHome() async {
    const endpoint = '/home/mktshare';
    return fetchDataWithCaching('mktshare_home', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> reviewsHome() async {
    const endpoint = '/home/reviews';
    return fetchDataWithCaching('reviews_home', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> accHealthHome() async {
    const endpoint = '/home/acc-health';
    return fetchDataWithCaching('acc_health', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> cardsHome() async {
    const endpoint = '/home/cards';
    return fetchDataWithCaching('cards_home', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> cardsAdvertising() async {
    const endpoint = '/advertising/cards';
    return fetchDataWithCaching('cards_ads', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> cardsInventory() async {
    const endpoint = '/inventory/cards';
    return fetchDataWithCaching(
        'cards_inventory', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> cardsRevenue() async {
    const endpoint = '/revenue/cards';
    return fetchDataWithCaching('cards_revenue', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> graphsHome() async {
    const endpoint = '/home/graphs';
    return fetchDataWithCaching('graphs_home', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> graphsRevenue() async {
    const endpoint = '/revenue/graphs';
    return fetchDataWithCaching('graphs_revenue', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> graphsAdvertising() async {
    const endpoint = '/advertising/graphs';
    return fetchDataWithCaching('graphs_ads', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> graphsInventory() async {
    const endpoint = '/inventory/graphs';
    return fetchDataWithCaching(
        'graphs_inventory', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> tablesAdvertising() async {
    const endpoint = '/advertising/tables';
    return fetchDataWithCaching('tables_ads', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> tablesInventory() async {
    const endpoint = '/inventory/tables';
    return fetchDataWithCaching(
        'tables_inventory', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> projection() async {
    const endpoint = '/revenue/projection';
    return fetchDataWithCaching(
        'revenue_projection', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> primeTable() async {
    const endpoint = '/events/prime-day/table';
    return fetchDataWithCaching('prime_table', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> primeCards() async {
    const endpoint = '/events/prime-day/cards';
    return fetchDataWithCaching('prime_cards', () => mountRequest(endpoint));
  }

  Future<Map<String, dynamic>> primeGraph() async {
    const endpoint = '/events/prime-day/graph';
    return fetchDataWithCaching('prime_graphs', () => mountRequest(endpoint));
  }

  Map<String, Function> homeData(Map<String, String> filter) {
    this.filter = filter;
    return {
      'cards_home': cardsHome,
      'graphs_home': graphsHome,
      'reviews_home': reviewsHome,
      'mktshare_home': mktshareHome,
      'acc_health_home': accHealthHome,
    };
  }

  Map<String, Function> revenueData(Map<String, String> filter) {
    this.filter = filter;
    return {
      'cards_revenue': cardsRevenue,
      'graphs_revenue': graphsRevenue,
      'projection': projection,
    };
  }

  Map<String, Function> marketingData(Map<String, String> filter) {
    this.filter = filter;
    return {
      'cards_advertising': cardsAdvertising,
      'graphs_advertising': graphsAdvertising,
      'tables_advertising': tablesAdvertising,
    };
  }

  Map<String, Function> inventoryData(Map<String, String> filter) {
    this.filter = filter;
    return {
      'cards_inventory': cardsInventory,
      'tables_inventory': tablesInventory,
      'graphs_inventory': graphsInventory,
    };
  }

  Map<String, Function> primeData(Map<String, String> filter) {
    this.filter = filter;
    return {
      'prime_table': primeTable,
      'prime_cards': primeCards,
      'prime_graph': primeGraph,
    };
  }

  void getChartData(String defaultVar) {}
  void getCurrentData(String defaultVar) {}
}
