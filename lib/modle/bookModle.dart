import 'package:firebase_database/firebase_database.dart';

class BookModle {
    String key;
    String dateTime;
    int startTime;

    BookModle(this.dateTime,this.startTime);

    BookModle.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        dateTime = snapshot.value['dateTime'],
        startTime = snapshot.value['startTime'];

    toJson(){
      return {
        "dateTime" : dateTime,
        "startTime" : startTime
      };
    }

}