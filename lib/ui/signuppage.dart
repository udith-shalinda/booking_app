import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:async';

import './home.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var _username = new TextEditingController();
  var _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("Sign Up"),
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
                title: new TextField(
                  controller: _username,
                  decoration: new InputDecoration(
                      labelText: "Enter the username"
                  ),
                ),
              ),
              new ListTile(
                title: new TextField(
                  controller: _password,
                  decoration: new InputDecoration(
                      labelText: "Enter the password"
                  ),
                ),
              ),
              new ListTile(
                  title: new RaisedButton(
                    onPressed:  signUpWithEmail,
                  child: new Text("Sign Up"),
                    color: Colors.greenAccent.shade100,
                  )
              ),
            ],
          )
        ],
      ),
    );
  }

//  Future<FirebaseUser> signUpWithGmail() async{
//    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleSignInAuthentication.accessToken,
//      idToken: googleSignInAuthentication.idToken,
//    );
//    final FirebaseUser user = await _auth.signInWithCredential(credential);
//    if(user != null){
//      print("succed");
//    }else{
//      print("auth failed");
//    }
//    print("user name is : ${user.displayName}");
//    return user;
//
//
//  }
  Future<FirebaseUser> signUpWithEmail() async{
    FirebaseUser user;
    try{
      user = await _auth.createUserWithEmailAndPassword(
          email: _username.text,
          password: _password.text
      );
    }catch(e){
      print(e.toString());
    }finally{
      if(user != null){
        print("user created");
        var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new PickDate();
            });
        Navigator.of(context).push(router);
      }else{
        print("Authentication failed");
      }
    }
    return user;
  }
}



