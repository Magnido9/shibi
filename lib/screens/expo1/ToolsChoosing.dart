library expo;
import 'package:application/screens/expo1/body_tools.dart';
import 'package:application/screens/expo1/thougths_challenge.dart';
import 'package:tuple/tuple.dart';

import 'package:application/screens/Avatar/avatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

import 'feelings_tools.dart';
class tools extends StatefulWidget {
  tools({required this.adata, required this.theCase});
  final AvatarData adata;
  final String theCase;

  @override
  _tools_state createState() => _tools_state(adata: adata,theCase:theCase);
}

class _tools_state extends State<tools> {
  _tools_state({required this.adata, required this.theCase});
  final AvatarData adata;
  final String theCase;
  int choose = -1;
  List<bool> done=[false,false,false];
  @override
  Widget build(BuildContext context) {
    print('ToolsPage');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(  children: [  Positioned(top:-150,child:
        Container(
          child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 0.7),
              duration: Duration(seconds: 1),
              builder:
                  (BuildContext context, double percent, Widget? child) {
                return CustomPaint(
                    painter: _LoadBar(percent: 0, size: MediaQuery.of(context).size),
                    size: MediaQuery.of(context).size);
              }),
          // color:Colors.green
        )),

      Align(
        alignment: Alignment.topRight,
        child: Container(
          child: FloatingActionButton(
            elevation: 0,
            disabledElevation: 0,
            backgroundColor: Colors.grey.shade400,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_forward),
          ),
          margin: EdgeInsets.all(30),
        ),
      ),

      Column(
        children: [
          Container(
            height: 40,
          ),
          Row(
            children: [
              FlatButton(
                color: Colors.transparent,
                onPressed: () {},
                child: new IconTheme(
                  data: new IconThemeData(size: 35, color: Color(0xff6f6ca7)),
                  child: new Icon(Icons.menu),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "           בחירת כלי",
                  //textAlign: TextAlign.center,
                  style: GoogleFonts.assistant(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),),

            ],
          ),//1
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Container(
                  child: Center(
                    child: Text(
                      '?',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,//3
                    color: Color(0xffc4c4c4),
                  ),
                ),
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child:
                        AlertDialog(
                          backgroundColor: Color(0xffECECEC),
                          content: RichText(
                            textDirection: TextDirection.rtl,
                            text: TextSpan(
                              style: GoogleFonts.assistant(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              children: <TextSpan>[
                                //
                                TextSpan(
                                    text:
                                    'עוד לא הוכנס מלל.\n'),

                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text(
                                'x',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),),
                ),
              ),
              Container(
                width:60
              ),
              Container(
                margin: EdgeInsets.only(right: 0, left: 0, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "באיזה כלי תרצי לבחור?",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.assistant(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    Text(
                      "בחרי בכלי שיסייע להקל על החרדה שלך.",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.assistant(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width:20
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          TweenAnimationBuilder<double>(
              tween: Tween<double>(
                  begin: (choose == -1) ? 0.5 : 0.8,
                  end: (choose == -1) ? 0.8 : 0.5),
              duration: Duration(milliseconds: 500),
              builder: (BuildContext context, double percent, Widget? child) {
                return Container(
                  width: (choose == -1) ? width : width * percent,
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _MyButton(
                              isDone: done[0],
                              isSelected: (choose == 0),
                              name: 'גוף',
                              func: () {
                                setState(() {
                                  choose = 0;
                                });
                              },
                              image: 'images/expo/meditate.png'),
                          _MyButton(
                              isDone: done[1],
                              isSelected: (choose == 1),
                              name: 'רגשות',
                              func: () {
                                setState(() {
                                  choose = 1;
                                });
                              },
                              image: 'images/expo/smile.png'),
                          _MyButton(
                              isDone: done[2],
                              isSelected: (choose == 2),
                              name: 'מחשבות',
                              func: () {
                                setState(() {
                                  choose = 2;
                                });
                              },
                              image: 'images/expo/brain.png'),
                        ],
                  ),
                );
              }),
          if (choose != -1)
            Flexible(
              child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: width * 0.9,
                  height: 247,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3f000000),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: _color(),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          _title(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.assistant(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        margin: EdgeInsets.all(30),
                      ),
                      Container(
                        child: Text(
                          _text(),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.assistant(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 30, right: 30),
                      ),
                    ],
                  )),
            ),

        ],
      ),
    Positioned(
      top: height*0.92,
      right: width*0.8,

      child:
    (choose != -1)?
      Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xff35258a),
            shape: CircleBorder(),
            fixedSize: Size(
             55,
              55
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () async {
            if (choose == 2) {
              await Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>ThoughtsChallenge(adata:adata ,theCase: theCase)));
            } else if (choose == 0) {
              await Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>BodyTools(adata:adata ,theCase: theCase)));
            } else if (choose == 1) {
              await Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>FeelingsTools(adata:adata ,theCase: theCase)));
            }
            setState(() {
              choose = -1;
            });
          },
        )
      ],
    ):Container()
    ),
        ])

    );
  }

  String _title() {
    var x =['הרפיית גוף'  ,
      'הרפיית רגש',
      'אתגור מחשבה'];

    if (choose == 0) return x[0];
    if (choose == 1) return x[1];
    if (choose == 2) return x[2];
    return '';
  }

  String _text() {
    var x =['כלי זה עוזר ומאפשר להרגיע את הגוף על ידי כיווץ, הרפיה ונשימות שיקלו על החרדה שלך.'  ,
    'כלי זה עוזר להסיח את הדעת מן המחשבות הללו, על ידי מיקוד בדבר אחד המעורר אצלך רגשות חיוביים',
    'כלי זה מאפשר לך לזהות את המחשבות שבחרת ולנטרל אותן'];
    if (choose == 0) return  x[0];
    if (choose == 1) return x[1];
    if (choose == 2) return  x[2];
    return '';
  }

  Color _color() {

    if (choose == 0) return  Color(0xfff0edf7);
    if (choose == 1) return Color(0xfff0edf7);
    if (choose == 2) return  Color(0xfff0edf7);
    return Color(0xfff0edf7);
  }
}

class _MyButton extends StatelessWidget {
  _MyButton(
      {required this.isSelected,
      required this.name,
      required this.func,
      required this.image,
      this.isDone = false});
  final bool isSelected, isDone;
  final String name, image;
  final func;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GestureDetector(
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(constraints.maxWidth * 0.15),
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Image.asset(
                        image,
                        color: (isDone)
                            ? Color(0xffEDEBEB)
                            : (isSelected)
                                ? Color(0xffe5def3)
                                : Color(0xff35258a),
                      )),
                  margin: EdgeInsets.all(constraints.maxWidth * 0.08),
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isDone)
                        ? Color(0xffABAAAA)
                        : (isSelected)
                            ? Color(0xff35258A)
                : Color(0xffe5def3),
                  ),
                ),
                if (isDone)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                      padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                      margin: EdgeInsets.only(
                          top: constraints.maxWidth * 0.04,
                          right: constraints.maxWidth * 0.08),
                      width: constraints.maxWidth * 0.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff808080),
                      ),
                    ),
                  )
              ],
            );
          }),
          Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          )
        ],
      ),
      onTap: func,
    ));
  }
}



class _LoadBar extends CustomPainter {
  final double percent;
  final Size size;

  _LoadBar({
    required this.percent,
    required this.size,
  });
  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    Offset center = Offset(size.width / 2, -size.width * 0.3);
    canvas.drawCircle(center, size.width*1.05,painter..color = Color(0xffe5def3)
      ..style = PaintingStyle.fill );
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width*1.05), 0, pi,
        false, painter..color = Color(0xffc4c4c4)..style = PaintingStyle.stroke);
    double pad = 0.2;

    Offset off1 = center +
        Offset(-sin(pi / 6 - pad) * size.width, cos(pi / 6 - pad) * size.width);
    painter
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    Offset off2 = center +//
        Offset(sin(pi / 6 - pad) * size.width, cos(pi / 6 - pad) * size.width);
    painter
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
  }

  @override
  bool shouldRepaint(_LoadBar oldDelegate) {
    return percent != oldDelegate.percent;
  }
}
class _PaintTask extends CustomPainter {
  final int slices, complete;

  _PaintTask({required this.slices, required this.complete});

  @override
  void paint(Canvas canvas, Size size) {
    double sw = 7;
    var painter = Paint()
      ..color = Color(0xFFC4C4C4)
    // ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw;
    Offset c = Offset(size.height / 2, size.width / 2);
    double radius = size.height / 2;
    canvas.drawCircle(c, radius, painter);
    canvas.drawArc(Rect.fromCircle(center: c, radius: radius), -pi / 2,
        2 * pi * complete / slices, false, painter..color = Colors.green);

    if (slices > 1 && slices < 21) {
      for (int i = 0; i < slices; i++) {
        var painter2 = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        double phea = 2 * pi * i / slices - pi / 2;
        Offset start = c +
            Offset(
                (radius - sw / 2) * cos(phea), (radius - sw / 2) * sin(phea));
        Offset end = c +
            Offset(
                (radius + sw / 2) * cos(phea), (radius + sw / 2) * sin(phea));
        canvas.drawLine(start, end, painter2);
      }
    }
    canvas.drawCircle(
        Offset(size.height / 2, size.width / 2),
        radius * 0.85,
        painter
          ..style = PaintingStyle.fill
          ..color = Color(0xFFEBE9D6));
  }

  @override
  bool shouldRepaint(_PaintTask oldDelegate) {
    return (slices != oldDelegate.slices) || (complete != oldDelegate.complete);
  }
}
