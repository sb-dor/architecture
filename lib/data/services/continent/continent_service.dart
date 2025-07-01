import 'package:architectures/models/continent.dart';

abstract interface class ContinentService {
  Future<List<Continent>> getContinents();
}
