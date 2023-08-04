import 'package:chatting_app/helper/helper_function.dart';
import 'package:chatting_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginUserWithEmailandPassword
      (String email, String password) async {
    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

      if(user!=null){
        return true;
      }
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }




  //register
  Future registerUserWithEmailandPassword
      (String fullName, String email, String password) async {
    try{
     User user = (await firebaseAuth.createUserWithEmailAndPassword(
         email: email, password: password)).user!;

     if(user!=null){
       //call our database service
       await DatabaseService(uid: user.uid).savingUserData(fullName, email);
       return true;
     }
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }



  //signout
  Future signOut() async {
    try{
      await helperFunction.saveUserLoggedInStatus(false);
      await helperFunction.saveUserNameSF("");
      await helperFunction.saveUserEmailSF("");
      await firebaseAuth.signOut();
    } catch(e){
      return null;
    }
  }
}