import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/models/continent.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class IContinentRepository {
  Future<List<Continent>> getContinents();
}

final class ContinentRepositoryImpl implements IContinentRepository {
  ContinentRepositoryImpl({
    required IContinentService continentRemoteService,
    required IContinentService continentLocalService,
    required InternetConnectionCheckerHelper internetConnectionCheckerHelper,
  }) : _continentRemoteService = continentRemoteService,
       _continentLocalService = continentLocalService,
       _internetConnectionCheckerHelper = internetConnectionCheckerHelper;

  final IContinentService _continentRemoteService;
  final IContinentService _continentLocalService;
  final InternetConnectionCheckerHelper _internetConnectionCheckerHelper;

  @override
  Future<List<Continent>> getContinents() async {
    final hasInternetConnection = await _internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternetConnection) {
      return _continentRemoteService.getContinents();
    } else {
      return _continentLocalService.getContinents();
    }
  }
}
