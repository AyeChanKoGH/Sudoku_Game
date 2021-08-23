import 'package:flutter/material.dart';
import 'package:sudoku_game/require.dart';
import 'package:sudoku_game/home/learn/blog_builder.dart';
import 'package:sudoku_game/home/learn/blog.dart' as blog;

class learn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Learn'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: raisedButtonStyle,
              child: Text('About'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContextCreate(value: 'about_sudoku')),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: raisedButtonStyle,
              child: Text('Methon To Solve'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SolveMethod()),
                );
              },
            ),
          ],
        )));
  }
}

class SolveMethod extends StatelessWidget {
  SolveMethod({Key? key}) : super(key: key);
  final names = [
    'sole_candidate',
    'unique_candidate',
    'block_with_column_row_interaction',
    'block_block_interaction',
    'naked_pair',
    'hidden_pair',
    'naked_triples',
    'hidden_triples'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sudoku Solving Method"),
        ),
        body: ListView.separated(
            itemCount: names.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (context, index) {
              return Card(
                elevation: 5.0,
                child: Cardcreate(name: names[index]),
              );
            }));
  }
}

class Cardcreate extends StatelessWidget {
  final String name;
  Cardcreate({Key? key, required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List data = blog.methods[name];
    Map inside = data[2];
    String insidetext = '';
    if (inside.keys.first == 'subtitle') {
      insidetext = inside['subtitle'] + '\n';
      inside = data[3];
    }
    insidetext = insidetext + inside['body'];
    return Container(
      padding: EdgeInsets.all(10),
      height: 150,
      child: InkWell(
        child: Column(
          children: <Widget>[
            Text(data[0], style: TextStyle(fontSize: 20)),
            Text(insidetext, maxLines: 3, style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContextCreate(value: name)),
          );
        },
      ),
    );
  }
}
