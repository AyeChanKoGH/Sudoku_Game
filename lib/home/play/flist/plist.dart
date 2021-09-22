import 'package:flutter/material.dart';
import 'package:sudoku_game/home/play/mainscreen/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/require.dart';

class plist extends StatelessWidget {
  /**plist puzzle list to play */
  final String rank;
  final int pack;
  plist({Key? key, required this.rank, required this.pack}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text('Select Puzzle'),
            Text(
              '${rank}-pack${pack + 1}',
              style: TextStyle(fontSize: 18.0),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(children: <Widget>[
            //buildwithfutrue(index),
            Card(
                child: ListTile(
                    title: Text(
                      'Puzzle ${index + 1}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing: Provider.of<GetisNew>(context).isNew(index) ? null : Text('New'),
                    onTap: () {
                      Provider.of<GetisNew>(context, listen: false).setsharepref(index);
                      Provider.of<ForpackProvider>(context, listen: false).setshareprefpack(pack);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider<SudokuNotifier>(
                            create: (context) => SudokuNotifier(rank, pack, index),
                            child: mainscreen(),
                          ),
                        ),
                      );
                    })),
            Divider(color: Colors.grey),
          ]);
        },
      ),
    );
  }
}
