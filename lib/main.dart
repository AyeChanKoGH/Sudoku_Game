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

void main() {
    
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      
    var mytheme = context.watch<ThemeNotifier>();
    return MaterialApp(
      home: homePage(),
      theme: mytheme.getTheme,
      
      debugShowCheckedModeBanner: false,
    );
  }
}
