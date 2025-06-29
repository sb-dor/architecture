import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionCheckerHelper {
  Future<bool> hasAccessToInternet() {
    return InternetConnection().hasInternetAccess;
  }
}
