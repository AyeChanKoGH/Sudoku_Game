/*That page is inspare from https://github.com/NikhilHeda/SudokuSolver

 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/require.dart';
import 'package:sudoku_game/home/play/mainscreen/sudokuclass.dart';
import 'package:sudoku_game/mytheme.dart';

class mainscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = context.watch<ThemeNotifier>();
    double screen_w = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text("SUDOKU PUZZLE"),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                    child: ListTile(
                        leading: Icon(Icons.lightbulb),
                        title: Text(themeNotifier.isDark ? "Light mode" : "Dark mode"),
                        onTap: () {
                          themeNotifier.setAlt();
                        })),
                PopupMenuItem(
                    child: ListTile(
                        leading: Icon(Icons.restore),
                        title: Text("Restart"),
                        onTap: () {
                          Provider.of<SudokuNotifier>(context, listen: false).setBoard_init();
                        })),
              ],
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Provider.of<SudokuNotifier>(context).isFinish() ? null : UndoRedo(),
            SudokuBoard(),
            Provider.of<SudokuNotifier>(context).isFinish()
                ? SizedBox(
                    height: screen_w * 0.15,
                  )
                : KeyPad(),
            SizedBox(height: 20),
          ],
        ),
      ),
      onTap: () {
        Provider.of<SudokuNotifier>(context, listen: false).set_unactive();
        //mysudoku.set_active_row_col(1,0);
      },
    );
  }
}

class SudokuBoard extends StatelessWidget {
  /*Creating sudoku board to add number  */
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        top: BorderSide(width: 3.0, color: Colors.grey),
        left: BorderSide(width: 3.0, color: Colors.grey),
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
              right: BorderSide(width: (colNumber % 3) == 2 ? 3.0 : 1.0, color: Colors.grey),
              bottom: BorderSide(width: (rowNumber % 3) == 2 ? 3.0 : 1.0, color: Colors.grey),
            ),
          ),
          child: SudokuCell(rowNumber, colNumber));
    });
  }
}

class SudokuCell extends StatelessWidget {
  final int row, col;
  SudokuCell(this.row, this.col);

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
    final mymodel = context.watch<SudokuNotifier>();
    double screen_w = MediaQuery.of(context).size.width;
    var cell = mymodel.getBoardCell(this.row, this.col);
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        Provider.of<SudokuNotifier>(context, listen: false).set_active_row_col(this.row, this.col);
      },
      child: Container(
        height: screen_w * 0.1,
        width: screen_w * 0.1,
        color: hatch() ? Colors.grey[400] : null,
        child: Container(
          // color: Colors.red,
          child: cell is int
              ? Center(
                  child: Text(cell != 0 ? '${cell}' : '',
                      style: TextStyle(
                        fontSize: 20,
                        color: mymodel.get_tcol(row, col),
                      )),
                )
              : Stack(
                  children: draf(cell),
                ),
          decoration: BoxDecoration(
            color: mymodel.getBoardColor(this.row, this.col).withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  List<Widget> draf(List draf_list) {
    return List.generate(draf_list.length, (int index) {
      return draf_off(draf_list[index]);
    });
  }
}

class KeyPad extends StatelessWidget {
  final int numRow = 2;
  final int numCol = 6;
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(width: 2.0, color: Colors.grey),
      children: _getTableRow(),
    );
  }

  List<TableRow> _getTableRow() {
    return List.generate(this.numRow, (int rowNumber) {
      return TableRow(children: _getRow(rowNumber));
    });
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(this.numCol, (int colNumber) {
      return Container(child: KeyPadCell(this.numCol * rowNumber + colNumber + 1));
    });
  }
}

class KeyPadCell extends StatelessWidget {
  int number;
  KeyPadCell(this.number);
  @override
  Widget build(BuildContext context) {
    double screen_w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screen_w * 0.15,
      width: screen_w * 0.15,
      child: mytextbtn(this.number),
    );
  }
}

/***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~~  Undo Redo Button Widget ~~~
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
class UndoRedo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mymodel = context.watch<SudokuNotifier>();
    return Row(children: <Widget>[
      TextButton(
        child: Icon(Icons.undo),
        onPressed: () {
          mymodel.undo();
        },
      ),
      TextButton(
        child: Icon(Icons.redo),
        onPressed: () {
          mymodel.redo();
        },
      ),
    ]);
  }
}

/************************************************************
      | SUDOKU NOTIFIER to set state for stateless Widget |
    *********************************************************/
class SudokuNotifier extends ChangeNotifier {
  String rank;
  int pack;
  int puzzle;
  Sudoku mysudoku = new Sudoku();
  SudokuNotifier(this.rank, this.pack, this.puzzle) {
    setBoard_init();
  }
  void setBoard_init() async {
    var data = await readJson(rank, pack, puzzle);
    mysudoku.setBoard_init(data);
    //mysudoku=new Sudoku(data);
    notifyListeners();
  }

  //var mysudoku = new Sudoku();
  dynamic getBoardCell(int row, int col) {
    return mysudoku.getBoardCell(row, col);
  }

  Color getBoardColor(int row, int col) {
    return mysudoku.getBoardColor(row, col);
  }

  int get_n_key(int num) {
    return mysudoku.get_num_of_key(num);
  }

  Color get_tcol(int row, int col) {
    return mysudoku.get_tcol(row, col);
  }

  Color get_curColor() {
    return mysudoku.get_curColor();
  }

  //-------------Set-------------
  void setBoardCell(int num) {
    mysudoku.setBoardCell(num);
    notifyListeners();
  }

  void set_active_row_col(int row, int col) {
    mysudoku.set_active_row_col(row, col);
    notifyListeners();
  }

  void set_unactive() {
    mysudoku.set_unactive();
    notifyListeners();
  }

  void set_draf() {
    mysudoku.set_draf();
    notifyListeners();
  }

  void set_curColor() {
    mysudoku.set_curColor();
    notifyListeners();
  }

  //^^^^^^^Fetching data from local json file^^^^^^^^//

  //++++++++++ Check++++++++++++//
  bool isFinish() {
    return mysudoku.isFinish();
  }

  bool isClickable() {
    return mysudoku.isClickable();
  }

  bool is_insideCell(int num) {
    return mysudoku.is_insideCell(num);
  }

  void clear() {
    mysudoku.clear();
    notifyListeners();
  }

  //#######__Undo___Redo___####//
  void undo() {
    mysudoku.undo();
    notifyListeners();
  }

  void redo() {
    mysudoku.redo();
    notifyListeners();
  }
}

/**++++++++++++++++++++++++++++++++++++++
    +++ KeyPad Text button Widget  +++
   ++++++++++++++++++++++++++++++++++++++*/
class mytextbtn extends StatelessWidget {
  /*My TextButton Class for KeyPad Cell
    
  */
  @override
  int number;
  mytextbtn(this.number);
  Widget build(BuildContext context) {
    final sudokuNotifier = context.watch<SudokuNotifier>();
    if (this.number < 10) {
      return GestureDetector(
        onTap: () {
          sudokuNotifier.setBoardCell(this.number);
        },
        child: Container(
          color: sudokuNotifier.is_insideCell(number) ? Colors.grey[200] :null,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text("${this.number}",
                    style: TextStyle(
                      fontSize: 25,
                    )),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: Text("${sudokuNotifier.get_n_key(number)}",
                      style: TextStyle(
                        fontSize: 13,
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (this.number == 10) {
      return TextButton(
        onPressed: sudokuNotifier.isClickable()
            ? () {
                sudokuNotifier.set_draf();
              }
            : null,
        child: Icon(Icons.edit),
      );
    } else if (this.number == 11) {
      return TextButton(
        onPressed: () {
          sudokuNotifier.set_curColor();
        },
        child: CircleAvatar(backgroundColor: sudokuNotifier.get_curColor(), radius: 10),
      );
    } else {
      return TextButton(
        onPressed: () {
          sudokuNotifier.clear();
        },
        child: Icon(Icons.close),
      );
    }
  }
}

/****** Pencle Mode *********/
class draf_off extends StatelessWidget {
  @override
  int value = 0;
  draf_off(this.value);
  var alig = [
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
  Widget build(BuildContext context) {
    return Align(
      alignment: alig[value - 1],
      child: Text(
        "${value}",
        style: TextStyle(fontSize: 12.0),
      ),
    );
  }
}
