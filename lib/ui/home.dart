import 'dart:io';

import 'package:booking_app/modle/user.dart';
import 'package:booking_app/ui/userDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';




import './Date.dart';
import './feed.dart' as feed;
import './challange.dart' as challenge;
import './loginpage.dart';

//picking a date to book
class PickDate extends StatefulWidget {

   String userEmail='';

  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> with SingleTickerProviderStateMixin {
   DateTime selectedDate = DateTime.now();
   String email;
   TabController _controller;
   final FirebaseDatabase database = FirebaseDatabase.instance;
   DatabaseReference databaseReference;
    User user = new User('', '', '');

   @override
   void initState(){
     super.initState();
     getSharedPreference();
      _controller = new TabController(length: 2, vsync: this);
     //getProfileImage(); popup an error
   }


   @override
   void dispose() {
      _controller.dispose();
   }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(52, 66, 86, 1.0),
        title: new Text("Home"),
        centerTitle: true,
        bottom: TabBar(
            indicatorColor: Colors.redAccent,
//          labelColor: Colors.black,
          controller: _controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home),),
            new Tab(icon: new Icon(Icons.flag),)
          ],
        ),
      ),
      body: new TabBarView(
          controller: _controller,
          children: <Widget>[
              new feed.NewsFeed(),
              new challenge.showChallanges()
          ],),
      drawer: new Drawer(
        child: new Container(
          color: Color.fromRGBO(64, 75, 96, .9),
          child: new ListView(
            children: <Widget>[
              new DrawerHeader(
                child: new CircleAvatar(
                  radius: 45.0,
                  child: new Icon(Icons.person_outline,size: 55,color: Colors.white,),
                  backgroundColor: Color.fromRGBO(64, 75, 96, .9),
                ),
                decoration: BoxDecoration(
                  color:Color.fromRGBO(52, 66, 86, 1.0),
                ),
              ),
              new Container(
                height: 400,
                child: new FirebaseAnimatedList(
                    query: database.reference().child("UserDetails").orderByChild("email").equalTo("$email"),
                    itemBuilder:(_, DataSnapshot snapshot,Animation<double> animation , int index){
//                      debugPrint("the index is : "+ index.toString());
                      return new Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
                        child: Container(
                            decoration: BoxDecoration(color: Color.fromRGBO(56, 70, 96, 1)),
                          child: new ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            title:  Text(
                              snapshot.value['name'].toString() ,
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            subtitle:  Text(snapshot.value['mobile'],
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            onTap:updateProfile,
                          ),
                        )
                      );
                    }
                ),
              ),
              new RaisedButton(
                  onPressed: updateProfile,
                  color: Color.fromRGBO(56, 70, 96, .9),
                  child: Text(
                      "Update profile",
                      style: TextStyle(
                        color: Colors.white,

                      ),
                  ),
              ),
              new RaisedButton(
                color: Color.fromRGBO(56, 70, 96, .9),
                onPressed: signout,
                child: new Text(
                  "Sign out",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 19
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signout() async {
     await FirebaseAuth.instance.signOut();
     final prefs = await SharedPreferences.getInstance();
     prefs.clear();

//     var router = new MaterialPageRoute(
//         builder: (BuildContext context){
//           return new LoginPage();
//         });
//     Navigator.of(context).push(router);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
    );

  }

//   void getUserDetails() async{
//          database.reference().child("UserDetails").orderByChild("name").equalTo("testthree@test.com")
//         .once().then((DataSnapshot snapshot){
//                print( snapshot);
////                String name = User.fromSnapshot(snapshot).name;
////                print(name);
//        });
//
//   }
   void updateProfile(){
             var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new UserDetails();
            });
        Navigator.of(context).push(router);
   }

   void getSharedPreference() async{
     final prefs = await SharedPreferences.getInstance();   //save username
     if(prefs.getString('userEmail') == null){
       Navigator.pushAndRemoveUntil(
         context,
         MaterialPageRoute(builder: (context) => LoginPage()),
             (Route<dynamic> route) => false,
       );
     }else{
       widget.userEmail = prefs.getString('userEmail');
       email = prefs.getString('userEmail');
     }
   }

   Future<String> getProfileImage() async{
     File imageFile;
     final ref = FirebaseStorage.instance
         .ref()
         .child('profileImages').child("profileImages");

     ref.putFile(imageFile);
     var url = await ref.getDownloadURL() as String;
     print("Image url is "+ url);
  }
}
