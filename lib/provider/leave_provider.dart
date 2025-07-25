import 'package:flutter/material.dart';
import 'package:leave_management/core/authentication/leave_service.dart';
import 'package:leave_management/model/leave_model.dart';

class LeaveProvider with ChangeNotifier {
  List<LeaveModel> _leave = [];
  bool _isLoading = false;
  String? _error;
  bool _hasInitialized = false;

  List<LeaveModel> get leaveRequest => _leave;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasInitialized => _hasInitialized;

  Future<void> fetchLeave(String userId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _leave = await LeaveService.getLeave();
      _hasInitialized = true;
      
    } catch (e) {
      _error = e.toString();
      print('Error fetching leave: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> applyLeave(LeaveModel leave, String userId) async {
    try {
      _setLoading(true);
      _clearError();
      
      await LeaveService.applyLeave(leave);
      
    
      _leave.add(leave);
      notifyListeners();
      
     
      await fetchLeave(userId);
      
      return true;
    } catch (e) {
      _error = e.toString();
      print('Error applying leave: $e');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  void clearError() {
    _clearError();
  }

  void reset() {
    _leave.clear();
    _isLoading = false;
    _error = null;
    _hasInitialized = false;
    notifyListeners();
  }


  Future<void> refresh(String userId) async {
    _hasInitialized = false; 
    await fetchLeave(userId);
  }


  void updateLeaveStatus(String leaveId, String newStatus) {
    final index = _leave.indexWhere((leave) => leave.id == leaveId);
    if (index != -1) {
     
      final updatedLeave = LeaveModel(
        id: _leave[index].id,
        userId: _leave[index].userId,
        reason: _leave[index].reason,
        startDate: _leave[index].startDate,
        endDate: _leave[index].endDate,
        status: newStatus,
      );
      _leave[index] = updatedLeave;
      notifyListeners();
    }
  }

  int get pendingLeavesCount {
    return _leave.where((leave) => 
      leave.status?.toLowerCase() == 'pending').length;
  }

  int get approvedLeavesCount {
    return _leave.where((leave) => 
      leave.status?.toLowerCase() == 'approved').length;
  }


  int get rejectedLeavesCount {
    return _leave.where((leave) => 
      leave.status?.toLowerCase() == 'rejected').length;
  }
}