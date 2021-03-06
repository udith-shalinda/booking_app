import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modle/bookModle.dart';
import 'loginpage.dart';

//booking a date
class Date extends StatefulWidget {
  final String date;
   String userEmail;
  Date({Key key,this.date}):super(key :key);

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {


  List<BookModle> bookedDatesList = List();
  BookModle bookModle;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  String key;

  @override
  void initState() {
    super.initState();

    bookModle = new BookModle("", false,false,false,'','','');
    databaseReference = database.reference().child("bookedTimes");
    databaseReference.onChildAdded.listen(_OnEntryAdded);
    getSharedPreference();
    try{
      database.reference().child("bookedTimes").orderByChild("dateTime").equalTo("${widget.date}").once().then((DataSnapshot snapshot){
        if(snapshot.value == null){
          handleSubmition();
        }else{
          print(snapshot.value);
          print(snapshot.value);
        }
//        print(snapshot.value);
      });
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("Schedule of Date"),
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
              new Container(
                height: 400,
                child: new FirebaseAnimatedList(
                    query: database.reference().child("bookedTimes").orderByChild("dateTime").equalTo("${widget.date}"),
                    itemBuilder:(_, DataSnapshot snapshot,Animation<double> animation , int index){
//                      debugPrint("the index is : "+ index.toString());
                      return new Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: new ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                            leading: CircleAvatar(
//                              backgroundColor: Colors.redAccent,
//                            ),
                          title:  Text(snapshot.value['dateTime'].toString()),
                          subtitle:  Text("Morning :  ${snapshot.value['morning'].toString()}  ${snapshot.value['morningPlayer'].toString()} "
                              "\n Evening :  ${snapshot.value['evening'].toString() } ${snapshot.value['eveningPlayer'].toString()}"
                              "\n Night :  ${snapshot.value['night'].toString()} ${snapshot.value['nightPlayer'].toString()}"),
                          onTap: (){
                            debugPrint(snapshot.value['night'].toString());
                          },
                        ),
                      );
                    }
                ),
              ),
              new RaisedButton(
                onPressed: (){
                  if(bookModle.morning == false ){
                    updatetheBooking("morning");
                  }
                },
                child: new Text(bookModle.morning == true ? "Morning : Already Booked": "Mornig:Book Morning"),
                color: (bookModle.morning == false)? Colors.red : Colors.blue,

              ),
              new RaisedButton(
                onPressed: (){
                  if(bookModle.evening ==false)
                    updatetheBooking("evening");
                },
                child: new Text(bookModle.evening == true ? "Evening : Already Booked": "Evening : Book Evening"),
                color: (bookModle.evening == false)? Colors.red : Colors.blue,
              ),
              new RaisedButton(
                onPressed: (){
                  if(bookModle.night == false)
                    updatetheBooking("night");
                },
                child: new Text(bookModle.night == true ? "Night : Already Booked": "Night : Book Night"),
                color: (bookModle.night == false)? Colors.red : Colors.blue,
                elevation: 4.0,
                splashColor: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _OnEntryAdded(Event event) {
    bookedDatesList.add(BookModle.fromSnapshot(event.snapshot));
    setState(() {
      if(event.snapshot.value['dateTime'] == widget.date){
        key = event.snapshot.key;
        bookModle.morning = event.snapshot.value['morning'];
        bookModle.evening = event.snapshot.value['evening'];
        bookModle.night = event.snapshot.value['night'];
      }
    });
  }

  void handleSubmition() {
    bookModle.dateTime = "${widget.date}";
    bookModle.morning = false;
    bookModle.evening = false;
    bookModle.night= false;

    databaseReference.push().set(bookModle.toJson());
  }

  void updatetheBooking(String time){
    if(time == "morning"){
      //update the morning
      setState(() {
        bookModle.morning = true;
      });
      databaseReference.child(key).child("morning").set(true);
      databaseReference.child(key).child("morningPlayer").set(widget.userEmail);
    }else if(time == "evening"){
      //update the evening;
      setState((){
        bookModle.evening = true;
      });
      databaseReference.child(key).child("evening").set(true);
      databaseReference.child(key).child("eveningPlayer").set(widget.userEmail);
    }else{
      //update the night;
      setState(() {
        bookModle.night = true;
      });
      databaseReference.child(key).child("night").set(true);
      databaseReference.child(key).child("nightPlayer").set(widget.userEmail);
    }
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