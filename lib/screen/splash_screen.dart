import 'package:flutter/material.dart';
import 'package:leave_management/provider/auth_provider.dart';
import 'package:leave_management/routes/app_routes.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
    _checkLoginStatus();
  }
  Future<void> _checkLoginStatus()async{
    final authProvider = Provider.of<AuthProvider>(context,listen: false);
    await authProvider.loadUser();
    if(authProvider.isLogging){
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }else{
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}