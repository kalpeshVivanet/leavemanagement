class LeaveModel {
  final String id;
  final String userId;
  final String reason;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  LeaveModel(
      {required this.id,
      required this.userId,
      required this.reason,
      required this.startDate,
      required this.endDate,
      required this.status});
  factory LeaveModel.fromMap(Map<String, dynamic> map) {
    return LeaveModel(
        id: map['id'],
        userId: map['userId'],
        reason: map['reason'],
        startDate: map['startDate'],
        endDate: map['endDate'],
        status: map['status']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'reason': reason,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status
    };
  }
}
