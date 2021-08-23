import 'package:flutter/material.dart';

class Fakesudoku {
  final List _board;
  Fakesudoku(this._board);
  dynamic getboard(int row, int col) {
    return _board[row][col];
  }
}

class FakeSudokuUi extends StatelessWidget {
  final Fakesudoku fsudoku;
  FakeSudokuUi({Key? key, required this.fsudoku}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        top: BorderSide(width: 3.0, color: Colors.blue),
        left: BorderSide(width: 3.0, color: Colors.blue),
      ),
      children: _getTableRow(),
    );
  }

  List<TableRow> _getTableRow() {
    return List.generate(9, (int rowNumber) {
      return TableRow(children: _getRow(rowNumber));
    });
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(9, (int colNumber) {
      return Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: (colNumber % 3) == 2 ? 3.0 : 1.0, color: (colNumber % 3) == 2 ? Colors.blue : Colors.grey),
              bottom: BorderSide(width: (rowNumber % 3) == 2 ? 3.0 : 1.0, color: (rowNumber % 3) == 2 ? Colors.blue : Colors.grey),
            ),
          ),
          child: SudokuCell(rowNumber, colNumber, fsudoku.getboard(rowNumber, colNumber)));
    });
  }
}

class SudokuCell extends StatelessWidget {
  final row, col;
  final num;
  SudokuCell(this.row, this.col, this.num);

  //final bool ishash = false;
  bool hatch() {
    if ([
              0,
              1,
              2,
              6,
              7,
              8
            ].contains(row) &&
            [
              3,
              4,
              5
            ].contains(col) ||
        [
              0,
              1,
              2,
              6,
              7,
              8
            ].contains(col) &&
            [
              3,
              4,
              5
            ].contains(row)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screen_w = MediaQuery.of(context).size.width;
    return Container(
      height: screen_w * 0.1,
      width: screen_w * 0.1,
      color: hatch() ? Theme.of(context).backgroundColor : null,
      child: Container(
        child: num is int
            ? Center(
                child: Text(num != 0 ? '${num}' : '',
                    style: TextStyle(
                      fontSize: 20,
                    )),
              )
            : Stack(
                children: draf(num),
              ),
      ),
    );
  }

  List<Widget> draf(List draf_list) {
    return List.generate(draf_list.length, (int index) {
      return draf_off(draf_list[index], row, col);
    });
  }

  Widget draf_off(int value, int row, int col) {
    final alig = [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight
    ];
    return Align(
      alignment: alig[value - 1],
      child: Padding(
        padding: EdgeInsets.all(1),
        child: Text(
          "${value}",
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
