import 'package:flutter/material.dart';
import 'package:sudoku_game/home/learn/learn.dart';
import 'package:sudoku_game/home/play/play.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/mytheme.dart';
import 'package:sudoku_game/require.dart';
import 'package:package_info/package_info.dart';

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('SUDOKU PUZZLE'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: raisedButtonStyle,
              child: Text('Learn'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => learn(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: raisedButtonStyle,
              child: Text('Play'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => play(),
                  ),
                );
              },
            ),
          ],
        )));
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(2),
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Sudoku Puzzle',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withAlpha(0),
                  Colors.black12,
                  Colors.black45
                ],
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeNotifier.isDark,
            onChanged: (bool value) {
              themeNotifier.setTheme(value);
            },
            secondary: const Icon(Icons.lightbulb_outline),
          ),
          ListTile(leading: Icon(Icons.verified_user), title: Text('User Profile'), onTap: () {}),
          ListTile(leading: Icon(Icons.settings), title: Text('Setting'), onTap: () {}),
          ListTile(leading: Icon(Icons.share), title: Text('Share with friend'), onTap: () {}),
          ListTile(leading: Icon(Icons.call), title: Text('Contact Us'), onTap: () {}),
          FutureBuilder(
            builder: (context, projectSnap) {
              if (projectSnap.connectionState == ConnectionState.done) {
                if (projectSnap.hasError) {
                  return Container();
                }
                return Container(
                  child: Text('Version : ${projectSnap.data}'),
                );
              } else {
                return Container(height: 20);
              }
            },
            future: buildversion(),
          ),
        ],
      ),
    );
  }
}

Future buildversion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String info = await packageInfo.version;
  return info;
}
