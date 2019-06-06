import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:date_format/date_format.dart';

import '../modle/bookModle.dart';
import './Date.dart';

class NewsFeed extends StatefulWidget {
  final String userEmail;
  NewsFeed({Key key,this.userEmail}):super(key :key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {

  DateTime selectedDate = DateTime.now();
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
//      appBar: AppBar(
//        backgroundColor: Colors.greenAccent,
//        title: new Text("News feed"),
//        centerTitle: true,
//      ),
      body: new Stack(
        children: <Widget>[
          new Center(
          child: new Image.asset(
            'images/cover_one.jpg',
            fit: BoxFit.cover,
            width:  MediaQuery.of(context).size.width,
            height:  MediaQuery.of(context).size.height - 100,
            ),
          ),
          new ListView(
            children: <Widget>[
              new Container(
                height:  MediaQuery.of(context).size.height-120,
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
                            bookADate(snapshot.value['dateTime']);
                          },
                        ),
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
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }


  void _OnEntryAdded(Event event) {
    setState(() {
      bookedDatesList.add(BookModle.fromSnapshot(event.snapshot));
    });
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

  void bookADate(String date){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new Date(date: date ,userEmail:widget.userEmail);
        });
    Navigator.of(context).push(router);
  }

}
