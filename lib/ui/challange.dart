import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../modle/challangeModle.dart';
import 'loginpage.dart';


class createChallange extends StatefulWidget {
  final String date;
  String userEmail;
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
                  title: new RaisedButton(
                    onPressed: ()=>makeChallange("morning"),
                    child: new Text("Morning"),
                    color: Colors.greenAccent.shade100,
                  )
              ),
              new ListTile(
                  title: new RaisedButton(
                    onPressed: ()=>makeChallange("evening"),
                    child: new Text("Evening"),
                    color: Colors.greenAccent.shade100,
                  )
              ),
              new ListTile(
                  title: new RaisedButton(
                    onPressed: ()=>makeChallange("night"),
                    child: new Text("Night"),
                    color: Colors.greenAccent.shade100,
                  )
              ),
            ],
          )
        ],
      ),
    );
  }



  void makeChallange(String time) {
    challangeModle.dateTime = "${widget.date}";
    challangeModle.time = time;
    challangeModle.count = 1;
    playerslist.add("${widget.userEmail}");
    challangeModle.players = playerslist;

    databaseReference.push().set(challangeModle.toJson());
  }

}










// Another widget;


class showChallanges extends StatefulWidget {

  String userEmail;

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

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
//        appBar: AppBar(
//          backgroundColor: Colors.greenAccent,
//          title: new Text("Challengs feed"),
//          centerTitle: true,
//        ),
        body: new Stack(
            children: <Widget>[
              new ListView(
                children: <Widget>[
                  new Container(
                    height:  MediaQuery.of(context).size.height-120,
                    child: new FirebaseAnimatedList(
                        query: databaseReference,
                        itemBuilder: (_, DataSnapshot snapshot,Animation<double> animation , int index){
                          return new Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            child: new Container(
                              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                              child: new ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(width: 1.0, color: Colors.white24))),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: Colors.white,
                                    child: new Text(snapshot.value['dateTime'].substring(5,10)),
                                  ),
                                ),
                                title:  Text(
                                    snapshot.value['dateTime'].toString(),
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                subtitle:  Text(
                                    "Time :  ${snapshot.value['time'].toString()}  "
                                    "\n Count :  ${snapshot.value['count'].toString() } ",
                                    style: TextStyle(color: Colors.white),
                                ),
                                trailing: new Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
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
                            )
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
        child: Icon(Icons.add,
        color: Colors.pinkAccent,),
        backgroundColor: Colors.white,
      ),
    );
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
  void getSharedPreference() async{
    final prefs = await SharedPreferences.getInstance();   //save username
    if(prefs.getString('userEmail') == null){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
      );
    }else{
      widget.userEmail = prefs.getString('userEmail');
    }
  }
}
