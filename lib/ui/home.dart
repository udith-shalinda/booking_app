import 'package:booking_app/modle/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


import './Date.dart';
import './feed.dart' as feed;
import './challange.dart' as challenge;
import './loginpage.dart';

//picking a date to book
class PickDate extends StatefulWidget {

  final String userEmail;
  PickDate({Key key,this.userEmail}):super(key :key);

  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> with SingleTickerProviderStateMixin {
   DateTime selectedDate = DateTime.now();
   TabController _controller;
   final FirebaseDatabase database = FirebaseDatabase.instance;
   DatabaseReference databaseReference;
    User user = new User('', '', '');

   @override
   void initState(){
     super.initState();
      _controller = new TabController(length: 2, vsync: this);
//     database.reference().child("UserDetails").orderByChild("email").equalTo("${widget.userEmail}")
//         .once().then((DataSnapshot snapshot){
//                print( snapshot.value);
//                String name = User.fromSnapshot(snapshot).name;
//                print(name);
//        });
      test();
     getUserDetails();
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
              new feed.NewsFeed(userEmail: widget.userEmail,),
              new challenge.showChallanges(userEmail: widget.userEmail,)
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
                    query: database.reference().child("UserDetails").orderByChild("email").equalTo("testthree@test.com"),
                    itemBuilder:(_, DataSnapshot snapshot,Animation<double> animation , int index){
//                      debugPrint("the index is : "+ index.toString());
                      return new Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: new ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                            leading: CircleAvatar(
//                              backgroundColor: Colors.redAccent,
//                            ),
                          title:  Text(snapshot.value['name'].toString()),
                          subtitle:  Text(snapshot.value['mobile']),
                          onTap: (){
                            debugPrint(snapshot.value['email'].toString());
                          },
                        ),
                      );
                    }
                ),
              ),
              new RaisedButton(
                color: Colors.blueGrey,
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
//     final prefs = await SharedPreferences.getInstance();
//     prefs.clear();

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

   void test() async{
     final prefs = await SharedPreferences.getInstance();
     print("user email from sharedPreferense " + prefs.getString("userEmail"));
   }

   void getUserDetails() async{
//          database.reference().child("UserDetails").orderByChild("name").equalTo("testthree@test.com")
//         .once().then((DataSnapshot snapshot){
//                print( snapshot.value);
////                String name = User.fromSnapshot(snapshot).name;
////                print(name);
//        });

   }
}
