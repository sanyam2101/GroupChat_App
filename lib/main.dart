import 'package:chatting_app/screens/auth/login_page.dart';
import 'package:chatting_app/screens/home_screen.dart';
import 'package:chatting_app/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/helper/helper_function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool _isSignedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await helperFunction.getUserLoggedInStatus().then((value) {
      if(value != null) {
        setState((){
          _isSignedIn = value;
        });
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Chat',
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      home: _isSignedIn ? const HomeScreen() : const LoginPage(),
    );
  }
}
