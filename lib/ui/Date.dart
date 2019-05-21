import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../modle/bookModle.dart';


class Date extends StatefulWidget {
  final DateTime date;
  Date({Key key,this.date}):super(key :key);

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {


  List<BookModle> bookedDatesList = List();
  BookModle bookModle;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference ;

  @override
  void initState() {
    super.initState();

    bookModle = new BookModle("", 0);
    databaseReference = database.reference().child("bookedTimes");
    databaseReference.onChildAdded.listen(_OnEntryAdded);
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
                height: 500,
                child: new FirebaseAnimatedList(
                    query: databaseReference,
                    itemBuilder:(_, DataSnapshot snapshot,Animation<double> animation , int index){
                      return new Card(
                        child: new ListTile(
//                            leading: CircleAvatar(
//                              backgroundColor: Colors.redAccent,
//                            ),
                          title:  Text(snapshot.value['dateTime'].toString()),
                          subtitle:  Text(snapshot.value['startTime'].toString()),
                        ),
                      );
                    }
                ),
              ),
              new RaisedButton(
                onPressed: handleSubmition,
                child: new Text("print date"),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _OnEntryAdded(Event event) {
    setState(() {
      bookedDatesList.add(BookModle.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmition() {
      bookModle.dateTime = "${widget.date}";
      bookModle.startTime = 8;

      databaseReference.push().set(bookModle.toJson());
      print("added to the firebase");
  }
}

