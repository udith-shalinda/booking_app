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
  List<String> players;
  String key;

    var _time = new TextEditingController();
    var _countofyourteam= new TextEditingController();

  @override
  void initState() {
    super.initState();

    databaseReference = database.reference().child("Challanges");
    challangeModle = new ChallangeModle('', '', '', 0,players);
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
    players.add("${widget.userEmail}");
    challangeModle.players = players;

    databaseReference.push().set(challangeModle.toJson());
  }

}










// Another widget;


class showChallanges extends StatefulWidget {
  @override
  _showChallangesState createState() => _showChallangesState();
}

class _showChallangesState extends State<showChallanges> {
  List<ChallangeModle> challangsList= List();
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;


  @override
  void initState() {
    super.initState();
    databaseReference = database.reference().child("Challanges");
    databaseReference.onChildAdded.listen(_OnEntryAdded);

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: new Text("Challengs feed"),
          centerTitle: true,
        ),
        body: new Stack(
            children: <Widget>[
              new Center(
                child: new Image.asset(
                  'images/cover_one.jpg',
                  fit: BoxFit.cover,
                  width:  MediaQuery.of(context).size.width,
                  height:  MediaQuery.of(context).size.height,
                ),
              ),
              new ListView(
                children: <Widget>[
                  new Container(
                    height:  MediaQuery.of(context).size.height,
                    child: new FirebaseAnimatedList(
                        query: databaseReference,
                        itemBuilder: (_, DataSnapshot snapshot,Animation<double> animation , int index){
                          return new Card(
                            child: new ListTile(
//                            leading: CircleAvatar(
//                              backgroundColor: Colors.redAccent,
//                            ),
                              title:  Text(snapshot.value['dateTime'].toString()),
                              subtitle:  Text("Time :  ${snapshot.value['time'].toString()}  "
                                  "\n Count :  ${snapshot.value['count'].toString() } "
                                  "\n Creater :  ${snapshot.value['creater'].toString()}"),
                              onTap: (){
                                addToTheMatch(snapshot.key,snapshot.value['count']);
                              },
                            ),
                          );
                        }
                    ),
                  ),

                ],
              )
            ]
        )
    );
  }


  void _OnEntryAdded(Event event) {
    setState(() {
      challangsList.add(ChallangeModle.fromSnapshot(event.snapshot));
    });
  }
  void addToTheMatch(String key,int count){
    databaseReference.child(key).child('count').set(count+1);

  }
}
