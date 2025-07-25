import 'package:flutter/material.dart';
import 'package:leave_management/core/authentication/leave_service.dart';
import 'package:leave_management/model/leave_model.dart';

class LeaveProvider with ChangeNotifier{
  List<LeaveModel> _leave =[];
  bool _isLoading = false;
  List<LeaveModel> get leaveRequest => _leave;
  bool get isLoading => _isLoading;

  Future<void> fetchLeave(String userId)async{
_isLoading = true;
notifyListeners();
_leave = await LeaveService.getLeave();

_isLoading =false;
notifyListeners();
  }

  Future<void> applyLeave(LeaveModel leave, String userId)async{
    await LeaveService.applyLeave(leave);
    await fetchLeave(userId);
  }
}