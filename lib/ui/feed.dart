import 'package:flutter/material.dart';

class ChallengeFeed extends StatefulWidget {
  @override
  _ChallengeFeedState createState() => _ChallengeFeedState();
}

class _ChallengeFeedState extends State<ChallengeFeed> {
  @override
  Widget build(BuildContext context){
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
              new Text("hello there")
            ],
          )
        ]
      )
    );
  }
}
