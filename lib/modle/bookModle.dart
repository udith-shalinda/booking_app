import 'package:firebase_database/firebase_database.dart';

class BookModle {
    String key;
    String dateTime;
    bool morning;
    bool evening;
    bool night;
    String mornigPlayer;
    String eveningPlayer;
    String nightPlayer;

    BookModle(this.dateTime,this.morning,this.evening,this.night,this.mornigPlayer,this.eveningPlayer,this.nightPlayer);

    BookModle.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        dateTime = snapshot.value['dateTime'],
        morning = snapshot.value['morning'],
        evening = snapshot.value['evening'],
        night = snapshot.value['night'],
        mornigPlayer = snapshot.value['morningPlayer'],
        eveningPlayer = snapshot.value['eveningPlayer'],
        nightPlayer = snapshot.value['nightPlayer'];

    toJson(){
      return {
        "dateTime" : dateTime,
        "morning" :morning,
        "evening" : evening,
        "night" : night,
        "morningPlayer": mornigPlayer,
        "eveningPlayer" : eveningPlayer,
        "nightPlayer" :nightPlayer
      };
    }

}