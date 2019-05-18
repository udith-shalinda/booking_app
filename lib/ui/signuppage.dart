import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

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
                    onPressed: ()=>debugPrint("Login button"),
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
}
