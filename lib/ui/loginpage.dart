import 'package:flutter/material.dart';

import './signuppage.dart';
import './home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
                    onPressed: (){
                      var router = new MaterialPageRoute(
                          builder: (BuildContext context){
                            return new PickDate();
                          });
                      Navigator.of(context).push(router);
                    },
                    child: new Text("Login"),
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
