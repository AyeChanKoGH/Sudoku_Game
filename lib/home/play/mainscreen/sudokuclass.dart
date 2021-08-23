import 'package:flutter/material.dart';

/*This is Sudoku Cell class to generate, to modefild, and getting data to desplay  */
class Sudoku {
  Color _errcol = Colors.red[100];
  Color _act_bgcolor = Colors.green[100];
  Color _cell_bgcolor = Colors.green[300];
  Color _themecolor = Colors.white10;
  Color _textcolor = Colors.blue;
  Color _defcolor = Colors.black;
  List _n_color = [
    Colors.blue,
    Colors.yellow,
    Colors.pink
  ]; //for active _color
  List _board= List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<Color>> _bgcolor = List.generate(9, (_) => List.generate(9, (_) => Colors.white10));
  List<List> _color = List.generate(9, (_) => List.generate(9, (_) => Colors.black));
  var _active_row = null;
  var _active_col = null;
  var _curnum = null; //adding current number
  int _curColor = 0;

  bool _draf = true;
  bool _clickable = true;
  StackV _undo; //= new StackV<Map>();
  StackV _redo; //= new StackV<Map>();
	
  //////////////////////
  // SET Cells,Active Row and Column,Colors,Background Colors
  ////////////////////////////////////////////////////
  void setBoard_init(List iniBoard) {
    _board = iniBoard;
    _bgcolor = List.generate(9, (_) => List.generate(9, (_) => Colors.white10));
    _color = List.generate(9, (_) => List.generate(9, (_) => Colors.black));
    _active_row = null;
    _active_col = null;
    _curnum = null; //adding current number
    _curColor = 0;
    _draf = true;
    _clickable = true;
    _undo = new StackV<Map>();
    _redo = new StackV<Map>();
  }
  
  void setBoardCell(int num, [String state]) {
    if (_active_row != null && _active_col != null) {
      int row = this._active_row;
      int col = this._active_col;
      if (isdefaultCell(row, col)) {
        if (_draf == false && (_board[row][col] == 0 || _board[row][col] == num)) {
          isValid(row, col, num) ? _bgcolor[row][col] = _cell_bgcolor : _bgcolor[row][col] = _errcol;

          if (_board[row][col] == num) {

            clear();
          } else {
            _board[row][col] = num;
            setnumbg(num);
            _color[row][col] = _n_color[_curColor];
            if (state != 'Undo') {
              _undo.push({
                [
                  row,
                  col
                ]: num
              });
            } else {
              _redo.push({
                [
                  row,
                  col
                ]: 'clear'
              });
            }
          }
        } else {
          set_board_cell_draf(num, state);
        }
      }
    } else {
      setnumbg(num);
    }
    if (isFinish()) {
      _bgcolor = List.generate(9, (_) => List.generate(9, (_) => _act_bgcolor));
    }
  }

  void setnumbg(int num) {
    remove_curnum();
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_board[i][j] == num && _bgcolor[i][j] == _themecolor) _bgcolor[i][j] = _act_bgcolor;
      }
    }
    _curnum = num;
  }

  void remove_curnum() {
    if (_curnum != null) {
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (_board[i][j] == _curnum && _bgcolor[i][j] != _errcol) _bgcolor[i][j] = _themecolor;
        }
      }
      _curnum = null;
    }
  }
  
  void set_board_cell_draf(int num, [String state]) {
    set_draf();
    int row = this._active_row;
    int col = this._active_col;
    if (_board[row][col].contains(num)) {
      _board[row][col].remove(num);
      //_color[row][col].remove()
    } else {
      _board[row][col].add(num);
      //_color[row][col].add(_n_color[_curColor]);
    }
    if (_board[row][col].length > 1) {
      _clickable = false;
    }
  }

//    Set active row and column to add, remove, or modifiy to specific celll.
  void set_active_row_col(int row, int col) {
    bool setdigit = false;
    if (_board[row][col] is int) {
      _draf = false;
      _clickable = true;
      if (_board[row][col] != 0) {
        setdigit = true;
      }
    } else if (_board[row][col].length > 1) {
      _draf = true;
      _clickable = false;
    } else {
      _draf = true;
      _clickable = true;
    }
    if (_active_row != null && _active_col != null) {
      changebgColor(_active_row, _active_col, _themecolor);
    }
    if (setdigit) {
      setnumbg(_board[row][col]);
    }else{remove_curnum();}
    this._active_row = row;
    this._active_col = col;
    changebgColor(row, col, _act_bgcolor);
    //setnumbg();
  }

  void set_curColor() {
    if (_n_color.length - 1 > _curColor) {
      _curColor++;
      print(_curColor);
    } else {
      _curColor = 0;
    }
  }

  void set_unactive() {
    changebgColor(_active_row, _active_col, _themecolor);
    this._active_row = null;
    this._active_col = null;
    remove_curnum();
  }
  /////

  ////////////////////////////////
  //__When set _draf is clicked pencil mode is on
  //__When set _draf is clicked pencil mode is off
  void set_draf() {
    if (_active_row != null && _active_col != null) {
      if (isdefaultCell(_active_row, _active_col)) {
        _draf = true;
        _bgcolor[_active_row][_active_col] = _cell_bgcolor;
        if (_board[_active_row][_active_col] == 0) {
          _board[_active_row][_active_col] = [];
        } else if (_board[_active_row][_active_col] is int) {
          _board[_active_row][_active_col] = [
            _board[_active_row][_active_col]
          ];
        } else if (_board[_active_row][_active_col] is List && _board[_active_row][_active_col].length == 1) {
          _board[_active_row][_active_col] = _board[_active_row][_active_col][0];

          _draf = false;
        }
      }
    }
  }

/////////////////Getting value from Class////////////////////
  dynamic getBoardCell(int row, int col) {
    return _board[row][col];
  }

  Color get_curColor() {
    return _n_color[_curColor];
  }

  Color getBoardColor(int row, int col) {
    return _bgcolor[row][col];
  }

  Color get_tcol(int row, int col) {
    //if (_color[row][col] is Color){return _color[row][col]}
    return _color[row][col];
  }
  // 
  int get_num_of_key(int num) {
    int n_key = 0;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_board[i][j] == num) {
          n_key++;
        }
      }
    }
    return n_key;
  }
/////////////
  void changebgColor(int row, int col, Color _color) {
    //Fill Color
    for (int i = 0; i < 9; i++) {
      if (_bgcolor[i][col] != _errcol) {
        _bgcolor[i][col] = _color;
      }
    }
    //Fill Row _color
    for (int i = 0; i < 9; i++) {
      if (_bgcolor[row][i] != _errcol) {
        _bgcolor[row][i] = _color;
      }
    }
    //Fill region _color
    int x0 = (row ~/ 3) * 3;
    int y0 = (col ~/ 3) * 3;
    for (int i = x0; i < x0 + 3; i++) {
      for (int j = y0; j < y0 + 3; j++) {
        if (_bgcolor[i][j] != _errcol) {
          _bgcolor[i][j] = _color;
        }
      }
    }
    if (_color == _act_bgcolor) {
      if (_bgcolor[row][col] != _errcol) {
        _bgcolor[row][col] = _cell_bgcolor;
      }
    }
  }
    void clear([String state]) {
    if (_active_row != null && _active_col != null) {
      int row = this._active_row;
      int col = this._active_col;
      remove_curnum();
      _bgcolor[row][col]=_cell_bgcolor;
      changebgColor(row,col,_act_bgcolor);
      if (state == 'Undo') {
        _redo.push({
          [
            row,
            col
          ]: _board[row][col]
        });
      } else {
        _undo.push({
          [
            row,
            col
          ]: [
            _board[row][col],
            'clear'
          ]
        });
      }
      _board[row][col] = 0;
      _draf = false;
    }
  }


  //  UNDO REDO Function
  void undo() {
    var before = _undo.last();
    if (before.values.first is int) {
      set_active_row_col(before.keys.first[0], before.keys.first[1]);
      clear('Undo');
      _undo.pop();
      print(_undo.srint());
    } else {
      set_active_row_col(before.keys.first[0], before.keys.first[1]);
      setBoardCell(before.values.first[0], 'Undo');
      _undo.pop();
    }
  }

  void redo() {
    var after = _redo.last();
    if (after.values.first is int) {
      set_active_row_col(after.keys.first[0], after.keys.first[1]);
      setBoardCell(after.values.first);
      _redo.pop();
      print(_redo.srint());
    } else {
      set_active_row_col(after.keys.first[0], after.keys.first[1]);
      clear();
      _redo.pop();
    }
  }


//////////  Checking functions/////////////
  
  bool isFinish() {
    for (var nums in _board) {
      if (nums.contains(0)) {
        return false;
      }
    }
    return true;
  }

  bool isdefaultCell(int row, int col) {
    if (_board[row][col] != 0 && _color[row][col] == _defcolor) return false;
    return true;
  }

  bool isClickable() {
    return _clickable;
  }
  
  bool is_insideCell(int num){
    if(_active_row!=null && _active_col!=null){
      var actnum=_board[_active_row][_active_col];
      return actnum is int?actnum==num?true:false :actnum.contains(num)?true:false;
    }return false;
  }
  bool isValid(t_row, t_col, num) {
    //Is Column Valid
    for (int i = 0; i < 9; i++) {
      if (_board[i][t_col] == num && num != 0) {
        return false;
      }
    }
    //Is Row Valid?
    for (int i = 0; i < 9; i++) {
      if (_board[t_row][i] == num && num != 0) {
        return false;
      }
    }
    //Is Region Valid?
    int x0 = (t_row ~/ 3) * 3;
    int y0 = (t_col ~/ 3) * 3;
    for (int i = x0; i < x0 + 3; i++) {
      for (int j = y0; j < y0 + 3; j++) {
        if (_board[i][j] == num && num != 0) {
          return false;
        }
      }
    }
    return true;
  }
}

/*Creating Stack datatype to store user working record,To perfome Undo and Redo will */

class StackV<T> {
  List<T> mystack = [];
  void push(T element) {
    mystack.insert(0, element);
  }

  void pop() {
    if (mystack != []) {
      mystack.removeAt(0);
    }
  }

  List<T> srint() {
    return mystack;
  }

  T last() {
    return mystack[0];
  }

  bool isEmpty() {
    return mystack.isEmpty;
  }
}
