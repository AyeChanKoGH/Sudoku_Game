import 'package:flutter/material.dart';
//import 'package:localstorage/localstorage.dart';

/*This is Sudoku Cell class to generate, to modefild, and getting data to desplay  */
class Sudoku {
  Color? _errcolor = Colors.red;
  Color? _act_bgcolor = Colors.cyanAccent;
  Color? _key_Color = Colors.purple[200];
  Color? _cell_bgcolor = Colors.tealAccent;
  Color? _themecolor = Colors.white10;
  Color? _defcolor = Colors.black;
  List _n_color = [
    Colors.lightBlue,
    Colors.orangeAccent,
    Colors.pinkAccent
  ]; //for active _color
  List _board = List.generate(9, (_) => List.generate(9, (_) => 0));
  List _bgcolor = List.generate(9, (_) => List.generate(9, (_) => Colors.white10));
  List<List> _color = List.generate(9, (_) => List.generate(9, (_) => Colors.black));
  int? _active_row = null;
  int? _active_col = null;
  int? _curnum = null; //adding current number
  int _curColor = 0;
  bool _draf = false;
  bool _clickable = true;
  StackV _undo = new StackV<Map>();
  StackV _redo = new StackV<Map>();
  get getboard => _board;
  get getcolor => _color;
  get getbgcolor => _bgcolor;
  //////////////////////
  // SET Cells,Active Row and Column,Colors,Background Colors
  ////////////////////////////////////////////////////
  void setBoard_init(List iniBoard, {var bgcolor, var color}) {
    _board = iniBoard;
    if (bgcolor != null) {
      _bgcolor = bgcolor;
      _color = color;
    } else {
      _bgcolor = List.generate(9, (_) => List.generate(9, (_) => Colors.white10));
      _color = List.generate(9, (_) => List.generate(9, (_) => Colors.black));
    }
    _active_row = null;
    _active_col = null;
    _curnum = null; //adding current number
    _curColor = 0;
    _draf = false;
    _clickable = true;
    _undo = new StackV<List>();
    _redo = new StackV<List>();
  }

  void setBoardCell(int num, {state = null}) {
    int? row = this._active_row;
    int? col = this._active_col;
    if (row != null && col != null) {
      if (isdefaultCell(row, col)) {
        if (_draf == false && (_board[row][col] == 0 || _board[row][col] == num)) {
          isValid(row, col, num) ? _bgcolor[row][col] = _cell_bgcolor : _bgcolor[row][col] = _errcolor;

          if (_board[row][col] == num) {
            clear();
          } else {
            _board[row][col] = num;
            setnumbg(num);
            _color[row][col] = _n_color[_curColor];
            if (state == 'Undo') {
              redo_push('int', row, col, num);
            } else {
              undo_push('int', row, col, num);
              if (state != 'Redo') clear_redo();
            }
          }
        } else {
          if (_draf == false) {
            set_draf();
          }
          set_board_cell_draf(row, col, num, state: state);
        }
      }
    } else {
      setnumbg(num);
    }
    if (isFinish()) {
      _bgcolor = List.generate(9, (_) => List.generate(9, (_) => _act_bgcolor));
    }
  }

  void set_board_cell_draf(int row, int col, int num, {state = null}) {
    //set_draf();

    if (_board[row][col].contains(num)) {
      _board[row][col].remove(num);
      _color[row][col].remove('${num}');
      if (_board[row][col].length == 1) {
        _draf = false;
        _clickable = true;
        isValid(row, col, _board[row][col][0]) ? _bgcolor[row][col] = _cell_bgcolor : _bgcolor[row][col] = _errcolor;
        _board[row][col] = _board[row][col][0];
        _color[row][col] = _n_color[_color[row][col]['${_board[row][col]}']];
      } else if (_board[row][col].isEmpty) {
        _clickable = true;
        _draf = false;
        _board[row][col] = 0;
        _color[row][col] = _defcolor;
      }
      if (state != 'Autofill') {
        if (state == 'Undo') {
          redo_push('List', row, col, num);
        } else {
          undo_push('List', row, col, num);
          if (state != 'Redo') clear_redo();
        }
      }
    } else {
      setnumbg(num);
      changebgColor(row, col, _act_bgcolor);
      _board[row][col].add(num);
      _color[row][col]['${num}'] = _curColor;

      if (_board[row][col].length > 1) {
        _clickable = false;
      } else {
        _clickable = true;
      }
      if (state != 'Autofill') {
        if (state == 'Undo') {
          redo_push('Listadd', row, col, num);
        } else {
          undo_push('Listadd', row, col, num);
          if (state != 'Redo') clear_redo();
        }
      }
    }
  }

  // Set bgcolor of specific number to help in thinking
  void setnumbg(int? num) {
    remove_curnum();
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_board[i][j] == num && _bgcolor[i][j] == _themecolor) _bgcolor[i][j] = _key_Color;
      }
    }
    _curnum = num;
  }

  void remove_curnum() {
    if (_curnum != null) {
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (_board[i][j] == _curnum && _bgcolor[i][j] != _errcolor) _bgcolor[i][j] = _themecolor;
        }
      }
      _curnum = null;
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
      changebgColor(_active_row ?? 0, _active_col ?? 0, _themecolor);
    }
    if (setdigit) {
      setnumbg(_board[row][col]);
    } else {
      remove_curnum();
    }
    this._active_row = row;
    this._active_col = col;
    changebgColor(row, col, _act_bgcolor);
    //setnumbg();
  }

  void set_curColor() {
    if (_n_color.length - 1 > _curColor) {
      _curColor++;
    } else {
      _curColor = 0;
    }
  }

  void set_unactive() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (_bgcolor[row][col] == _act_bgcolor || _bgcolor[row][col] == _cell_bgcolor || _bgcolor[row][col] == _key_Color) {
          _bgcolor[row][col] = _themecolor;
        }
      }
    }
    this._active_row = null;
    this._active_col = null;
    this._draf = false;
    remove_curnum();
  }
  /////

  ////////////////////////////////
  //__When set _draf is clicked pencil mode is on
  //__When set _draf is clicked pencil mode is off
  void set_draf() {
    int? row = _active_row;
    int? col = _active_col;
    if (row != null && col != null) {
      if (isdefaultCell(row, col)) {
        _draf = true;
        _bgcolor[row][col] = _cell_bgcolor;
        if (_board[row][col] == 0) {
          _board[row][col] = [];
          _color[row][col] = {};
        } else if (_board[row][col] is int) {
          _board[row][col] = [
            _board[row][col]
          ];
          _color[row][col] = {};
          _color[row][col]['${_board[row][col][0]}'] = _curColor;
        } else if (_board[row][col] is List && _board[row][col].length == 1) {
          isValid(row, col, _board[row][col][0]) ? _bgcolor[row][col] = _cell_bgcolor : _bgcolor[row][col] = _errcolor;
          _board[row][col] = _board[row][col][0];
          _color[row][col] = _n_color[_color[row][col]['${_board[row][col]}']];
          _draf = false;
          if (isFinish()) {
            _bgcolor = List.generate(9, (_) => List.generate(9, (_) => _act_bgcolor));
          }
        } else if (_board[row][col].isEmpty) {
          // this cell is List with no value
          _board[row][col] = 0;
          _color[row][col] = _defcolor;
        }
      }
    }
  }

//################# Auto fill */
  void auto_fill() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (_board[row][col] == 0 || _board[row][col] is List) {
          addpossible(row, col);
        }
      }
    }
    set_unactive();
  }

  void addpossible(int row, int col) {
    _active_row = row;
    _active_col = col;

    if (_board[row][col] == 0) {
      set_draf();
    } else {
      _board[row][col] = [];
    }
    for (int num = 1; num < 10; num++) {
      if (isValid(row, col, num) && !_board[row][col].contains(num)) {
        set_board_cell_draf(row, col, num, state: 'Autofill');
      }
    }
  }

/////////////////Getting value from Class////////////////////
  dynamic getBoardCell(int row, int col) {
    return _board[row][col];
  }

  Color? get_curColor() {
    return _n_color[_curColor];
  }

  Color? getBoardColor(int row, int col) {
    return _bgcolor[row][col];
  }

  Color? get_tcol(int row, int col) {
    return _color[row][col];
  }

  Color? get_dtcol(int row, int col, int num) {
    int tcol = _color[row][col]['${num}'];
    return _n_color[tcol];
  }

  int get_n_key(int? num) {
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
  void changebgColor(int row, int col, Color? color) {
    /*changebgColor(row,col,_col) */
    for (int i = 0; i < 9; i++) {
      if (_bgcolor[i][col] != _errcolor) {
        _bgcolor[i][col] = color;
      }
    }
    //Fill Row _color
    for (int i = 0; i < 9; i++) {
      if (_bgcolor[row][i] != _errcolor) {
        _bgcolor[row][i] = color;
      }
    }
    //Fill region _color
    /*int x0 = (row ~/ 3) * 3;
    int y0 = (col ~/ 3) * 3;
    for (int i = x0; i < x0 + 3; i++) {
      for (int j = y0; j < y0 + 3; j++) {
        if (_bgcolor[i][j] != _errcolor) {
          _bgcolor[i][j] = _color;
        }
      }
    }*/
    if (color == _act_bgcolor) {
      if (_bgcolor[row][col] != _errcolor) {
        _bgcolor[row][col] = _cell_bgcolor;
      }
    }
  }

  void clear([String? state]) {
    int? row = _active_row;
    int? col = _active_col;
    if (row != null && col != null) {
      var value = _board[row][col];
      if (value != 0) {
        remove_curnum();
        _bgcolor[row][col] = _cell_bgcolor;
        changebgColor(row, col, _act_bgcolor);
        if (state == 'Undo') {
          redo_push('0', row, col, value);
        } else {
          undo_push('0', row, col, value);
          if (state != 'Redo') clear_redo();
        }
        _board[row][col] = 0;
        _color[row][col] = _defcolor;
        _draf = false;
      }
    }
  }

  //  UNDO REDO Function
  void undo() {
    if (!_undo.isEmpty()) {
      List lundo = _undo.last();
      set_active_row_col(lundo[1], lundo[2]);
      //undo_pop();
      if (lundo[0] == 'int') {
        //adding a value to specific cell it mean the cell is 0 befor add.
        clear('Undo');
      } else if (lundo[0] == '0') {
        //when we clear in cell, there are two possible this cell must be specific value or draf
        setBoardCell(lundo[3], state: 'Undo');
      } else if (lundo[0] == 'List') {
        //state is List,there are two possible one form list to list or one from 0 to list
        setBoardCell(lundo[3], state: 'Undo');
        //set_board_cell_draf(lundo[1], lundo[2], lundo[3],state:'Undo');
      } else {
        if (_board[lundo[1]][lundo[2]] is List) {
          set_board_cell_draf(lundo[1], lundo[2], lundo[3], state: 'Undo');
        } else {
          clear('Undo');
        }
      }
    }
  }

  void redo() {
    /**you acidiend undo a number you can easily redo it. */
    if (!_redo.isEmpty()) {
      List lredo = _redo.last();
      set_active_row_col(lredo[1], lredo[2]);
      //redo_pop();
      if (lredo[0] == 'int') {
        //adding a value to specific cell it mean the cell is 0 befor add.
        clear('Redo');
      } else if (lredo[0] == '0') {
        //when we clear in cell, there are two possible this cell must be specific value or draf
        setBoardCell(lredo[3], state: 'Redo');
      } else if (lredo[0] == 'List') {
        //state is List,there are two possible one form list to list or one from 0 to list
        setBoardCell(lredo[3], state: 'Redo');
        //set_board_cell_draf(lundo[1], lundo[2], lundo[3],state:'Undo');
      } else {
        if (_board[lredo[1]][lredo[2]] is List) {
          set_board_cell_draf(lredo[1], lredo[2], lredo[3], state: 'Redo');
        } else {
          clear('Redo');
        }
      }
    }
  }

  void undo_push(String? state, int? row, int? col, var value) {
    /**state mean classifying value type, which is int,List or 0 */
    _undo.push([
      state,
      row,
      col,
      value
    ]);
    redo_pop();
  }

  void undo_pop() {
    /**state,row,col,value */
    _undo.pop();
  }

  void redo_push(String? state, int? row, int? col, var value) {
    _redo.push([
      state,
      row,
      col,
      value
    ]);
    undo_pop();
  }

  void redo_pop() {
    if (!_redo.isEmpty()) {
      _redo.pop();
    }
  }

  void clear_redo() {
    _redo = StackV<List>();
  }
//////////  Checking functions/////////////

  bool isFinish() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_board[i][j] == 0 || _board[i][j] is List || _bgcolor[i][j] == _errcolor) {
          return false;
        }
      }
    }
    return true;
  }

  bool isactive() {
    return _active_row != null;
  }

  bool isdefaultCell(int row, int col) {
    if (_board[row][col] != 0 && _color[row][col] == _defcolor) return false;
    return true;
  }

  bool isClickable() {
    return _clickable;
  }

  bool isdraf() {
    return _draf;
  }

  bool isCurrentnum(int num) {
    return (_curnum == num);
  }

  bool is_insideCell(int num) {
    int? row = _active_row;
    int? col = _active_col;
    if (row != null && col != null) {
      var actnum = _board[row][col];
      return actnum is int
          ? actnum == num
              ? true
              : false
          : actnum.contains(num)
              ? true
              : false;
    }
    return false;
  }

  bool isValid(int t_row, int t_col, int num) {
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
    if (!isEmpty()) {
      mystack.removeAt(0);
    }
  }

  List<T> srint() {
    return mystack;
  }

  T? last() {
    if (!isEmpty()) {
      return mystack[0];
    }
    return null;
  }

  bool isEmpty() {
    return mystack.isEmpty;
  }
}
