import 'package:flutter/material.dart';
import 'package:leave_management/core/authentication/firebase_auth_service.dart';
import 'package:leave_management/model/user.dart';

class AuthProvider extends ChangeNotifier{
  final _authService = FirebaseAuthService();
  UserModel? _user;
  UserModel? get user => _user;

  bool get isLogging => _user != null;



  Future<void> login(String email,String password) async{
    final user = await _authService.login(email, password);
    if(user != null){
      _user = await _authService.getCurrentUserProfile();
      notifyListeners();
    }
  }
  Future<void> signup(String name, String email,String password, String role)async{
    final user = await _authService.signUp(name, email, password, role);
    if(user != null){
      _user = await _authService.getCurrentUserProfile();
      notifyListeners();
    }
  }

  Future<void> logout()async{
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
  Future<void> loadUser()async{
    _user = await _authService.getCurrentUserProfile();
    notifyListeners();
  }
}