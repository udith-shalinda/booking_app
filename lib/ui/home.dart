import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import './Date.dart';
import './feed.dart';
import './challange.dart';

//picking a date to book
class PickDate extends StatefulWidget {

  final String userEmail;
  PickDate({Key key,this.userEmail}):super(key :key);

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
                  onPressed:()=> _makeAChallange(context),
                  child: new Text("Make a challenge"),
                ),
                new RaisedButton(
                  onPressed: _showChallanges,
                  child: new Text("show challenges"),
                  color: Colors.lightBlueAccent,
                  splashColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
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
                return new Date(date: formatDate(selectedDate, [yyyy, '-', mm, '-', dd]),userEmail:widget.userEmail);
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

   _showChallanges(){
   var router = new MaterialPageRoute(
       builder: (BuildContext context){
         return new showChallanges(userEmail:widget.userEmail);
       });
   Navigator.of(context).push(router);
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
