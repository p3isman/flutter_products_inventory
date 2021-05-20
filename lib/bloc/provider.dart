import 'package:flutter/material.dart';
import 'package:products/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  Provider._({Key? key, required Widget child}) : super(key: key, child: child);

  // factory prevents from creating a new instance
  factory Provider({Key? key, required Widget child}) {
    // We need it to be static to access it from the factory constructor (without instancing)
    Provider _instance = new Provider._(key: key, child: child);
    return _instance;
  }

  final loginBloc = LoginBloc();

  /// Of method returns the LoginBloc instance
  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!.loginBloc;
  }

  // Notify listeners when updated
  @override
  bool updateShouldNotify(Provider oldWidget) {
    return true;
  }
}
