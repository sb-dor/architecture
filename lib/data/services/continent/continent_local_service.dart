import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/models/continent.dart';

final class ContinentLocalService implements IContinentService {
  @override
  Future<List<Continent>> getContinents() async {
    return <Continent>[];
  }
}
