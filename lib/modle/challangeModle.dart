import 'package:firebase_database/firebase_database.dart';

class ChallangeModle {
  String key;
  String dateTime;
  String time;
  String creater;
  int count;


  ChallangeModle(this.dateTime,this.time,this.creater,this.count);

  ChallangeModle.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        dateTime = snapshot.value['dateTime'],
        creater = snapshot.value['creater'],
        count = snapshot.value['count'],
        time = snapshot.value['time'];

  toJson(){
    return {
      "dateTime" : dateTime,
      "time" : time,
      "creater" :creater,
      "count" : count
    };
  }

}