import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/models/destination.dart';

import '../../temp_data/fake_destination.dart';

class FakeDestinationRepositoryImpl implements IDestinationRepository {
  @override
  Future<List<Destination>> getDestinations() => Future.value([kDestination1, kDestination2]);
}
