import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../modle/bookModle.dart';


class Date extends StatefulWidget {
  final DateTime date;
  Date({Key key,this.date}):super(key :key);

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {


  List<BookModle> bookedDates = List();
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
          new Center(
            child: new ListView(
              children: <Widget>[
                new ListTile(
                  title: new Text(
                      "${widget.date}",
                    style: new TextStyle(
                      backgroundColor: Colors.white,
                        fontSize: 34
                    ),
                  ),
                  contentPadding: EdgeInsets.all(0),

                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                      "${widget.date}",
                    style: new TextStyle(
                      backgroundColor: Colors.white,
                      fontSize: 34
                    ),
                  ),
                  contentPadding: EdgeInsets.all(0),
                ),
                new RaisedButton(
                    onPressed: handleSubmition,
                  child: new Text("print date"),
                )
              ],
            )
          )
        ],
      ),
    );
  }

  void _OnEntryAdded(Event event) {
    setState(() {
      bookedDates.add(BookModle.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmition() {
      bookModle.dateTime = "${widget.date}";
      bookModle.startTime = 8;

      databaseReference.push().set(bookModle.toJson());
      print("added to the firebase");
  }
}

