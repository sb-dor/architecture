import 'package:architectures/data/services/activities/activities_service.dart';
import 'package:architectures/models/activity.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class IActivitiesRepository {
  Future<List<Activity>> getByDestination(String ref);
}

final class ActivitiesRepositoryImpl implements IActivitiesRepository {
  ActivitiesRepositoryImpl({
    required IActivitiesService activitiesRemoteService,
    required IActivitiesService activitiesLocalService,
    required InternetConnectionCheckerHelper internetConnectionChecker,
  }) : _activitiesRemoteService = activitiesRemoteService,
       _activitiesLocalService = activitiesLocalService,
       _internetConnectionCheckerHelper = internetConnectionChecker;

  final IActivitiesService _activitiesRemoteService;
  final IActivitiesService _activitiesLocalService;
  final InternetConnectionCheckerHelper _internetConnectionCheckerHelper;

  @override
  Future<List<Activity>> getByDestination(String ref) async {
    final hasInternetAccess =
        await _internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternetAccess) {
      return _activitiesRemoteService.getByDestination(ref);
    } else {
      return _activitiesLocalService.getByDestination(ref);
    }
  }
}
