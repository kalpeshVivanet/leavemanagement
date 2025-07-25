import 'package:flutter/material.dart';
import 'package:leave_management/screen/auth/login_screen.dart';
import 'package:leave_management/screen/auth/signup_screen.dart';
import 'package:leave_management/screen/dashboared_screen.dart';
import 'package:leave_management/screen/leave_requst.dart';
import 'package:leave_management/screen/leavehistory_screen.dart';
import 'package:leave_management/screen/splash_screen.dart';

class AppRoutes {
   static const splash ='/';
   static const login ='/login';
   static const signup ='/signup';
   static const dashboard ='/dashboared';
   static const leaveRequest = '/leave-request';
   static const leaveHistory = '/leave-history';

   static Map<String, WidgetBuilder> routes ={
    splash:(_)=>SplashScreen(),
    login:(_)=>LoginScreen(),
    signup:(_)=>SignupScreen(),
    dashboard:(_)=>DashboardScreen(),
    leaveRequest:(_)=>LeaveRequestScreen(),
    leaveHistory:(_)=>LeavehistoryScreen()
   };
}