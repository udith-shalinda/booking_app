import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:async';

import './userDetails.dart';

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
  bool incorrectPassword = false;
  var _formKey = GlobalKey<FormState>();
  String _email;
  String _formpassword;

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
          new Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _username,
                    validator: (value){
                      String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = new RegExp(p);
                      if(value.length == 0 || !regExp.hasMatch(value)){
                        return "Invalid email";
                      }
                    },
                    onSaved: (value){
                      _email = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter the email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _password,
                    validator: (value){

                      if(value.length == 0){
                        return "Password is empty";
                      }
                    },
                    onSaved: (value){
                      _formpassword = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter the password",
                      errorText: incorrectPassword ? "User email or password is incorrect":null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: signUpWithEmail ,
                  color: Colors.greenAccent,
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 16.9),
                  ),
                  textColor: Colors.white70,
                )
              ],
            ),
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
        incorrectPassword = false;
        print("user created");
        var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new UserDetails(email:_username.text);
            });
        Navigator.of(context).push(router);
      }else{
        print("Authentication failed");
        setState(() {
          incorrectPassword = true;
        });
      }
    }
    return user;
  }
}



