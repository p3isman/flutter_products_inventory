import 'dart:async';

import 'package:products/bloc/validators.dart';

import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _emailController = new BehaviorSubject<String>();
  final _passwordController = new BehaviorSubject<String>();

  // Get stream data
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  // Returns true if both streams have data
  Stream<bool> get validFormStream =>
      // Make sure streams have valid values after they change
      Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);

  // Add to stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Last entered email and password
  get email => _emailController.value;
  get password => _passwordController.value;

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
