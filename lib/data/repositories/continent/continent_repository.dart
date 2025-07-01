import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/models/continent.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class ContinentRepository {
  Future<List<Continent>> getContinents();
}

final class ContinentRepositoryImpl implements ContinentRepository {
  ContinentRepositoryImpl({
    required this.continentRemoteService,
    required this.continentLocalService,
    required this.internetConnectionCheckerHelper,
  });

  final ContinentService continentRemoteService;
  final ContinentService continentLocalService;
  final InternetConnectionCheckerHelper internetConnectionCheckerHelper;

  @override
  Future<List<Continent>> getContinents() async {
    final hasInternetConnection = await internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternetConnection) {
      return continentRemoteService.getContinents();
    } else {
      return continentLocalService.getContinents();
    }
  }
}
