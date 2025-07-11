import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([IAuthService, InternetConnectionCheckerHelper])
void main() async {
  late MockIAuthService remoteService;
  late MockIAuthService localService;
}
