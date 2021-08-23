import 'package:flutter/material.dart';
import 'package:sudoku_game/home/play/mainscreen/mainscreen.dart';
import 'package:provider/provider.dart';

class plist extends StatelessWidget {
  final String rank;
  final int pack;
  plist({Key key, @required this.rank, this.pack}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text('Select Puzzle'),
            Text(
              '${rank}-pack${pack + 1}',
              style: TextStyle(fontSize: 15.0),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(children: <Widget>[
            ListTile(
                title: Text(
                  'Puzzle ${index + 1}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider<SudokuNotifier>(
                        create: (context) => SudokuNotifier(rank, pack, index),
                        child: mainscreen(),
                      ),
                    ),
                  );
                }),
            Divider(color: Colors.grey),
          ]);
        },
      ),
    );
  }
}
