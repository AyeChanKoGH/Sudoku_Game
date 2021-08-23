import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: Size(200, 50),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

Future readJson(String rank, int pack, int puzzle) async {
  String? file;
  if (rank == 'Beginner') {
    file = 'assets/beginner.json';
  } else if (rank == 'Easy') {
    file = 'assets/easy.json';
  } else if (rank == 'Medium') {
    file = 'assets/medium.json';
  } else if (rank == 'Hard') {
    file = 'assets/hard.json';
  } else {
    file = 'assets/evil.json';
  }
  final String response = await rootBundle.loadString(file);
  List data = await (json.decode(response) as List);
  if (rank == 'Beginner') {
    return data[pack * 5 + puzzle];
  }
  return data[pack * 10 + puzzle];
}

class GetisNew with ChangeNotifier {
  SharedPreferences? _pref;
  String _rank = 'Beginner';
  int? _pack = null;
  List _isnew = List.generate(10, (_) => false);

  void inital(String rank, {int? pack}) {
    _rank = rank;
    if (pack != null) {
      _pack = pack;
    }
    getlocalvalue();
    notifyListeners();
  }

  bool isNew(int i) {
    return _isnew[i];
  }

  getlocalvalue() async {
    int size = 10;
    if (_pack != null) {
      for (int i = 0; i < size; i++) {
        _isnew[i] = await getsharepref(_rank, _pack, puzzle: i);
      }
    } else {
      if (_rank == 'Beginner') {
        size = 5;
      }
      for (int i = 0; i < size; i++) {
        _isnew[i] = await getsharepref(_rank, _pack);
      }
    }
    notifyListeners();
  }

  __initLocal() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  void setsharepref(int puzzle) async {
    _isnew[puzzle] = true;
    await __initLocal();
    //_pref?.setBool(_rank + 'is${_pack}', true);
    _pref?.setBool(_rank + 'is${_pack}${puzzle}', true);
    notifyListeners();
  }

  void setshareprefpack(int pack) async {
    _isnew[pack] = true;
    await __initLocal();
    _pref?.setBool(_rank + 'is{_pack}', true);
    notifyListeners();
  }

  Future getsharepref(String rank, int? pack, {puzzle}) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    bool isnew = false;
    if (puzzle != null) {
      isnew = await _pref.getBool(rank + 'is${pack}${puzzle}') ?? false;
    } else {
      isnew = await _pref.getBool(rank + 'is${pack}') ?? false;
    }
    return isnew;
  }
}

class ForpackProvider extends GetisNew {
  ForpackProvider() : super();
}

class StateSave {
  /**That is to save user playing style */
  SharedPreferences? storage;
  final String rank;
  final int pack;
  final int puzzle;
  StateSave(this.rank, this.pack, this.puzzle);
  __initLocal() async {
    if (storage == null) storage = await SharedPreferences.getInstance();
  }

  dynamic findlocal() async {
    await __initLocal();
    var puz = await storage?.getString(rank + '${pack}${puzzle}');
    if (puz != null) {
      List puzz = await json.decode(puz);
      return Setsudoku.fromjson(puzz);
    }
    return null;
  }

  void setlocal(List board, List<List> color, List bgcolor) async {
    await __initLocal();
    var sudo = Setsudoku(board: board, color: color, bgcolor: bgcolor);
    storage?.setString(rank + '${pack}${puzzle}', json.encode(sudo));
  }
}

List<List> fromjscolor(List jsvalue) {
  List<List> val = [];
  for (int i = 0; i < 9; i++) {
    val.add([]);
    for (int j = 0; j < 9; j++) {
      val[i].add([]);
      if (jsvalue[i][j] is Map) {
        val[i][j] = jsvalue[i][j];
      } else {
        val[i][j] = Color(jsvalue[i][j]);
      }
    }
  }
  return val;
}

List fromjsbgcolor(List jsvalue) {
  List val = [];
  for (int i = 0; i < 9; i++) {
    val.add([]);
    for (int j = 0; j < 9; j++) {
      val[i].add([]);
      val[i][j] = Color(jsvalue[i][j]);
    }
  }
  return val;
}

class Setsudoku {
  final List board;
  final List<List> color;
  final List bgcolor;
  Setsudoku({required this.board, required this.color, required this.bgcolor});
  factory Setsudoku.fromjson(List njson) {
    return Setsudoku(board: njson[0], color: fromjscolor(njson[1]), bgcolor: fromjsbgcolor(njson[2]));
  }
  List<List> tojscolor() {
    List<List> col = [];
    for (int i = 0; i < 9; i++) {
      col.add([]);
      for (int j = 0; j < 9; j++) {
        col[i].add([]);
        if (color[i][j] is Map) {
          col[i][j] = color[i][j];
        } else {
          col[i][j] = color[i][j].value;
        }
      }
    }
    return col;
  }

  List tojsbgcolor() {
    List bgcol = [];
    for (int i = 0; i < 9; i++) {
      bgcol.add([]);
      for (int j = 0; j < 9; j++) {
        bgcol[i].add([]);
        bgcol[i][j] = bgcolor[i][j] == Colors.red ? bgcolor[i][j].value : Colors.white10.value;
      }
    }
    return bgcol;
  }

  List toJson() {
    return [
      board,
      tojscolor(),
      tojsbgcolor()
    ];
  }
}
