/******** Sudoku Game*******
  - My first App using Flutter Framework
  - Feature
    [ - Playscreen
      - Solving way
      - Theme Changer
    ]
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mytheme.dart';
import 'home/home.dart';
import 'dart:async';
import 'package:sudoku_game/home/learn/learn.dart';
import 'require.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider<ForpackProvider>(
          create: (_) => ForpackProvider(),
        ),
        ChangeNotifierProvider<GetisNew>(create: (_) => GetisNew()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mytheme = context.watch<ThemeNotifier>();
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/solvemethod': (context) => SolveMethod(),
      },
      theme: mytheme.getTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => homePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              child: Image.asset('assets/icon/ic_launcher.png'),
            ),
            Text(
              "SUDOKU",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
