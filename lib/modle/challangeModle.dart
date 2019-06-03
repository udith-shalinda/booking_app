import 'package:firebase_database/firebase_database.dart';

class ChallangeModle {
  String key;
  String dateTime;
  String time;
  int count;
  List<String> players;


  ChallangeModle(this.dateTime,this.time,this.count,this.players);

  ChallangeModle.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        dateTime = snapshot.value['dateTime'],
        count = snapshot.value['count'],
        time = snapshot.value['time'],
        players = snapshot.value['players'];

  toJson(){
    return {
      "dateTime" : dateTime,
      "time" : time,
      "count" : count,
      "players" : players
    };
  }

}