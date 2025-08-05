import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/repositories/user_repository/user_repository.dart';
import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/data/services/user_services/user_service.dart';
import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/home/controller/home_controller.dart';
import 'package:architectures/ui/home/widgets/home_widget.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test/helpers/test_widget_controller.dart';
import '../../testing_data/temp_data/fake_bookings.dart';
import '../../testing_data/temp_data/fake_user.dart';

import 'home_widget_integration_test.mocks.dart';

// https://stackoverflow.com/questions/68275811/is-there-a-way-to-let-mockito-generate-mocks-for-integration-tests-in-a-flutter
@GenerateMocks([IBookingService, IUserService, InternetConnectionCheckerHelper])
void main() {
  late final MockIBookingService mockedBookingRemoteService;
  late final MockIBookingService mockedBookingLocalService;
  late final MockIUserService mockedUserRemoteService;
  late final MockIUserService mockedUserLocalService;
  late final MockInternetConnectionCheckerHelper mockedInternetConnectionChecker;
  late final HomeController homeController;
  late final Widget app;

  // if you use only one test use "setUp" for init and "tearDown" for closing
  // otherWise use "setUpAll" and teatDownAll",
  setUpAll(() {
    mockedBookingRemoteService = MockIBookingService();
    mockedBookingLocalService = MockIBookingService();
    mockedUserRemoteService = MockIUserService();
    mockedUserLocalService = MockIUserService();

    mockedInternetConnectionChecker = MockInternetConnectionCheckerHelper();

    late final IBookingRepository bookingRepository = BookingRepositoryImpl(
      bookingRemoteService: mockedBookingRemoteService,
      bookingLocalService: mockedBookingLocalService,
      internetConnectionCheckerHelper: mockedInternetConnectionChecker,
    );
    final IUserRepository userRepository = UserRepositoryImpl(
      userRemoteService: mockedUserRemoteService,
      userLocalService: mockedUserLocalService,
      internetConnectionCheckerHelper: mockedInternetConnectionChecker,
    );

    homeController = HomeController(
      bookingRepository: bookingRepository,
      userRepository: userRepository,
    );

    // you can do like this or check out each "testWidgets"

    // app = TestAppWidget(
    //   dependencyContainer: HomeTestDependencyContainer(homeController: homeController),
    //   widget: HomeWidget(),
    // );
  });

  group('HomeWidgetTest', () {
    testWidgets('HomeWidgetTestWithoutTestWidgetController', (tester) async {
      // Because of I use sizzle_starter's pumpWidget from test/helpers/test_widget_controller.dart
      // I initiate app here for a while
      app = TestAppWidget(
        dependencyContainer: HomeTestDependencyContainer(homeController: homeController),
        widget: HomeWidget(),
      );

      when(mockedUserRemoteService.user()).thenAnswer((_) async => kUser);

      when(mockedBookingRemoteService.getBookingsList()).thenAnswer((_) async => [kBookingSummary]);

      when(mockedInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => true);

      await homeController.load();

      await tester.pumpWidget(app);

      final findOneDismissibleButton = find.byKey(
        ValueKey("booked_home_dismissible_button_${kBookingSummary.id}"),
      );

      expect(findOneDismissibleButton, findsOneWidget);
    });

    testWidgets('HomeWidgetTestWithTestWidgetController', (tester) async {
      when(mockedUserRemoteService.user()).thenAnswer((_) async => kUser);

      when(mockedBookingRemoteService.getBookingsList()).thenAnswer((_) async => [kBookingSummary]);

      when(mockedInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => true);

      await homeController.load();

      // you can use either sizzle_starter's pump widget
      // from test/helpers/test_widget.controller
      await TestWidgetController(tester).pumpWidget(
        HomeWidget(),
        dependencies: HomeTestDependencyContainer(homeController: homeController),
      );

      final findOneDismissibleButton = find.byKey(
        ValueKey("booked_home_dismissible_button_${kBookingSummary.id}"),
      );

      expect(findOneDismissibleButton, findsOneWidget);
    });
  });
}

class TestAppWidget extends StatelessWidget {
  const TestAppWidget({super.key, required this.dependencyContainer, required this.widget});

  final DependencyContainer dependencyContainer;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(dependencies: dependencyContainer, child: MaterialApp(home: widget));
  }
}

final class HomeTestDependencyContainer extends TestDependencyContainer {
  HomeTestDependencyContainer({required HomeController homeController})
    : _homeController = homeController;

  final HomeController _homeController;

  @override
  HomeController get homeController => _homeController;
}
