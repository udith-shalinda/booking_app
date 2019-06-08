import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import './Date.dart';
import './feed.dart' as feed;
import './challange.dart' as challenge;

//picking a date to book
class PickDate extends StatefulWidget {

  final String userEmail;
  PickDate({Key key,this.userEmail}):super(key :key);

  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> with SingleTickerProviderStateMixin {
   DateTime selectedDate = DateTime.now();
   TabController _controller;

   @override
   void initState() {
     super.initState();
      _controller = new TabController(length: 2, vsync: this);
   }


   @override
   void dispose() {
      _controller.dispose();
   }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(52, 66, 86, 1.0),
        title: new Text("Home"),
        centerTitle: true,
        bottom: TabBar(
            indicatorColor: Colors.redAccent,
//          labelColor: Colors.black,
          controller: _controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home),),
            new Tab(icon: new Icon(Icons.flag),)
          ],
        ),
      ),
      body: new TabBarView(
          controller: _controller,
          children: <Widget>[
              new feed.NewsFeed(userEmail: widget.userEmail,),
              new challenge.showChallanges(userEmail: widget.userEmail,)
          ],)
    );
  }


}
