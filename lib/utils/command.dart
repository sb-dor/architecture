// https://github.com/flutter/samples/blob/main/compass_app/app/lib/utils/command.dart
// https://docs.flutter.dev/app-architecture/case-study/ui-layer#command-objects

import 'package:flutter/foundation.dart';
import 'dart:async';

typedef CommandAction0<T> = Future<T> Function();
typedef CommandAction1<T, A> = Future<T> Function(A);

/// Facilitates interaction with a ViewModel.
///
/// Encapsulates an action,
/// exposes its running and error states,
/// and ensures that it can't be launched again until it finishes.
///
/// Use [Command0] for actions without arguments.
/// Use [Command1] for actions with one argument.
///
/// Actions must return a [Result].
///
/// Consume the action result by listening to changes,
/// then call to [clearResult] when the state is consumed.
abstract class Command<T> extends ChangeNotifier {
  Command();

  bool _running = false;
  bool _completed = false;
  bool _error = false;

  /// True when the action is running.
  bool get running => _running;

  /// true if action completed with error
  bool get error => _error;

  /// true if action completed successfully
  bool get completed => _completed;

  T? _result;

  /// Get last action result
  T? get result => _result;

  /// Clear last action result
  void clearResult() {
    _result = null;
    notifyListeners();
  }

  /// Internal execute implementation
  Future<void> _execute(CommandAction0<T> action) async {
    // Ensure the action can't launch multiple times.
    // e.g. avoid multiple taps on button
    if (_running) return;

    // Notify listeners.
    // e.g. button shows loading state
    _result = null;
    _running = true;
    _error = false;
    _completed = false;
    notifyListeners();

    try {
      _result = await action();
      _completed = true;
    } catch (error, stackTrace) {
      _error = true;
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// [Command] without arguments.
/// Takes a [CommandAction0] as action.
class Command0<T> extends Command<T> {
  Command0(this._action);

  final CommandAction0<T> _action;

  /// Executes the action.
  Future<void> execute() async {
    await _execute(_action);
  }
}

/// [Command] with one argument.
/// Takes a [CommandAction1] as action.
class Command1<T, A> extends Command<T> {
  Command1(this._action);

  final CommandAction1<T, A> _action;

  /// Executes the action with the argument.
  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}
