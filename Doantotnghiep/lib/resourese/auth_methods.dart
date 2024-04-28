// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:doantotnghiep/models/User.dart';
//
// class AuthMethods {
//
//   // Firebase auth, will use to get user info and registration and signing
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Firebase Database, will use to get reference.
//   static final FirebaseDatabase _database = FirebaseDatabase.instance;
//   static final DatabaseReference _userReference = _database.reference().child("Users");
//
//   // current user getter
//   Future<FirebaseUser> getCurrentUser() async {
//     FirebaseUser currentUser;
//     currentUser = await _auth.currentUser();
//     return currentUser;
//   }
//
//   // gets auth state of user through out the life cycle of the app
//   Stream<FirebaseUser> get onAuthStateChanged {
//     return _auth.onAuthStateChanged;
//   }
//
//   //sign in current user with email and password
//   Future<FirebaseUser> handleSignInEmail(String email, String password) async {
//     final FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
//
//     assert(user != null);
//     assert(await user.getIdToken() != null);
//     final FirebaseUser currentUser = await _auth.currentUser();
//     assert(user.uid == currentUser.uid);
//
//     print('signInEmail succeeded: $user');
//
//     return user;
//   }
//
//   // register new user with phone email password details
//   Future<FirebaseUser> handleSignUp(phone, email, password) async {
//     final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     assert (user != null);
//     assert (await user.getIdToken() != null);
//     await addDataToDb(user, email, phone, password);
//     return user;
//   }
//
//   // after sign up, add user data to firebase realtime database
//   Future<void> addDataToDb(FirebaseUser currentUser, String username,
//       String phone, String password) async {
//
//     User user = User(
//         uid: currentUser.uid,
//         email: currentUser.email,
//         phone: phone,
//         password: password
//     );
//
//     _userReference
//         .child(currentUser.uid)
//         .set(user.toMap(user));
//   }
//
//   // Logs out current user from the application
//   Future<void> logout() async {
//     await _auth.signOut();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:doantotnghiep/models/User.dart' as local;

class AuthMethods {

  // Firebase auth, will use to get user info and registration and signing
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Firebase Database, will use to get reference.
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static final DatabaseReference _userReference = _database.reference().child("Users");

  // current user getter
  Future<local.User?> getCurrentUser() async {
    local.User? currentUser;
    final user = await _auth.currentUser;
    if (user != null) {
      currentUser = local.User(
        uid: user.uid,
        email: user.email ?? '', // handle nullable email
        phone: '', // you might want to handle phone differently
        password: '', // you might want to handle password differently
      );
    }
    return currentUser;
  }

  // gets auth state of user throughout the lifecycle of the app
  Stream<local.User?> get onAuthStateChanged {
    return _auth.authStateChanges().map((firebaseUser) => local.User.fromFirebaseUser(firebaseUser));
  }

  //sign in current user with email and password
  Future<local.User?> handleSignInEmail(String email, String password) async {
    final auth.UserCredential? userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = userCredential?.user;

    if (user != null) {
      assert(await user.getIdToken() != null);
      final currentUser = await _auth.currentUser;
      assert(user.uid == currentUser?.uid);

      print('signInEmail succeeded: $user');

      return local.User.fromFirebaseUser(user);
    } else {
      return null;
    }
  }

  // register new user with phone email password details
  Future<local.User?> handleSignUp(String phone, String email, String password) async {
    final auth.UserCredential? userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential?.user;
    if (user != null) {
      assert(await user.getIdToken() != null);
      await addDataToDb(user as local.User, email, phone, password);
      return local.User.fromFirebaseUser(user);
    } else {
      return null;
    }
  }

  // after sign up, add user data to firebase realtime database
  Future<void> addDataToDb(local.User currentUser, String email, String phone, String password) async {
    final user = local.User(
      uid: currentUser.uid,
      email: currentUser.email,
      phone: phone,
      password: password,
    );

    await _userReference.child(currentUser.uid).set(user.toMap());
  }

  // Logs out current user from the application
  Future<void> logout() async {
    await _auth.signOut();
  }
}
