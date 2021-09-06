/*That page is inspare from https://github.com/NikhilHeda/SudokuSolver

 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/require.dart';
import 'package:sudoku_game/home/play/mainscreen/sudokuclass.dart';
import 'package:sudoku_game/mytheme.dart';
//import 'package:sudoku_game/home/learn/blog.dart' as blog;

class mainscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = context.watch<ThemeNotifier>();
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
                          Provider.of<SudokuNotifier>(context, listen: false).setBoard_restart();
                        })),
                PopupMenuItem(
                    child: ListTile(
                        //leading: Icon(Icons.restore),
                        title: Text("Autofill draf"),
                        onTap: () {
                          Provider.of<SudokuNotifier>(context, listen: false).set_autofill();
                        })),
              ],
            ),
          ],
        ),
        body: Provider.of<SudokuNotifier>(context).isFinish()
            ? Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  SudokuBoard(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  UndoRedo(),
                  SudokuBoard(),
                  KeyPad(),
                  SizedBox(height: 20),
                ],
              ),
      ),
      onTap: () {
        Provider.of<SudokuNotifier>(context, listen: false).isFinish() ? null : Provider.of<SudokuNotifier>(context, listen: false).set_unactive();
        //mysudoku.set_active_row_col(1,0);
      },
    );
  }
}

class SudokuBoard extends StatelessWidget {
  /*Creating sudoku board to add number  */
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(2),
        child: Table(
          border: TableBorder(
            top: BorderSide(width: 3.0, color: Colors.blue),
            left: BorderSide(width: 3.0, color: Colors.blue),
          ),
          children: _getTableRow(),
        ));
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
        Provider.of<SudokuNotifier>(context, listen: false).isFinish() ? null : Provider.of<SudokuNotifier>(context, listen: false).set_active_row_col(this.row, this.col);
      },
      child: SizedBox(
        height: screen_w / 9,
        width: screen_w / 9,
        child: Stack(
          children: <Widget>[
            Container(
              // color: Colors.red,
              child: cell is int
                  ? Center(
                      child: Text(cell != 0 ? '${cell}' : '',
                          style: TextStyle(
                            fontSize: 20,
                            color: mymodel.get_tcol(row, col) == Colors.black ? null : mymodel.get_tcol(row, col),
                          )),
                    )
                  : Stack(
                      children: draf(cell),
                    ),
              //decoration: BoxDecoration(
              color: hatch() ? Theme.of(context).backgroundColor : null,
            ),
            Opacity(
              opacity: 0.3, //mymodel.getBoardColor(this.row, this.col) == Colors.red ? 1.0 : 0.3,
              child: Container(
                color: mymodel.getBoardColor(this.row, this.col) == Colors.white10 ? null : mymodel.getBoardColor(this.row, this.col) ?? Colors.white10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> draf(List draf_list) {
    return List.generate(draf_list.length, (int index) {
      //Color tcol=Provider.of<SudokuNotifier>(context,listen:false).get_tcol(row,col,draf_list[index]);
      return draf_off(draf_list[index], row, col);
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
  final int number;
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

/**++++++++++++++++++++++++++++++++++++++
    +++ KeyPad Text button Widget  +++
   ++++++++++++++++++++++++++++++++++++++*/
class mytextbtn extends StatelessWidget {
  /*My TextButton Class for KeyPad Cell
    
  */
  final int number;
  @override
  mytextbtn(this.number);
  Widget build(BuildContext context) {
    final sudokuNotifier = context.watch<SudokuNotifier>();
    if (this.number < 10) {
      int num = sudokuNotifier.get_n_key(number);
      return InkResponse(
        enableFeedback: true,
        onTap: () {
          Provider.of<SudokuNotifier>(context, listen: false).setBoardCell(number);
          if (sudokuNotifier.isFinish()) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('congratulation'),
                content: const Text('You Just Finish!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      sudokuNotifier.set_alert();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            sudokuNotifier.set_alert();
          }
        },
        child: Container(
          color: sudokuNotifier.is_insideCell(number) ? Colors.blueAccent.withOpacity(0.5) : null,
          child: Opacity(
            opacity: sudokuNotifier.isactive() ? 1.0 : 0.3,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text("${this.number}",
                      style: TextStyle(
                        fontSize: sudokuNotifier.isdraf() ? 18 : 25,
                        color: sudokuNotifier.get_curColor(),
                      )),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Text("${num}",
                        style: TextStyle(
                          fontSize: 13,
                          color: sudokuNotifier.get_curColor(),
                        )),
                  ),
                ),
                Container(color: num == 9 ? Colors.green[200]?.withOpacity(0.2) : null),
              ],
            ),
          ),
        ),
      );
    } else if (this.number == 10) {
      return TextButton(
        onPressed: sudokuNotifier.isClickable()
            ? () {
                sudokuNotifier.set_draf();
                if (sudokuNotifier.isFinish()) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('congratulation'),
                      content: const Text('You Just Finish!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                            sudokuNotifier.set_alert();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  sudokuNotifier.set_alert();
                }
              }
            : null,
        child: Icon(Icons.edit),
      );
    } else if (this.number == 11) {
      return TextButton(
        onPressed: () {
          sudokuNotifier.set_curColor();
        },
        child: CircleAvatar(backgroundColor: sudokuNotifier.get_curColor(), radius: 12),
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
  final int value;
  final row, col;
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
  @override
  draf_off(this.value, this.row, this.col);
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme.headline6;
    return Align(
      alignment: alig[value - 1],
      child: Container(
        margin: EdgeInsets.all(1),
        decoration: Provider.of<SudokuNotifier>(context).isCurrentnum(value) ? BoxDecoration(border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(15))) : null,
        child: Text(
          "${value}",
          style: txtTheme?.copyWith(
            color: Provider.of<SudokuNotifier>(context, listen: false).get_dtcol(row, col, value),
          ),
        ),
      ),
    );
  }
}

/************************************************************
      | SUDOKU NOTIFIER to set state for stateless Widget |
    *********************************************************/
class SudokuNotifier extends ChangeNotifier {
  final String rank;
  final int pack;
  final int puzzle;
  Sudoku mysudoku = new Sudoku();
  StateSave? mystate;
  SudokuNotifier(this.rank, this.pack, this.puzzle) {
    mystate = new StateSave(rank, pack, puzzle);
    setBoard_init();
    //setBoard_restart();
  }

  dynamic findlocal() async {
    return mystate?.findlocal();
  }

  void setlocal() {
    mystate?.setlocal(mysudoku.getboard, mysudoku.getcolor, mysudoku.getbgcolor);
  }

  void setBoard_init() async {
    var sud = await findlocal();
    if (sud != null) {
      mysudoku.setBoard_init(sud.board, color: sud.color, bgcolor: sud.bgcolor);
    } else {
      setBoard_restart();
    }
    notifyListeners();
  }

  void setBoard_restart() async {
    var data = await readJson(rank, pack, puzzle);
    mysudoku.setBoard_init(data);
    setlocal();
    notifyListeners();
  }

  dynamic getBoardCell(int row, int col) {
    return mysudoku.getBoardCell(row, col);
  }

  Color? getBoardColor(int row, int col) {
    return mysudoku.getBoardColor(row, col);
  }

  int get_n_key(int num) {
    return mysudoku.get_n_key(num);
  }

  Color? get_tcol(int row, int col) {
    return mysudoku.get_tcol(row, col);
  }

  Color? get_dtcol(int row, int col, int num) {
    return mysudoku.get_dtcol(row, col, num);
  }

  Color? get_curColor() {
    return mysudoku.get_curColor();
  }

  //-------------Set-------------
  void setBoardCell(int num) {
    mysudoku.setBoardCell(num);
    setlocal();
    //notifyListeners();
  }

  void set_active_row_col(int row, int col) {
    mysudoku.set_active_row_col(row, col);
    notifyListeners();
  }

  void set_unactive() {
    mysudoku.set_unactive();
    notifyListeners();
  }

  void set_alert() {
    notifyListeners();
  }

  void set_draf() {
    mysudoku.set_draf();
    //notifyListeners();
  }

  void set_curColor() {
    mysudoku.set_curColor();
    print(mysudoku.getcolor);
    notifyListeners();
  }

  void set_autofill() {
    mysudoku.auto_fill();
    setlocal();
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

  bool isdraf() {
    return mysudoku.isdraf();
  }

  bool is_insideCell(int num) {
    return mysudoku.is_insideCell(num);
  }

  bool isactive() {
    return mysudoku.isactive();
  }

  bool isCurrentnum(int num) {
    return mysudoku.isCurrentnum(num);
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
