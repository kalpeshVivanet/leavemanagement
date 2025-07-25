// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leave_management/routes/app_routes.dart';
import 'package:leave_management/screen/dashboared_screen.dart';
import 'package:provider/provider.dart';

import 'package:leave_management/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    bool _loading = false;
    String? _error;

    void _handleLogin() async {
      setState(() {
        _loading = true;
        _error = null;
      });

      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(_emailController.text, _passwordController.text);
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'UserName'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'password'),
            ),
            SizedBox(
              height: 10,
            ),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                     _handleLogin();
                    },
                    child: Text("Login")),
                    TextButton(onPressed: (){
                      Navigator.pushNamed(context, AppRoutes.signup);
                    }, child: Text("SignUp"))
          ],
        ),
      ),
    );
  }
}
