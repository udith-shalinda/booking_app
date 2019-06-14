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
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("Schedule of Date"),
        centerTitle: true,
      ),
      body : new Stack(
        children: <Widget>[
        new Center(
          child: new Image.asset(
          'images/cover_one.jpg',
          fit: BoxFit.cover,
          width: 500,
          height: 1000,
          ),
        ),
        new ListView.builder(
          itemCount: widget.players.length,
          itemBuilder: (BuildContext context,int index){
            return new Card(
              child: ListTile(
                title: Text(widget.players[index]),
              ),
            );
          },
        )
      ],
      ),
    );
  }
}
