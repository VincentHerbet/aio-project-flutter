import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_services/firebaseauth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
            onPressed: ()async {
              await authService.signupwithgoogle(context);
            },
            icon: Icon(Icons.account_circle_rounded),
            label: Text("Signup in with Google")),

            ElevatedButton.icon(
            onPressed: ()async {
              await authService.signinwithgoogle(context).then((value) => Navigator.pop(context));
            },
            icon: Icon(Icons.account_circle_rounded),
            label: Text("Sign in with Google")),
          ],
        )
      ),
    );
  }
}
