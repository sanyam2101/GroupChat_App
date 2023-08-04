import 'dart:io';

import 'package:chatting_app/helper/helper_function.dart';
import 'package:chatting_app/screens/auth/login_page.dart';
import 'package:chatting_app/screens/home_screen.dart';
import 'package:chatting_app/services/auth_service.dart';
import 'package:chatting_app/widgets/user_image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  //File? userImage;
  AuthService authService = AuthService();

  // void _pickedImage(File image){
  //   userImage = image;
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Groupie",
          style: TextStyle(
            color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 36),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,))
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
                const SizedBox(height: 5),
                const Text("Create your account now to chat",style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w400,
                ),),
                Image.asset("assets/register.png", height: 260,width: 330,),
            UserImagePicker(),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                labelText: "Full Name",
                labelStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,),
                prefix: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,),
              ),
              onChanged: (val) {
                setState(() {
                  fullName=val;
                });
              },
              validator: (val) {
                if(val!.isNotEmpty){
                  return null;
                }
                else {
                  return "Name cannot be empty";
                }
              },
            ),
                SizedBox(height: 15,),
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
                      register();
                    },
                    child: Text("Register",style: TextStyle(color: Colors.white, fontSize: 16),),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                Text.rich(TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(color: Colors.black,fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Login now",
                      style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        nextScreen(context, const LoginPage());
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
  register() async {
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if(value==true){
          //saving the shared preference state
          await helperFunction.saveUserLoggedInStatus(true);
          await helperFunction.saveUserNameSF(fullName);
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
