import 'package:flutter/material.dart';
import 'package:sudoku_game/home/play/flist/flist.dart';
import 'package:sudoku_game/require.dart';
import 'package:provider/provider.dart';

class play extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Choose Rank'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyelvButton('Beginner'),
            SizedBox(height: 20),
            MyelvButton('Easy'),
            SizedBox(height: 20),
            MyelvButton('Medium'),
            SizedBox(height: 20),
            MyelvButton('Hard'),
            SizedBox(height: 20),
            MyelvButton('Evil'),
          ],
        )));
  }
}

class MyelvButton extends StatelessWidget {
  final String rank;
  @override
  MyelvButton(this.rank);
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: raisedButtonStyle,
      child: Text(this.rank),
      onPressed: () {
        Provider.of<ForpackProvider>(context, listen: false).inital(rank);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => flist(rank: this.rank),
          ),
        );
      },
    );
  }
}
