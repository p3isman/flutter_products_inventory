import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return n == null ? false : true;
}

void showAlert(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Información incorrecta'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              )
            ],
          ));
}

String getErrorMessage(Map<String, dynamic> info, {required String action}) {
  Map<String, String> errorCodes = {
    'EMAIL_NOT_FOUND': 'No existe una cuenta con ese correo',
    'INVALID_PASSWORD': 'Contraseña incorrecta',
    'USER_DISABLED': 'Esta cuenta ha sido desactivada',
    'EMAIL_EXISTS': 'Este correo ya pertenece a otra cuenta',
    'OPERATION_NOT_ALLOWED': 'Operación no permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Demasiados intentos. Prueba de nuevo más tarde',
  };

  if (errorCodes.containsKey(info['message'])) {
    return errorCodes[info['message']]!;
  }

  return action == 'login'
      ? 'No se ha podido iniciar sesión'
      : 'No se ha podido crear la cuenta';
}
