import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leave_management/model/leave_model.dart';

class LeaveService {
  static final _firestore = FirebaseFirestore.instance;
  static Future<List<LeaveModel>> getLeave([String? userId]) async {
    final snapshot = await _firestore.collection('leaves').get();
    return snapshot.docs.map((doc) => LeaveModel.fromMap(doc.data())).toList();
  }

  static Future<void> applyLeave(LeaveModel leave) async {
    await _firestore.collection('leaves').add(leave.toMap());
  }
}
