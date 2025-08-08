import 'dart:async';
import 'package:architectures/runner/logic/dependencies_composition.dart';
import 'package:architectures/runner/widgets/material_context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AppRunner {
  Future<void> run() async {
    final logger = appLogger(
      kReleaseMode ? NoOpLogFilter() : DevelopmentFilter(),
    );
    await runZonedGuarded(
      () async {
        final widgetBinding = WidgetsFlutterBinding.ensureInitialized();
        widgetBinding.deferFirstFrame();
        try {
          final dependencies = await composeDependencies(logger: logger);
          runApp(MaterialContext(dependencyContainer: dependencies));
        } catch (error) {
          rethrow;
        } finally {
          widgetBinding.allowFirstFrame();
        }
      },
      (error, stackTrace) {
        // log errors and stackTrace
        logger.log(
          Level.debug,
          "Error occurred:",
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }
}
