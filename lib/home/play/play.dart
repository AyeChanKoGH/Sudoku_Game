import 'package:flutter/material.dart';
import 'package:sudoku_game/home/play/flist/flist.dart';
import 'package:sudoku_game/require.dart';
class play extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Choose Rank'),
        ),
        body: Center(
            child: Column(
               mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[ 
            myelvButton('Easy'),
            SizedBox(height: 20),
            myelvButton('Medium'),
            SizedBox(height: 20),
            myelvButton('Hard'),
            SizedBox(height: 20),
            myelvButton('Evil'),
          ],
        )));
  }
}

class myelvButton extends StatelessWidget{
  @override
  String rank;
  myelvButton(this.rank);
  Widget build(BuildContext context){
    return ElevatedButton(
      style: raisedButtonStyle,
              child: Text(this.rank),
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:(context)=>flist(rank:this.rank),
                    ),
                  );
              },
    );
  }
}