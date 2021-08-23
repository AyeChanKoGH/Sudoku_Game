import 'package:flutter/material.dart';
import 'package:sudoku_game/home/play/flist/plist.dart';

class flist extends StatelessWidget {
  /**Pack list  */
  final String rank;
  flist({Key key, @required this.rank}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text('Select Pack'),
            Text(
              '${rank}',
              style: TextStyle(fontSize: 20.0),
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
                  'Pack ${index + 1}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => plist(rank: this.rank, pack: index),
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
