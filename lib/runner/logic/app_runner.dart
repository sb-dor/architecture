import 'dart:async';
import 'dart:developer';
import 'package:architectures/runner/logic/dependencies_composition.dart';
import 'package:architectures/runner/widgets/material_context.dart';
import 'package:flutter/material.dart';

class AppRunner {
  Future<void> run() async {
    await runZonedGuarded(
      () async {
        final dependencies = await composeDependencies();
        runApp(MaterialContext(dependencyContainer: dependencies));
      },
      (error, stackTrace) {
        // log errors and stackTrace
        log("Error occurred:", error: error, stackTrace: stackTrace);
      },
    );
  }
}
