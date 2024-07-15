import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ApiOps {
  // This is a local server, you can change it to your own server
  static String path = "http://192.168.15.10:8000";

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
      throw Exception("User not authenticated");
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
  Future<http.Response> mountRequest(String endpoint) async {
    final token = await getUserToken();
    endpoint = '$endpoint/?${getUrlFilter()}';
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  // This method retrieves the user information
  Future<Map<String, dynamic>> userInfo() async {
    final endpoint = '$path/user-info';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
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
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the reviews for the home page
  Future<Map<String, dynamic>> reviewsHome() async {
    final endpoint = '$path/home/reviews';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the account health for the home page
  Future<Map<String, dynamic>> accHealthHome() async {
    final endpoint = '$path/home/acc-health';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the cards for the home page
  Future<Map<String, dynamic>> cardsHome() async {
    final endpoint = '$path/home/cards';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the cards for the advertising page
  Future<Map<String, dynamic>> cardsAdvertising() async {
    final endpoint = '$path/advertising/cards';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the cards for the inventory page
  Future<Map<String, dynamic>> cardsInventory() async {
    final endpoint = '$path/inventory/cards';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the cards for the revenue page
  Future<Map<String, dynamic>> cardsRevenue() async {
    final endpoint = '$path/revenue/cards';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the home graphs
  Future<Map<String, dynamic>> graphsHome() async {
    final endpoint = '$path/home/graphs';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the revenue graphs
  Future<Map<String, dynamic>> graphsRevenue() async {
    final endpoint = '$path/revenue/graphs';
    final response = await mountRequest(endpoint);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  // This method retrieves the advertising graphs
  Future<Map<String, dynamic>> graphsAdvertising() async {
    final endpoint = '$path/advertising/graphs';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the inventory graphs
  Future<Map<String, dynamic>> graphsInventory() async {
    final endpoint = '$path/inventory/graphs';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the advertising tables
  Future<Map<String, dynamic>> tablesAdvertising() async {
    final endpoint = '$path/advertising/tables';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the inventory graphs
  Future<Map<String, dynamic>> tablesInventory() async {
    final endpoint = '$path/inventory/tables';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the projections for the revenue page
  Future<Map<String, dynamic>> projection() async {
    final endpoint = '$path/revenue/projection';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the prime day table
  Future<Map<String, dynamic>> primeTable() async {
    final endpoint = '$path/events/prime-day/table';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the prime day cards
  Future<Map<String, dynamic>> primeCards() async {
    final endpoint = '$path/events/prime-day/cards';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
  }

  // This method retrieves the prime day graph
  Future<Map<String, dynamic>> primeGraph() async {
    final endpoint = '$path/events/prime-day/graph';
    final response = await mountRequest(endpoint);
    return json.decode(response.body);
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
