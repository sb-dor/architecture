import 'package:architectures/models/destination.dart';

abstract interface class IDestinationService {
  Future<List<Destination>> getDestinations();
}

final class DestinationRemoteService implements IDestinationService {
  @override
  Future<List<Destination>> getDestinations() {
    // TODO: implement getDestinations
    throw UnimplementedError();
  }
}

final class DestinationLocalService implements IDestinationService {
  @override
  Future<List<Destination>> getDestinations() {
    // TODO: implement getDestinations
    throw UnimplementedError();
  }
}
