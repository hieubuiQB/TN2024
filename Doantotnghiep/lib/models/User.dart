// import 'package:firebase_auth/firebase_auth.dart' as auth;
// class User{
//   late String uid;
//   late String phone;
//   late String email;
//   late String password;
//
//   User({
//     required this.uid,
//     required this.email,
//     required this.password,
//     required this.phone,
//   });
// // Method to convert FirebaseUser to User
//   static User fromFirebaseUser(auth.User? user) {
//     if (user == null) {
//       throw ArgumentError("User cannot be null");
//     }
//   Map toMap(User user) {
//     var data = Map<String, dynamic>();
//     data['uid'] = user.uid;
//     data['email'] = user.email;
//     data['phone']=user.phone;
//     data['password']=user.password;
//     return data;
//   }
//
//   User.fromMap(Map<String, dynamic> mapData) {
//     this.uid = mapData['uid'];
//     this.email = mapData['email'];
//     this.phone=mapData['phone'];
//     this.password=mapData["password"];
//   }
// }
import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  final String uid;
  final String? email; // Make email nullable
  final String phone;
  final String password;

  User({
    required this.uid,
    this.email,
    required this.phone,
    required this.password,
  });

  // Method to convert FirebaseUser to User
  static User fromFirebaseUser(auth.User? user) {
    if (user == null) {
      throw ArgumentError("User cannot be null");
    }

    return User(
      uid: user.uid,
      email: user.email,
      phone: '', // You might want to handle phone differently
      password: '', // You might want to handle password differently
    );
  }

  // Method to convert User to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}
