import 'package:architectures/data/services/destination/destination_service.dart';
import 'package:architectures/models/destination.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class IDestinationRepository {
  Future<List<Destination>> getDestinations();
}

final class DestinationRepositoryImpl implements IDestinationRepository {
  DestinationRepositoryImpl({
    required IDestinationService destinationRemoteService,
    required IDestinationService destinationLocalService,
    required InternetConnectionCheckerHelper internetConnectionCheckerHelper,
  }) : _destinationRemoteService = destinationRemoteService,
       _destinationLocalService = destinationLocalService,
       _internetConnectionCheckerHelper = internetConnectionCheckerHelper;

  final IDestinationService _destinationRemoteService;
  final IDestinationService _destinationLocalService;
  final InternetConnectionCheckerHelper _internetConnectionCheckerHelper;

  @override
  Future<List<Destination>> getDestinations() async {
    final hasInternetAccess =
        await _internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternetAccess) {
      return _destinationRemoteService.getDestinations();
    } else {
      return _destinationLocalService.getDestinations();
    }
  }
}
