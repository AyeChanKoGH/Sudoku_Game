import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:sudoku_game/home/learn/fakesudoku.dart';
import 'package:sudoku_game/home/learn/blog.dart' as blog;
import 'package:url_launcher/url_launcher.dart';
import 'package:sudoku_game/mytheme.dart';
import 'package:provider/provider.dart';

class ContextCreate extends StatelessWidget {
  /**Easily to write a blog,
  Write Map type content and show The blog */
  final String value;
  ContextCreate({Key? key, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var themeNotifier = context.watch<ThemeNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.methods[value][0]),
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
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: create_widget(blog.methods[value].sublist(1)))),
    );
  }

  List<Widget> create_widget(List widge) {
    //print("something");
    List<Widget> mywidget = [];
    for (var name in widge) {
      if (name.containsKey('title')) {
        mywidget.add(Textstyle(form: 'title', text: name['title']));
      } else if (name.containsKey('subtitle')) {
        mywidget.add(Textstyle(form: 'subtitle', text: name['subtitle']));
      } else if (name.containsKey('body')) {
        mywidget.add(Textstyle(form: 'body', text: name['body']));
      } else if (name.containsKey('fakesudoku')) {
        final Fakesudoku mysudoku;
        if (name['fakesudoku'] == 'about_one') {
          mysudoku = new Fakesudoku(blog.about_one);
        } else {
          mysudoku = new Fakesudoku(blog.about_two);
        }
        mywidget.add(FakeSudokuUi(fsudoku: mysudoku));
      } else if (name.containsKey('label')) {
        mywidget.add(Textstyle(form: 'label', text: name['label']));
        mywidget.add(SizedBox(
          height: 30,
        ));
      } else if (name.containsKey('image')) {
        mywidget.add(InteractiveViewer(child: Center(child: Image.asset(name['image'], fit: BoxFit.fitWidth))));
      } else if (name.containsKey('list')) {
        mywidget.add(Textlist(mylist: name['list']));
      } else if (name.containsKey('netlink')) {
        mywidget.add(Netlink(listtext: name['netlink']));
      } else if (name.containsKey('internal_link')) {
        mywidget.add(Route_links(link: name['internal_link']));
      } else {
        mywidget.add(Text("မင်္ဂလာပါ", style: TextStyle(fontFamily: 'Pyidaungsu')));
      }
    }
    return mywidget;
  }
}

class Textstyle extends StatelessWidget {
  /**Text style class */
  final String form;
  final String text;
  Textstyle({Key? key, required this.form, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return SelectableText(
      text,
      style: form == 'title'
          ? theme.headline2?.copyWith(fontFamily: 'Pyidaungsu')
          : form == 'subtitle'
              ? theme.headline3
              : form == 'body'
                  ? theme.bodyText2
                  : theme.headline5?.copyWith(fontFamily: 'Pyidaungsu'),
    );
  }
}

class Textlist extends StatelessWidget {
  /**List view in text */
  final List<String> mylist;
  Textlist({Key? key, required this.mylist}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 10),
      shrinkWrap: true,
      children: textlist(),
    );
  }

  List<Widget> textlist() {
    List<Widget> mywidget = [];
    for (String value in mylist) {
      mywidget.add(ListTile(leading: CircleAvatar(radius: 3), title: Textstyle(form: 'body', text: value)));
    }

    return mywidget;
  }
}

class Netlink extends StatelessWidget {
  /**adding Network link in text */
  final listtext;
  Netlink({Key? key, required this.listtext}) : super(key: key);
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText2,
        children: mylist(),
      ),
    );
  }

  List<InlineSpan> mylist() {
    List<InlineSpan> nlist = [];
    for (var value in listtext) {
      if (value is Map) {
        nlist.add(linktext(value));
      } else {
        nlist.add(TextSpan(text: value));
      }
    }
    return nlist;
  }

  InlineSpan linktext(Map tlink) {
    return TextSpan(
      text: tlink.keys.first,
      style: TextStyle(fontSize: 18, color: Colors.blue),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          final url = '${tlink.values.first}';
          if (await canLaunch(url)) {
            await launch(
              url,
              forceSafariVC: false,
            );
          } else {
            SnackBar(content: Text('Sir Cann\'t launch url'));
          }
        },
    );
  }
}

class Route_links extends StatelessWidget {
  /**Adding route link inside text */
  final link;
  Route_links({Key? key, required this.link}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Text(link.keys.first),
        onPressed: () {
          Navigator.pushNamed(context, link.values.first);
        });
  }
}
