import 'dart:async';

// Class with stream transformers
class Validators {
  /// Acts as a filter for the password
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError('Debe contener al menos 6 caracteres.');
      }
    },
  );

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern.toString());

      if (regExp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError('Correo no válido.');
      }
    },
  );
}
