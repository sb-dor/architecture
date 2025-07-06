import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:architectures/models/continent.dart';

class FakeContinentRepositoryImpl implements IContinentRepository {
  @override
  Future<List<Continent>> getContinents() =>
      Future.value([Continent(name: "Asia", imageUrl: "imageUrl")]);
}
