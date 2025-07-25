class LeaveModel {
  final String id;
  final String userId;
  final String? reason; 
  final String? leaveType; 
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  LeaveModel({
    required this.id,
    required this.userId,
    this.reason, 
    this.leaveType, 
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory LeaveModel.fromMap(Map<String, dynamic> map) {
    return LeaveModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      reason: map['reason'], 
      leaveType: map['leaveType'], 
      startDate: map['startDate'] is String 
          ? DateTime.parse(map['startDate']) 
          : map['startDate'] as DateTime,
      endDate: map['endDate'] is String 
          ? DateTime.parse(map['endDate']) 
          : map['endDate'] as DateTime,
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'reason': reason,
      'leaveType': leaveType, 
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
    };
  }
}