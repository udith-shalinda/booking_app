import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../modle/bookModle.dart';

class ChallengeFeed extends StatefulWidget {
  @override
  _ChallengeFeedState createState() => _ChallengeFeedState();
}

class _ChallengeFeedState extends State<ChallengeFeed> {

  List<BookModle> bookedDatesList = List();
  //BookModle bookModle;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;


  @override
  void initState() {
    super.initState();
    databaseReference = database.reference().child("bookedTimes");
    databaseReference.onChildAdded.listen(_OnEntryAdded);

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("News feed"),
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
                height: 600,
                child: new FirebaseAnimatedList(
                    query: databaseReference,
                    itemBuilder: (_, DataSnapshot snapshot,Animation<double> animation , int index){
                      return new Card(
                        child: new ListTile(
//                            leading: CircleAvatar(
//                              backgroundColor: Colors.redAccent,
//                            ),
                          title:  Text(snapshot.value['dateTime'].toString()),
                          subtitle:  Text("Morning :  ${snapshot.value['morning'].toString()}  ${snapshot.value['morningPlayer'].toString()} "
                              "\n Evening :  ${snapshot.value['evening'].toString() } ${snapshot.value['eveningPlayer'].toString()}"
                              "\n Night :  ${snapshot.value['night'].toString()} ${snapshot.value['nightPlayer'].toString()}"),
                          onTap: (){
                            debugPrint(snapshot.value['key'].toString());
                          },
                        ),
                      );
                    }
                ),
              ),

            ],
          )
        ]
      )
    );
  }


  void _OnEntryAdded(Event event) {
    setState(() {
      bookedDatesList.add(BookModle.fromSnapshot(event.snapshot));
    });
  }
}
