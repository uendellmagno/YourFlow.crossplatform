import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiOps {
  // This is a local server, you can change it to your own server
  static String path = "http://192.168.3.209:8000";

  Map<String, String> filter = {};

  // This method retrieves the user token
  Future<String> getUserToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null) {
        return token;
      } else {
        throw Exception("Failed to retrieve token");
      }
    } else {
      throw Exception("User not found");
    }
  }

  // This method returns the filter parameters as a string
  String getUrlFilter() {
    var urlResponse = '';
    filter.forEach((key, value) {
      urlResponse += '&$key=${value.replaceAll('&', '%26')}';
    });
    return urlResponse;
  }

  // This method mounts the request
  Future<Map<String, dynamic>> mountRequest(String endpoint) async {
    final token = await getUserToken();
    endpoint = '$endpoint/?${getUrlFilter()}';
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // delete cache and force refresh data from the server:
  void forceFreshFetch() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<Map<String, dynamic>> fetchDataWithCaching(
      String cacheKey, Future<Map<String, dynamic>> Function() fetchFunction,
      {Duration cacheTimeout = const Duration(minutes: 7)}) async {
    final pref = await SharedPreferences.getInstance();
    final cachedData = pref.getString(cacheKey);
    final cacheTimestamp = pref.getInt('${cacheKey}_timestamp') ?? 0;
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    if (cachedData != null &&
        (currentTimestamp - cacheTimestamp) < cacheTimeout.inMilliseconds) {
      // Return cached data if within cache timeout
      return json.decode(cachedData) as Map<String, dynamic>;
    } else {
      // Fetch fresh data from API
      final freshData = await fetchFunction();
      // Store fresh data in cache
      await pref.setString(cacheKey, json.encode(freshData));
      await pref.setInt('${cacheKey}_timestamp', currentTimestamp);
      return freshData;
    }
  }

  // This method retrieves the user information
  Future<Map<String, dynamic>> userInfo() async {
    final endpoint = '$path/user-info';
    return fetchDataWithCaching('user_info', () => mountRequest(endpoint));
  }

  // This method retrieves the user information for a specific filter
  Future<Map<String, dynamic>> filterInfo(
      Map<String, dynamic> variation) async {
    final query = variation['queryKey'][1] != null
        ? '?variation=${variation['queryKey'][1]}'
        : '';
    final endpoint = '$path/user-info/filter/$query';
    final token = await getUserToken();
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> mktshareHome() async {
    final endpoint = '$path/home/mktshare';
    return fetchDataWithCaching('mktshare_home', () => mountRequest(endpoint));
  }

  // This method retrieves the reviews for the home page
  Future<Map<String, dynamic>> reviewsHome() async {
    final endpoint = '$path/home/reviews';
    return fetchDataWithCaching('reviews_home', () => mountRequest(endpoint));
  }

  // This method retrieves the account health for the home page
  Future<Map<String, dynamic>> accHealthHome() async {
    final endpoint = '$path/home/acc-health';
    return fetchDataWithCaching('acc_health', () => mountRequest(endpoint));
  }

  // This method retrieves the cards for the home page
  Future<Map<String, dynamic>> cardsHome() async {
    final endpoint = '$path/home/cards';
    return fetchDataWithCaching('cards_home', () => mountRequest(endpoint));
  }

  // This method retrieves the cards for the advertising page
  Future<Map<String, dynamic>> cardsAdvertising() async {
    final endpoint = '$path/advertising/cards';
    return fetchDataWithCaching('cards_ads', () => mountRequest(endpoint));
  }

  // This method retrieves the cards for the inventory page
  Future<Map<String, dynamic>> cardsInventory() async {
    final endpoint = '$path/inventory/cards';
    return fetchDataWithCaching(
        'cards_inventory', () => mountRequest(endpoint));
  }

  // This method retrieves the cards for the revenue page
  Future<Map<String, dynamic>> cardsRevenue() async {
    final endpoint = '$path/revenue/cards';
    return fetchDataWithCaching('cards_revenue', () => mountRequest(endpoint));
  }

  // This method retrieves the home graphs
  Future<Map<String, dynamic>> graphsHome() async {
    final endpoint = '$path/home/graphs';
    return fetchDataWithCaching('graphs_home', () => mountRequest(endpoint));
  }

  // This method retrieves the revenue graphs
  Future<Map<String, dynamic>> graphsRevenue() async {
    final endpoint = '$path/revenue/graphs';
    return fetchDataWithCaching('graphs_revenue', () => mountRequest(endpoint));
  }

  // This method retrieves the advertising graphs
  Future<Map<String, dynamic>> graphsAdvertising() async {
    final endpoint = '$path/advertising/graphs';
    return fetchDataWithCaching('graphs_ads', () => mountRequest(endpoint));
  }

  // This method retrieves the inventory graphs
  Future<Map<String, dynamic>> graphsInventory() async {
    final endpoint = '$path/inventory/graphs';
    return fetchDataWithCaching(
        'graphs_inventory', () => mountRequest(endpoint));
  }

  // This method retrieves the advertising tables
  Future<Map<String, dynamic>> tablesAdvertising() async {
    final endpoint = '$path/advertising/tables';
    return fetchDataWithCaching('tables_ads', () => mountRequest(endpoint));
  }

  // This method retrieves the inventory graphs
  Future<Map<String, dynamic>> tablesInventory() async {
    final endpoint = '$path/inventory/tables';
    return fetchDataWithCaching(
        'tables_inventory', () => mountRequest(endpoint));
  }

  // This method retrieves the projections for the revenue page
  Future<Map<String, dynamic>> projection() async {
    final endpoint = '$path/revenue/projection';
    return fetchDataWithCaching(
        'revenue_projection', () => mountRequest(endpoint));
  }

  // This method retrieves the prime day table
  Future<Map<String, dynamic>> primeTable() async {
    final endpoint = '$path/events/prime-day/table';
    return fetchDataWithCaching('prime_table', () => mountRequest(endpoint));
  }

  // This method retrieves the prime day cards
  Future<Map<String, dynamic>> primeCards() async {
    final endpoint = '$path/events/prime-day/cards';
    return fetchDataWithCaching('prime_cards', () => mountRequest(endpoint));
  }

  // This method retrieves the prime day graph
  Future<Map<String, dynamic>> primeGraph() async {
    final endpoint = '$path/events/prime-day/graph';
    return fetchDataWithCaching('prime_graphs', () => mountRequest(endpoint));
  }

  // This method retrieves the home data
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

  // This method retrieves the revenue data
  Map<String, Function> revenueData(Map<String, String> filter) {
    this.filter = filter;
    return {
      'cards_revenue': cardsRevenue,
      'graphs_revenue': graphsRevenue,
      'projection': projection,
    };
  }

  // This method retrieves the marketing data
  Map<String, Function> marketingData(Map<String, String> filter) {
    this.filter = filter;
    return {
      'cards_advertising': cardsAdvertising,
      'graphs_advertising': graphsAdvertising,
      'tables_advertising': tablesAdvertising,
    };
  }

  //  This method retrieves the inventory data
  Map<String, Function> inventoryData(Map<String, String> filter) {
    this.filter = filter;
    return {
      'cards_inventory': cardsInventory,
      'tables_inventory': tablesInventory,
      'graphs_inventory': graphsInventory,
    };
  }

  // This method retrieves the prime day data
  Map<String, Function> primeData(Map<String, String> filter) {
    this.filter = filter;
    return {
      'prime_table': primeTable,
      'prime_cards': primeCards,
      'prime_graph': primeGraph,
    };
  }

  getChartData(String defaultVar) {}
  getCurrentData(String defaultVar) {}
}
