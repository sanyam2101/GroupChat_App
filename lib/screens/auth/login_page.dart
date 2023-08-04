import 'package:chatting_app/screens/auth/register_page.dart';
import 'package:chatting_app/services/auth_service.dart';
import 'package:chatting_app/services/database_service.dart';
import 'package:chatting_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/helper/helper_function.dart';

import '../home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  AuthService authService= AuthService();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title:  const Text("Groupie",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,color: Colors.black),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(
                   color: Theme.of(context).primaryColor,),)
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // const Text("Groupie",
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 40),
                // ),
                //const SizedBox(height: 5),
                const Text("Login now to see chats",style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w400,
                ),),
                Image.asset("assets/login.png"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "E-mail",
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,),
                    prefix: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,),
                  ),
                  onChanged: (val) {
                    setState(() {
                      email=val;
                    });
                  },
                  validator: (val){
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,),
                    prefix: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,),
                  ),
                  onChanged: (val) {
                    setState(() {
                      password=val;
                    });
                  },
                  validator: (val){
                    if(val!.length < 6){
                      return "Password must be atleast 6 characters";
                    }
                    else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 15,),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: (){
                      login();
                  },
                    child: const Text("Sign in",style: TextStyle(color: Colors.white, fontSize: 16),),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                 Text.rich(TextSpan(
                 text: "Don't have an account? ",
                 style: const TextStyle(color: Colors.black,fontSize: 14),
                 children: <TextSpan>[
                   TextSpan(
                     text: "Register here",
                     style: const TextStyle(
                         color: Colors.black,
                         decoration: TextDecoration.underline),
                     recognizer: TapGestureRecognizer()..onTap = () {
                       nextScreen(context, const RegisterPage());
                     },
                   ),
                 ],
                )
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  login() async {
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.loginUserWithEmailandPassword(email, password)
          .then((value) async {
        if(value==true){
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);

          // saving values to our shared preferences
          await helperFunction.saveUserLoggedInStatus(true);
          await helperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);
          await helperFunction.saveUserEmailSF(email);

          nextScreenReplace(context, const HomeScreen());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
