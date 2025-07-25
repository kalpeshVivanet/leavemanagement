import 'package:flutter/foundation.dart';

class AttendenceProvider with ChangeNotifier{
    bool? _isMarkedToday;
    bool _isLoading= false;

    bool get isMarkedToday => _isMarkedToday ?? false;

    bool get isLoading => _isLoading;

    Future<void> checkTodayAttendance(String userId)async{
      _isLoading = true;
      notifyListeners();

      await Future.delayed(Duration(seconds: 1));
      _isMarkedToday= false;
      _isLoading = false;
      notifyListeners();
    }

    Future<bool> markAttandance(String userId)async{
      _isLoading =true;
      notifyListeners();

      await Future.delayed(Duration(seconds: 2));
      _isMarkedToday = true;
      _isLoading =false;
      notifyListeners();
      return true;
    }
}