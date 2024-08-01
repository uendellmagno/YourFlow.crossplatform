import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  final StreamController<ConnectivityResult> _connectivityStreamController =
      StreamController<ConnectivityResult>.broadcast();

  ConnectivityService() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      // Assuming results is a List<ConnectivityResult> and you want to process the first result
      if (results.isNotEmpty) {
        _connectivityStreamController.add(results.first);
      }
    });
  }

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityStreamController.stream;

  Future<bool> isConnected() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void dispose() {
    _subscription.cancel();
    _connectivityStreamController.close();
  }
}
