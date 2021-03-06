import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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

  var _formKey = GlobalKey<FormState>();
  String _email;
  String _formpassword;


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
                    obscureText: true,
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
                  onPressed: loginButton ,
                  color: Colors.greenAccent,
                  child: Text(
                  'Login',
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

  void loginButton(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      signInWithCredentials(_email, _formpassword);
    }
  }

  void signInWithCredentials(String email, String password) async {
    FirebaseUser user;
    final prefs = await SharedPreferences.getInstance();   //save username
    try{
      user = await _firebaseAuth.signInWithEmailAndPassword(
          email: _username.text,
          password: _password.text
      );
    }catch(e){
      print(e.toString());
    }finally{
      if(user != null){
        incorrectPassword = false;
        prefs.setString("userEmail", _email);
        var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new PickDate();
            });
        Navigator.of(context).push(router);
      }else{
        print("Authentication failed");
        setState(() {
          incorrectPassword = true;
        });
      }
    }
  }
}
