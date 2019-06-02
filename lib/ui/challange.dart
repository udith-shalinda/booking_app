import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../modle/bookModle.dart';
import '../modle/challangeModle.dart';


class createChallange extends StatefulWidget {
  final String date;
  final String userEmail;
  createChallange({Key key,this.date,this.userEmail}):super(key:key);

  @override
  _createChallangeState createState() => _createChallangeState();
}

class _createChallangeState extends State<createChallange> {

  ChallangeModle challangeModle;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  String key;

    var _time = new TextEditingController();
    var _countofyourteam= new TextEditingController();

  @override
  void initState() {
    super.initState();

    databaseReference = database.reference().child("Challanges");
    challangeModle = new ChallangeModle('', '', '', 0);
//    try{
//      database.reference().child("bookedTimes").orderByChild("dateTime").equalTo("${widget.date}").once().then((DataSnapshot snapshot){
//        if(snapshot.value == null){
//          handleSubmition();
//        }
//        print(snapshot.value);
//      });
//    }catch(e){
//      print(e);
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("Create a challange"),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/cover_one.jpg',
              fit: BoxFit.cover,
              width: 500,
              height: 1000,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  controller: _time,
                  decoration: new InputDecoration(
                      labelText: "Enter the username"
                  ),
                ),
              ),
              new ListTile(
                title: new TextField(
                  controller: _countofyourteam,
                  decoration: new InputDecoration(
                      labelText: "Enter the password"
                  ),
                ),
              ),
              new ListTile(
                  title: new RaisedButton(
                    onPressed: makeChallange,
                    child: new Text("Make challange"),
                    color: Colors.greenAccent.shade100,
                  )
              ),
            ],
          )
        ],
      ),
    );
  }



  void makeChallange() {
    challangeModle.dateTime = "${widget.date}";
    challangeModle.creater = "${widget.userEmail}";
    challangeModle.time = "${_time.text}";
    challangeModle.count = int.parse(_countofyourteam.text);

    databaseReference.push().set(challangeModle.toJson());
  }

}




//class showChallanges extends StatefulWidget {
//  @override
//  _showChallangesState createState() => _showChallangesState();
//}
//
//class _showChallangesState extends State<showChallanges> {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
