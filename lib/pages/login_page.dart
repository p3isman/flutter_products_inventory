import 'package:flutter/material.dart';

import 'package:products/bloc/login_bloc.dart';
import 'package:products/bloc/provider.dart';
import 'package:products/pages/home_page.dart';
import 'package:products/pages/register_page.dart';
import 'package:products/providers/user_provider.dart';
import 'package:products/utils/utils.dart';

final _userProvider = UserProvider();
bool _disableButton = false;

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
            Color.fromRGBO(32, 160, 128, 1.0),
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
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 200.0,
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
                Text('Iniciar Sesi??n', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 10.0),
                _Email(bloc),
                _Password(bloc),
                SizedBox(height: 20.0),
                _Button(bloc),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, RegisterPage.routeName),
            child: Text(
              'Crear una nueva cuenta.',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          SizedBox(height: 100.0),
        ],
      ),
    );
  }

  static String? showError(snapshot) {
    if (snapshot.hasError) {
      return snapshot.error.toString();
    }
    return null;
  }
}

class _Email extends StatelessWidget {
  final LoginBloc bloc;

  _Email(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email),
              labelText: 'Correo electr??nico',
              hintText: 'ejemplo@correo.com',
              counterText: snapshot.data,
              errorText: _LoginForm.showError(snapshot),
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }
}

class _Password extends StatelessWidget {
  final LoginBloc bloc;

  _Password(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline),
              labelText: 'Contrase??a',
              counterText: snapshot.data,
              errorText: _LoginForm.showError(snapshot),
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }
}

class _Button extends StatefulWidget {
  final LoginBloc bloc;

  _Button(this.bloc);

  @override
  __ButtonState createState() => __ButtonState();
}

class __ButtonState extends State<_Button> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: widget.bloc.validFormStream,
      builder: (context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text('Iniciar sesi??n'),
          ),
          onPressed: _disableButton
              ? null
              : snapshot.hasData
                  ? () => _login(widget.bloc, context)
                  : null,
        );
      },
    );
  }

  void _login(LoginBloc bloc, BuildContext context) async {
    setState(() => _disableButton = true);
    Map<String, dynamic> info =
        await _userProvider.login(bloc.email, bloc.password);

    info['ok']
        ? Navigator.pushReplacementNamed(context, HomePage.routeName)
        : showAlert(
            context,
            getErrorMessage(
              info,
              action: 'login',
            ),
          );
    setState(() => _disableButton = true);
  }
}
