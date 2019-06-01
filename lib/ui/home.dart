import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import './Date.dart';
import './feed.dart';

class PickDate extends StatefulWidget {
  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> {
   DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("Home"),
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
            child:new ListView(
              children: <Widget>[
                new Text(
                  "$selectedDate",
                  style: new TextStyle(
                      fontSize: 56,
                      color: Colors.redAccent
                  ),
                ),
                new RaisedButton(
                  onPressed:()=> _selectDate(context),
                  child: new Text("Pick a date"),
                ),
                new RaisedButton(
                  onPressed:_gotoFeed,
                  child: new Text("Feed"),
                ),
                new RaisedButton(
                  onPressed:()=> _selectDate(context),
                  child: new Text("Make a challenge"),
                ),
              ],
          )
          ),
        ],
      ),
    );
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
        Duration defference = selectedDate.difference(DateTime.now());
        if(selectedDate.isAfter(DateTime.now())){
          var router = new MaterialPageRoute(
              builder: (BuildContext context){
                return new Date(date: formatDate(selectedDate, [yyyy, '-', mm, '-', dd]));
              });
          Navigator.of(context).push(router);
        }
      });

  }
  void _gotoFeed(){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new ChallengeFeed();
        });
    Navigator.of(context).push(router);
  }
}
