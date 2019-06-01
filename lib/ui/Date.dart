import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../modle/bookModle.dart';


class Date extends StatefulWidget {
  final String date;
  Date({Key key,this.date}):super(key :key);

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {


  List<BookModle> bookedDatesList = List();
  BookModle bookModle;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference ;
  String key;

  @override
  void initState() {
    super.initState();

    bookModle = new BookModle("", false,false,false);
    databaseReference = database.reference().child("bookedTimes");
    databaseReference.onChildAdded.listen(_OnEntryAdded);

    try{
      database.reference().child("bookedTimes").orderByChild("dateTime").equalTo("${widget.date}").once().then((DataSnapshot snapshot){
        if(snapshot.value == null){
          handleSubmition();
        }
        print(snapshot.value);
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
                        child: new ListTile(
//                            leading: CircleAvatar(
//                              backgroundColor: Colors.redAccent,
//                            ),
                          title:  Text(snapshot.value['dateTime'].toString()),
                          subtitle:  Text("Morning :  ${snapshot.value['morning'].toString()} "
                              "\n Evening :  ${snapshot.value['evening'].toString()}"
                              "\n Night :  ${snapshot.value['night'].toString()}"),
                          onTap: (){
                            debugPrint(snapshot.value['key'].toString());
                          },
                        ),
                      );
                    }
                ),
              ),
              new RaisedButton(
                  onPressed: (){
                    updatetheBooking("morning");
                  },
                  child: new Text(bookModle.morning == true ? "Booked": "Book Morning"),
                  color: (bookModle.morning == false)? Colors.red : Colors.blue,

              ),
              new RaisedButton(
                onPressed: (){
                  updatetheBooking("evening");
                },
                child: new Text(bookModle.evening == true ? "Booked": "Book Evening"),
                color: (bookModle.evening == false)? Colors.red : Colors.blue,
              ),
              new RaisedButton(
                onPressed: (){
                  updatetheBooking("night");
                },
                child: new Text(bookModle.night == true ? "Booked": "Book Night"),
                color: (bookModle.night == false)? Colors.red : Colors.blue,

              ),
            ],
          ),
        ],
      ),
    );
  }

  void _OnEntryAdded(Event event) {
    setState(() {
      bookedDatesList.add(BookModle.fromSnapshot(event.snapshot));
      key = event.snapshot.key;
      bookModle.morning = event.snapshot.value['morning'];
      bookModle.evening = event.snapshot.value['evening'];
      bookModle.night = event.snapshot.value['night'];
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
      bookModle.dateTime = "${widget.date}";
      bookModle.morning = true;

      databaseReference.child(key).remove();
      databaseReference.child(key).update(bookModle.toJson());
    }else if(time == "evening"){
      //update the evening;
      bookModle.dateTime = "${widget.date}";
      bookModle.evening = true;

      databaseReference.child(key).remove();
      databaseReference.child(key).update(bookModle.toJson());
    }else{
      //update the night;
      print(bookModle.morning);
      bookModle.dateTime = "${widget.date}";
      bookModle.night= true;

      databaseReference.child(key).remove();
      databaseReference.child(key).update(bookModle.toJson());
    }
  }
}

