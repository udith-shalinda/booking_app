import 'package:firebase_database/firebase_database.dart';

class BookModle {
    String key;
    String dateTime;
    bool morning;
    bool evening;
    bool night;

    BookModle(this.dateTime,this.morning,this.evening,this.night);

    BookModle.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        dateTime = snapshot.value['dateTime'],
        morning = snapshot.value['morning'],
        evening = snapshot.value['evening'],
        night = snapshot.value['night'];

    toJson(){
      return {
        "dateTime" : dateTime,
        "morning" :morning,
        "evening" : evening,
        "night" : night
      };
    }

}