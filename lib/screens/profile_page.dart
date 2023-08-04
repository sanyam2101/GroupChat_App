import 'package:chatting_app/screens/auth/login_page.dart';
import 'package:chatting_app/screens/home_screen.dart';
import 'package:chatting_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.email, required this.userName})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService= AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 80),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15,),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 30,),
            const Divider(height: 2,),
            ListTile(onTap: (){
              nextScreenReplace(context, const HomeScreen());
            },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),

            ListTile(onTap: (){},
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),

            ListTile(onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: const Text("Log Out"),
                      content: const Text("Are you sure you want to Log Out?"),
                      actions: <Widget>[
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.cancel,color: Colors.red,)),

                        IconButton(onPressed: () async {
                          await authService.signOut();
                          Navigator.of(context)
                              .pushAndRemoveUntil(MaterialPageRoute(
                              builder: (context) => LoginPage()),
                                  (route) => false);
                        }, icon: Icon(Icons.exit_to_app,color: Colors.green,)),
                      ],
                    );
                  });
              // authService.signOut().whenComplete(() {
              //   nextScreenReplace(context, const LoginPage());
              // });
            },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Log Out",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //UserImagePicker(),
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 45,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Full Name", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                Text(widget.userName, style: const TextStyle(fontSize: 17),)
              ],
            ),
            const Divider(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Email", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                Text(widget.email, style: const TextStyle(fontSize: 17),),
              ],
            ),
            const Divider(height: 30,),
          ],
        ),
      ),
    );
  }
}
