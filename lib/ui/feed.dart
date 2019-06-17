import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../modle/bookModle.dart';
import './Date.dart';
import 'loginpage.dart';

class NewsFeed extends StatefulWidget {
  String userEmail;

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {

  DateTime selectedDate = DateTime.now();
  List<BookModle> bookedDatesList = List<BookModle>();
  //BookModle bookModle;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;


  @override
  void initState() {
    super.initState();
    databaseReference = database.reference().child("bookedTimes");
    databaseReference.onChildAdded.listen(_OnEntryAdded);
    getSharedPreference();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
//      appBar: AppBar(
//        backgroundColor: Colors.greenAccent,
//        title: new Text("News feed"),
//        centerTitle: true,
//      ),
      body: new Stack(
        children: <Widget>[
//          new Center(
//          child: new Image.asset(
//            'images/cover_one.jpg',
//            fit: BoxFit.cover,
//            width:  MediaQuery.of(context).size.width,
//            height:  MediaQuery.of(context).size.height - 100,
//            ),
//          ),
          new ListView(
            children: <Widget>[
              new Container(
                height:  MediaQuery.of(context).size.height-120,
                child: new FirebaseAnimatedList(
                    query: database.reference().child("bookedTimes"),
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
                                "Morning : "+ (snapshot.value['morning']==true ? " Booked by ${snapshot.value['morningPlayer'].toString()}" : "Book Now")+
                                "\n Evening : "+ (snapshot.value['evening']==true ? " Booked by ${snapshot.value['eveningPlayer'].toString()}" : "Book Now")+
                                "\n Night :  "+ (snapshot.value['night']==true ? " Booked by ${snapshot.value['nightPlayer'].toString()}" : "Book Now"),
                                style: TextStyle(color: Colors.white)
                            ),
                            trailing: new Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),

                            onTap: (){
                              bookADate(snapshot.value['dateTime']);
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
          return _selectDate(context);
        },
        //add a date
        child: Icon(Icons.add,
        color: Colors.pinkAccent,),
        backgroundColor: Colors.white,
      ),
    );
  }


  void _OnEntryAdded(Event event) {
    setState(() {
      bookedDatesList.add(BookModle.fromSnapshot(event.snapshot));
    });
//    print()
  }
  Future<Null> _selectDate(BuildContext context) async {
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
                return new Date(date: formatDate(selectedDate, [yyyy, '-', mm, '-', dd]));
              });
          Navigator.of(context).push(router);
        }
      });
  }

  void bookADate(String date) async{
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new Date(date: date );
        });
    Navigator.of(context).push(router);
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
