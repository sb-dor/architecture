import 'package:architectures/data/services/continent/continent_service.dart';
import 'package:architectures/models/continent.dart';
import 'package:http/http.dart' as http;

final class ContinentRemoteService implements ContinentService {
  ContinentRemoteService({required String mainUrl, http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<Continent>> getContinents() {
    // TODO: implement getContinents
    throw UnimplementedError();
  }
}
