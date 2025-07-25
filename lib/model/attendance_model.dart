class AttendanceModel {
  final String date;
  final bool isPresent;
  AttendanceModel({required this.date,required this.isPresent});
  factory AttendanceModel.fromMap(Map<String, dynamic> map){
    return AttendanceModel(date: map['date'], isPresent: map['isPresent']);

  }

  Map<String, dynamic> toMap(){
    return {
      'date':date,
      'isPresent':isPresent
    };
  }
}