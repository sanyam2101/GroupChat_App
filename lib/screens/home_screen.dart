import 'package:chatting_app/helper/helper_function.dart';
import 'package:chatting_app/screens/auth/login_page.dart';
import 'package:chatting_app/screens/profile_page.dart';
import 'package:chatting_app/screens/search_page.dart';
import 'package:chatting_app/services/auth_service.dart';
import 'package:chatting_app/services/database_service.dart';
import 'package:chatting_app/widgets/group_tile.dart';
import 'package:chatting_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  String email = "";
  AuthService authService= AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }


  //string manipulation for group id and group name from firebase
  String getID(String res){
    return res.substring(0,res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }


  gettingUserData() async {
    await helperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await helperFunction.getUserNameFromSF().then((value) {
      userName = value!;
    });

    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: (){
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search),
          ),

        ],
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          "Groups",
          style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 80),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15,),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 30,),
            const Divider(height: 2,),
            ListTile(onTap: (){},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),

            ListTile(onTap: (){
              nextScreenReplace(context, ProfilePage(email: email,userName: userName,));
            },
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,),
      ),
    );
  }

  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: true,
        context: context,
        builder: (context){
      return StatefulBuilder(
        builder: ((context, setState) {
        return AlertDialog(
          title: const Text(""
              "Create a group",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _isLoading == true
                  ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),)
                  : TextField(
                onChanged: (val) {
                  setState(() {
                    groupName = val;
                  });
                } ,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.red
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("CANCEL"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
            ),
            ElevatedButton(
              onPressed: () async {
                if(groupName!=""){
                  setState(() {
                    _isLoading=true;
                  });
                  DatabaseService(
                      uid: FirebaseAuth.instance.currentUser!.uid)
                      .createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete(() {
                        _isLoading = false;
                  });
                  Navigator.of(context).pop();
                  showSnackBar(context, Colors.green, "Group created successfully");
                }
              },
              child: const Text("CREATE"),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            ),
          ],
        );}
        )
      );
    });
  }


  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if(snapshot.hasData){
          if(snapshot.data['groups'] != null){
            if(snapshot.data['groups'].length != 0){
              return ListView.builder(
                  itemBuilder: (context, index) {
                    int reverseIndex = snapshot.data['groups'].length - index -1;
                    return GroupTile(
                        groupId: getID(snapshot.data['groups'][reverseIndex]),
                        groupName: getName(snapshot.data['groups'][reverseIndex]),
                        userName: snapshot.data['fullName']);
                  },
                itemCount: snapshot.data['groups'].length,

              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        }
        else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,),
          );
        }
      },
    );
  }

  noGroupWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,),
          ),
          const SizedBox(height: 20,),
          const Text(
            "You've not joined any groups. Tap on the add icon to create a group or also search from top search",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }


}

