import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:date_format/date_format.dart';

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
  List<String> playerslist = [];
  String key;

    var _time = new TextEditingController();

  @override
  void initState() {
    super.initState();

    databaseReference = database.reference().child("Challanges");
    challangeModle = new ChallangeModle('', '', 0,playerslist);
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
    challangeModle.time = "${_time.text}";
//    challangeModle.count = int.parse(_countofyourteam.text);
    challangeModle.count = 1;
    playerslist.add("${widget.userEmail}");
    challangeModle.players = playerslist;

    databaseReference.push().set(challangeModle.toJson());
  }

}










// Another widget;


class showChallanges extends StatefulWidget {

  final String userEmail;
  showChallanges({Key key,this.userEmail}):super(key:key);

  @override
  _showChallangesState createState() => _showChallangesState();
}

class _showChallangesState extends State<showChallanges> {

  DateTime selectedDate = DateTime.now();
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
//        appBar: AppBar(
//          backgroundColor: Colors.greenAccent,
//          title: new Text("Challengs feed"),
//          centerTitle: true,
//        ),
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
                                  ),
                              onTap: (){
                                List<String> list = [];
                                bool isAlreadypart = false;
                                for(int i=0;i<snapshot.value['count'];i++){
                                  list.add(snapshot.value['players'][i].toString());
                                  if(widget.userEmail == snapshot.value['players'][i].toString()){
                                    isAlreadypart = true;
                                  }
                                }
                                if(!isAlreadypart){
                                  list.add(widget.userEmail);
                                  addToTheMatch(snapshot.key,snapshot.value['count'],list);
                                }
                              },
                            ),
                          );
                        }
                    ),
                  ),

                ],
              )
            ]
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _makeAChallange(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }


  void _OnEntryAdded(Event event) {
    setState(() {
      challangsList.add(ChallangeModle.fromSnapshot(event.snapshot));
    });
  }
  void addToTheMatch(String key,int count,List<String> list){
    databaseReference.child(key).child('players').set(list);
    databaseReference.child(key).child('count').set(count+1);
  }

  Future<Null> _makeAChallange(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate : DateTime.now(),
        firstDate: DateTime(2019, 5),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        if(selectedDate.isAfter(DateTime.now())){
          var router = new MaterialPageRoute(
              builder: (BuildContext context){
                return new createChallange(date: formatDate(selectedDate, [yyyy, '-', mm, '-', dd]),userEmail:widget.userEmail);     //this should be changed;
              });
          Navigator.of(context).push(router);
        }
      });
  }
}
