import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leave_management/model/user.dart';

class FirebaseAuthService {
   static final FirebaseAuthService _instance = FirebaseAuthService._();
   factory FirebaseAuthService() => _instance;
   FirebaseAuthService._();
   final FirebaseAuth _auth =FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<User?> login(String email, String password)async{
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
   }

   Future<User?> signUp(String name,String email, String password, String role)async{
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final uid = result.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'name':name,
        'email':email,
        'role':role,
      });
      return result.user;
   }

   Future<UserModel?> getCurrentUserProfile()async{
    final uid = _auth.currentUser?.uid;
    if(uid == null) return null;
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if(!snapshot.exists) return null;
    return UserModel.fromMap(snapshot.data()!,uid);
   }

   Future<void> logout() async => _auth.signOut();
}