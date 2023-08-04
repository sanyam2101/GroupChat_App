import 'package:chatting_app/helper/helper_function.dart';
import 'package:chatting_app/screens/chat_page.dart';
import 'package:chatting_app/services/database_service.dart';
import 'package:chatting_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool _isJoined = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await helperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getID(String res){
    return res.substring(0,res.indexOf("_"));
  }

  String getName(String r){
    return r.substring(r.indexOf("_")+1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
              color: Colors.white),),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(Icons.search, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
          _isLoading ? Center(child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,),)
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if(searchController.text.isNotEmpty){
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
            setState(() {
              searchSnapshot = snapshot;
              _isLoading = false;
              hasUserSearched = true;
            });
      });
    }
  }

  groupList(){
    return hasUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index) {
        return groupTile(
          userName,
          searchSnapshot!.docs[index]['groupId'],
          searchSnapshot!.docs[index]['groupName'],
          searchSnapshot!.docs[index]['admin'],
        );
        })
        : Container();
  }

  joinedOrNot(String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin){
    // function to check whether user already exists in the group
    joinedOrNot(userName,groupId,groupName,admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0,1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if(_isJoined){
            setState(() {
              _isJoined= !_isJoined;
            });
            showSnackBar(context, Colors.green, "Successfully joined the group $groupName");
            Future.delayed(Duration(seconds: 2),(){
              nextScreen(context, ChatPage(groupId: groupId, groupName: groupName, userName: userName));
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });
            showSnackBar(context, Colors.red, "Successfully left the group $groupName");
          }
        },
        child: _isJoined ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white,width: 1)
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text("Joined",style: TextStyle(color: Colors.white),),
        )
            : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text("Join Now",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
