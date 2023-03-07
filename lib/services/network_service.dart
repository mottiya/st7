import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkService extends GetxService {
  Future<bool> checkConnection() async =>
      await Connectivity().checkConnectivity() != ConnectivityResult.none;
}
