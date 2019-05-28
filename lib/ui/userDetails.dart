import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../modle/user.dart';
import './home.dart';

class UserDetails extends StatefulWidget {
  String email;
  UserDetails({Key key,this.email}):super(key :key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference ;
  User user;

  var _name = new TextEditingController();
  var _mobile = new TextEditingController();


  @override
  void initState() {
    databaseReference = database.reference().child("UserDetails");
    user = new User('','','');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("User Details"),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Image.asset(
            'images/cover_two.jpg',
            fit: BoxFit.fill,
            width: 500,
            height: 1000,
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title : new TextField(
                  controller: _name,
                  decoration: new InputDecoration(
                    labelText: "Enter your name "
                  ),
                ),
              ),
              new ListTile(
                title : new TextField(
                  controller: _mobile,
                  decoration: new InputDecoration(
                      labelText: "Enter your mobile number "
                  ),
                ),
              ),
              new ListTile(
                title: new RaisedButton(
                    onPressed: uploadUserDetails,
                    child: new Text("Submit"),
                )
              )
            ],
          )
        ],
      ),
    );
  }
  void uploadUserDetails(){
    user.name = _name.text;
    user.mobile = _mobile.text;
    user.email = "${widget.email}";

    databaseReference.push().set(user.toJson());

    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new PickDate();
        });
    Navigator.of(context).push(router);
  }
}
