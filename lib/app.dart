import 'package:flutter/material.dart';
import 'package:leave_management/provider/auth_provider.dart';
import 'package:leave_management/routes/app_routes.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>AuthProvider())
    ],
    child: MaterialApp(
      title: 'Employee App',
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    ),
    
    );

  }
}