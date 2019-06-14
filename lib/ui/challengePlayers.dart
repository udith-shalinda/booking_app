import 'package:flutter/material.dart';

 class ChallengePlayers extends StatefulWidget {
   List<String> players=List();
   ChallengePlayers({Key key,this.players}):super(key :key);

  @override
  _ChallengePlayersState createState() => _ChallengePlayersState();
}

class _ChallengePlayersState extends State<ChallengePlayers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(52, 66, 86, 1.0),
        title: new Text("Players"),
        centerTitle: true,
      ),
      body : new Stack(
        children: <Widget>[
        new ListView.builder(
          itemCount: widget.players.length,
          itemBuilder: (BuildContext context,int index){
            return new Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  title: Text(
                      widget.players[index],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                  ),
                ),
              ),
            );
          },
        )
      ],
      ),
    );
  }
}
