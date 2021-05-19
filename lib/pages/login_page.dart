import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static final routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _LoginBackground(),
          _LoginForm(),
        ],
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final background = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ],
        ),
      ),
    );

    final circle = Container(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    return Stack(
      children: [
        background,
        Positioned(child: circle, left: 30.0, top: 60.0),
        Positioned(child: circle, right: -30.0, top: -30.0),
        Container(
          margin: EdgeInsets.only(top: size.height * 0.1),
          child: Column(
            children: [
              Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 80.0,
              ),
              SizedBox(
                height: 25.0,
                width: double.infinity,
              ),
              Text('Rutinas Becofit',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
            ],
          ),
        )
      ],
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: size.height * 0.30,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 20.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 5.0),
                  )
                ]),
            child: Column(
              children: [
                Text('Iniciar Sesión', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 10.0),
                _Email(),
                _Password(),
                SizedBox(height: 20.0),
                _Button(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Email extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(Icons.alternate_email),
          labelText: 'Correo electrónico',
          hintText: 'ejemplo@correo.com',
        ),
      ),
    );
  }
}

class _Password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline),
          labelText: 'Contraseña',
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 10.0)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Text('Iniciar sesión'),
      ),
      onPressed: () {},
    );
  }
}
