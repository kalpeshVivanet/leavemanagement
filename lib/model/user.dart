class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  UserModel({required this.uid, required this.name, required this.email,required this.role});
  factory UserModel.fromMap(Map<String,dynamic> map, String uid){
    return UserModel(uid: uid, name: map['name'], email: map['email'] , role: map['role']);
  }

  Map<String, dynamic> toMap(){
    return {
      'name':name,
      'email':email,
      'role':role
    };
  }
}