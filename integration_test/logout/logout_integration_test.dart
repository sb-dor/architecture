import 'package:architectures/data/repositories/auth/auth_repository.dart';
import 'package:architectures/data/services/auth/auth_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/ui/logout/controllers/logout_controller.dart';
import 'package:architectures/ui/logout/widgets/logout_button_widget.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test/helpers/test_widget_controller.dart';
import 'logout_integration_test.mocks.dart';

@GenerateMocks([IAuthService, InternetConnectionCheckerHelper])
void main() {
  late final MockIAuthService mockIAuthRemoteService;
  late final MockIAuthService mockIAuthLocalService;

  late final MockInternetConnectionCheckerHelper mockInternetConnectionCheckerHelper;

  late LogoutController logoutController;

  setUpAll(() {
    mockIAuthRemoteService = MockIAuthService();
    mockIAuthLocalService = MockIAuthService();

    mockInternetConnectionCheckerHelper = MockInternetConnectionCheckerHelper();

    final IAuthRepository authRepository = AuthRepositoryImpl(
      authRemoteService: mockIAuthRemoteService,
      authLocalService: mockIAuthLocalService,
      internetConnectionCheckerHelper: mockInternetConnectionCheckerHelper,
    );

    logoutController = LogoutController(authRepository: authRepository);
  });

  tearDownAll(() => logoutController.dispose());

  group('Logout integration test', () {
    //

    testWidgets("Logout widget test for success", (tester) async {
      //
      when(mockInternetConnectionCheckerHelper.hasAccessToInternet()).thenAnswer((_) async => true);

      when(mockIAuthRemoteService.logout()).thenAnswer((_) async => true);

      await TestWidgetController(tester).pumpWidget(
        Scaffold(body: Center(child: LogoutButton())),
        dependencies: TestLogoutDependencyContainer(logoutController: logoutController),
      );

      final findButton = find.byKey(ValueKey<String>('logout_button'));

      expect(findButton, findsOneWidget);

      await tester.tap(findButton);
      await tester.pumpAndSettle();

      verify(mockInternetConnectionCheckerHelper.hasAccessToInternet()).called(1);
      verify(mockIAuthRemoteService.logout()).called(1);
    });
  });
}

final class TestLogoutDependencyContainer extends TestDependencyContainer {
  TestLogoutDependencyContainer({required LogoutController logoutController})
    : _logoutController = logoutController;

  final LogoutController _logoutController;

  @override
  LogoutController get logoutController => _logoutController;
}
