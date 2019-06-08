import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import './signuppage.dart';
import './home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    databaseReference = database.reference().child("user");
  }
  bool incorrectPassword  = false;
  var _username = new TextEditingController();
  var _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("Login"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.person_add),
              onPressed: (){
                  var router = new MaterialPageRoute(
                  builder: (BuildContext context){
                  return new SignUpPage();
                  });
                  Navigator.of(context).push(router);

              })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/cover_two.jpg',
              fit: BoxFit.fill,
              width: 500,
              height: 1000,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  controller: _username,
                  decoration: new InputDecoration(
                    labelText: "Enter the username",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.only(top: 30.0),
              ),
              new ListTile(
                title: new TextField(
                  controller: _password,
                  decoration: new InputDecoration(
                      labelText: "Enter the password",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      ),

                  ),
                ),
                contentPadding: EdgeInsets.only(top: 30.0),
              ),
              new ListTile(
                title: new RaisedButton(
                    onPressed: loginButton,
                    child: new Text("Login"),
                    color: Colors.greenAccent.shade100,
                ),
                contentPadding: EdgeInsets.only(top: 10.0),
              ),
            ],
          )
        ],
      ),
    );
  }

  void loginButton(){
    if(_username.text != '' && _password.text != ''){
      //login
     signInWithCredentials(_username.text, _password.text);
    }

  }

  void signInWithCredentials(String email, String password) async {
    FirebaseUser user;
    try{
      user = await _firebaseAuth.signInWithEmailAndPassword(
          email: _username.text,
          password: _password.text
      );
    }catch(e){
      print(e.toString());
    }finally{
      if(user != null){
        var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new PickDate(userEmail:_username.text);
            });
        Navigator.of(context).push(router);
      }else{
        print("Authentication failed");
      }
    }
  }
}
