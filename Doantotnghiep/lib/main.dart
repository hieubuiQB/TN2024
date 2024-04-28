import 'package:flutter/material.dart';
import 'package:doantotnghiep/resourese/auth_methods.dart';
import 'package:doantotnghiep/screens/homepage.dart';
import 'package:doantotnghiep/screens/loginpages/login.dart';

import 'models/User.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<UserModel>(
        stream: _authMethods.onAuthStateChanged,
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
