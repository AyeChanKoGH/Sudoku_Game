import 'package:flutter/material.dart';
import 'package:sudoku_game/require.dart';

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
              onPressed: () {},
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: raisedButtonStyle,
              child: Text('Methon To Solve'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context)=>method()),
                );
              },
            ),
          ],
        )));
  }
}
class method extends StatelessWidget{
  @override
  List methods=['Sole Candidate or Naked Single','Unique Candidate','Block and column/ Row Interaction','Block/ Block Interaction','Naked Subset','Hidden subset','X-Wing','Swordfish','Forcing Chain'];
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:Text("Some Sudoku Solving Method"),
      ),
      body:ListView.separated(
        itemCount: methods.length,
        itemBuilder: (context, index) {
          return Container(
            height: 50,
            margin: EdgeInsets.all(1),
            child: ListTile(
                title: Text(
                  '${methods[index]}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  
                }),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(color: Colors.grey);
        },
      ),
    );
  }
}