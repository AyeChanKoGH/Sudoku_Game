import 'package:flutter/material.dart';
import 'package:sudoku_game/home/play/flist/plist.dart';
import 'package:sudoku_game/require.dart';
import 'package:provider/provider.dart';

class flist extends StatelessWidget {
  /**Pack list  */
  final String rank;
  flist({Key? key, required this.rank}) : super(key: key);

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
        itemCount: rank == 'Beginner' ? 5 : 10,
        itemBuilder: (context, index) {
          return Column(children: <Widget>[
            //buildwithfutrue(index),
            ListTile(
                title: Text(
                  'Pack ${index + 1}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                trailing: Provider.of<ForpackProvider>(context).isNew(index) ? null : Text('New'),
                onTap: () {
                  Provider.of<GetisNew>(context, listen: false).inital(rank, pack: index);
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
/*
  Widget buildwithfutrue(int index) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.hasData) {
          return ListTile(
              title: Text(
                'Pack ${index + 1}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              trailing: projectSnap.data == true ? null : Text('New'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => plist(rank: this.rank, pack: index),
                  ),
                );
              });
        } else {
          return Container(height: 20);
        }
      },
      future: getsharepref(rank, index),
    );
  }
}*/
