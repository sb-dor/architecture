import 'package:architectures/models/continent.dart';

abstract interface class IContinentService {
  Future<List<Continent>> getContinents();
}
