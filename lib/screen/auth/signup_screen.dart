import 'package:flutter/material.dart';
import 'package:leave_management/provider/auth_provider.dart';
import 'package:leave_management/routes/app_routes.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameContrller = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'Employee';
  bool _loading = false;
  String? _error;

  void _handleSignUP() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).signup(
          _nameContrller.text,
          _emailController.text,
          _passwordController.text,
          _role);
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
      _loading = false;
     
    });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameContrller,
                decoration: InputDecoration(labelText: 'name'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'email'),
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
              DropdownButtonFormField<String>(
                  value: _role,
                  decoration: InputDecoration(labelText: 'Role'),
                  items: [
                    DropdownMenuItem(value: 'Employee', child: Text('Employee')),
                    DropdownMenuItem(value: 'Manager', child: Text('Manager'))
                  ],
                  onChanged: (value) {
                    setState(() {
                      _role = value!;
                    });
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  _loading?
                  CircularProgressIndicator()
                  :ElevatedButton(onPressed: (){_handleSignUP();}, child: Text("SignUp")),
          
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
