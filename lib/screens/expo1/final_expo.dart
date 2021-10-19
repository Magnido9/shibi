library expo;

import 'package:application/screens/home/home.dart';
import 'package:tuple/tuple.dart';

import 'package:application/screens/Avatar/avatar.dart';
import 'package:application/screens/login/homescreen.dart';
import 'package:application/screens/login/password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'body.dart';
import 'feelings.dart';
import 'thoughts.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'ToolsChoosing.dart';

class FinalExpo extends StatelessWidget {
  FinalExpo({required this.adata, required this.theCase});
  final AvatarData adata;
  final String theCase;
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (
        context,
      ) =>
          ExpoData(
              adata: adata,
              theCase: theCase,
              body_task: 0,
              feelings_task: 0,
              thoughts_task: 0),
      child: MaterialApp(
        title: 'חשיפה 1',
        // Start the app with the "/" named route. In this case, the app starts
        // on the FirstScreen widget.
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => _Page1(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/second': (context) => _Page2(),
          '/main': (context) => _Main(),
          '/four': (context) => _Page4(),
          '/thoughts/1': (context) => thought1_1(),
          '/thoughts/2': (context) => thought2_1(),
          '/feelings/1': (context) => feeling1_1(),
          '/body/1': (context) => body1_1(),
          '/tools': (context) => tools(
                adata: adata,
                theCase: this.theCase,
              ),
          '/home': (context) => HomePage()
        },
      ),
    );
  }
}

class _Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<_Page1> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //C8F6B1
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x79F13D), Colors.white])),
      child: Stack(
        children: [
          Positioned(
              top: -150,
              child: Container(
                child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 0.7),
                    duration: Duration(seconds: 1),
                    builder:
                        (BuildContext context, double percent, Widget? child) {
                      return CustomPaint(
                          painter: _LoadBar(
                              percent: 0, size: MediaQuery.of(context).size),
                          size: MediaQuery.of(context).size);
                    }),
                // color:Colors.green
              )),
          /*Positioned(
              left: -0.8 * MediaQuery.of(context).size.width,
              top: -1.25 * MediaQuery.of(context).size.height,
              child: Container(
                  width: 0.8125 * MediaQuery.of(context).size.height * 2,
                  height: 0.8125 * MediaQuery.of(context).size.height * 1.8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xffdee8f3)))),*/
          Align(
            alignment: Alignment.topRight,
            child: Container(
              child: FloatingActionButton(
                elevation: 0,
                disabledElevation: 0,
                backgroundColor: Colors.grey.shade400,
                onPressed: () {},
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
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Colors.transparent,
                    onPressed: () {},
                    child: new IconTheme(
                      data:
                          new IconThemeData(size: 35, color: Color(0xff6f6ca7)),
                      child: new Icon(Icons.menu),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "        ביצוע החשיפה",
                      //textAlign: TextAlign.center,
                      style: GoogleFonts.assistant(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "כל הכבוד! הגעתם לחשיפה :)",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.assistant(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "חשוב מאוד להסתער על החשיפה ולא לגשת\nאליה בכניעה, או פחד. לכן, זקפי את הגוף, כווצי\nוהרפי את השרירים, קחו נשימה עמוקה וזכרו-\nזה לא צריך להיות מושלם, \nכל התנסות נחשבת. \n",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.assistant(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                ],
              ),
              Container(
                  margin: EdgeInsets.all(40),
                  child: Stack(children: [
                    Container(
                        width: 200,
                        height: 39,
                        child: MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/second');
                            },
                            minWidth: 200,
                            height: 39,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36)),
                            color: Color(0xff35258a),
                            child: Stack(children: <Widget>[
                              Positioned(
                                top: 5,
                                right: 25,
                                child: Text(
                                  "יוצאים לדרך!",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.assistant(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ]))),
                    Positioned(
                        top: 5,
                        right: 165,
                        child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              border: Border.all(color: Colors.white, width: 9),
                            ))),
                  ]))
            ],
          ),
          Positioned(
              bottom: 0,
              child: Center(child: Image.asset('images/Soldier1.png')))
        ],
      ),
    ));
  }
}

class _Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<_Page2> {
  double feeling = 50;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x79F13D), Colors.white])),
      child: Stack(
        children: [
          Positioned(
              top: -150,
              child: Container(
                child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 0.7),
                    duration: Duration(seconds: 1),
                    builder:
                        (BuildContext context, double percent, Widget? child) {
                      return CustomPaint(
                          painter: _LoadBar(
                              percent: 0, size: MediaQuery.of(context).size),
                          size: MediaQuery.of(context).size);
                    }),
                // color:Colors.green
              )),
          /*Positioned(
              left: -0.8 * MediaQuery.of(context).size.width,
              top: -1.25 * MediaQuery.of(context).size.height,
              child: Container(
                  width: 0.8125 * MediaQuery.of(context).size.height * 2,
                  height: 0.8125 * MediaQuery.of(context).size.height * 1.8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xffdee8f3)))),*/
          Align(
            alignment: Alignment.topRight,
            child: Container(
              child: FloatingActionButton(
                elevation: 0,
                disabledElevation: 0,
                backgroundColor: Colors.grey.shade400,
                onPressed: () {},
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
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Colors.transparent,
                    onPressed: () {},
                    child: new IconTheme(
                      data:
                          new IconThemeData(size: 35, color: Color(0xff6f6ca7)),
                      child: new Icon(Icons.menu),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "        ביצוע החשיפה",
                      //textAlign: TextAlign.center,
                      style: GoogleFonts.assistant(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "זמן לבצע את החשיפה -",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.assistant(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ))
                ],
              ),
              Container(
                  height: 400,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(30),
                        width: width * 0.9,
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xccebebeb),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            Provider.of<ExpoData>(context, listen: false)
                                .theCase,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.assistant(
                              color: Color(0xff6f6ca7),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.19,
                        left: width * 0.05,
                        child: Container(
                            margin: EdgeInsets.all(40),
                            child: Stack(children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  child: MaterialButton(
                                      disabledElevation: 0,
                                      elevation: 0,
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/main');
                                      },
                                      minWidth: 100,
                                      height: 100,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      color: Color(0xff35258a),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                          top: 35,
                                          right: 0,
                                          child: Text(
                                            "ביצעתי!",
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.assistant(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      ]))),
                            ])),
                      )
                    ],
                  ))
            ],
          ),
          Positioned(
              bottom: 0,
              child: Center(child: Image.asset('images/Soldier2.png')))
        ],
      ),
    ));
  }
}

class _Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<_Main> {
  double feeling=0;
  int choose = -1;
  @override
  Widget build(BuildContext context) {
    print('page3');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(body:
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x79F13D), Colors.white])),
          child: Stack(
            children: [
              Positioned(
                  top: -150,
                  child: Container(
                    child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 0.7),
                        duration: Duration(seconds: 1),
                        builder:
                            (BuildContext context, double percent, Widget? child) {
                          return CustomPaint(
                              painter: _LoadBar(
                                  percent: 0, size: MediaQuery.of(context).size),
                              size: MediaQuery.of(context).size);
                        }),
                    // color:Colors.green
                  )),
              /*Positioned(
              left: -0.8 * MediaQuery.of(context).size.width,
              top: -1.25 * MediaQuery.of(context).size.height,
              child: Container(
                  width: 0.8125 * MediaQuery.of(context).size.height * 2,
                  height: 0.8125 * MediaQuery.of(context).size.height * 1.8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xffdee8f3)))),*/
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: FloatingActionButton(
                    elevation: 0,
                    disabledElevation: 0,
                    backgroundColor: Colors.grey.shade400,
                    onPressed: () {},
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
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        color: Colors.transparent,
                        onPressed: () {},
                        child: new IconTheme(
                          data:
                          new IconThemeData(size: 35, color: Color(0xff6f6ca7)),
                          child: new Icon(Icons.menu),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "            דיווח שיא",
                          //textAlign: TextAlign.center,
                          style: GoogleFonts.assistant(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(20,20,20,0),
                          child: Text(
                            "מדהימים!\nדרגו את החרדה שלכם בשיא החשיפה",
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.assistant(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ))
                    ],
                  ),Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(20,10,20,20),
                          child: Text(
                            "דרגו יחידות מצוקה ברגע הכי קשה ומאתגר\n במהלך החשיפה.",
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.assistant(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ))
                    ],
                  ),
              Container(
                margin:
                    EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 0),
                child: SfSliderTheme(
                  data: SfSliderThemeData(
                    activeTrackHeight: 20,
                    inactiveTrackHeight: 20,
                    thumbColor: Color(0xffefb3e2),
                    inactiveTrackColor: Color(0xffececec),
                    activeTrackColor: Color(0xffececec),
                    thumbRadius: 20,
                    activeDividerRadius: 0,
                    activeDividerStrokeWidth: 0,
                    thumbStrokeWidth: 0,
                  ),
                  child: SfSlider(

                    value: feeling.round(),
                    min: 0,
                    max: 100,
                    showLabels: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        feeling = value;
                      });
                    },
                  ),
                ),
              ),
              /*Container(
                child: Text
                  (
                  "0                                                   100",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Assistant",
                    //fontWeight: FontWeight.w700,
                  ),
                ),

              ),*/
              Container(
                height: 20,
              ),
            ],
          ),
              Positioned(
                  bottom: 0,
                  child: Center(child: Image.asset('images/Soldier3.png'))),
          Positioned(
              top: height * 0.92,
              right: width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff35258a),
                      shape: CircleBorder(),
                      fixedSize: Size(55, 55),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/four');
                    },
                  )
                ],
              )),

        ],
      ),
    ));
  }



  String _title() {
    var x = Provider.of<ExpoData>(context, listen: false).introductions;
    if (choose == 0) return x[0].item1;
    if (choose == 1) return x[1].item1;
    if (choose == 2) return x[2].item1;
    return '';
  }

  String _text() {
    var x = Provider.of<ExpoData>(context, listen: false).introductions;
    if (choose == 0) return x[0].item2;
    if (choose == 1) return x[1].item2;
    if (choose == 2) return x[2].item2;
    return '';
  }

  Color _color() {
    var x = Provider.of<ExpoData>(context, listen: false).colors;
    if (choose == 0) return x[1];
    if (choose == 1) return x[2];
    if (choose == 2) return x[0];
    return Color(0xffefd6ee);
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
                                ? Color(0xffB3E8EF)
                                : Color(0xff35258A),
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
                            : Color(0xffdee8f3),
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
class _Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<_Page4> {
  TextEditingController? _controller;
  double feeling=0;
  int choose = -1;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print('page4');

    @override
    void initState() {
      _controller = TextEditingController(text: "");

      super.initState();
    }
    Future<void> _add() async {

      String? pid = AuthRepository.instance().user?.uid;
      var v =
      (await FirebaseFirestore.instance.collection("avatars").doc(pid).get());
      int money=0;
      if(v.data()==null){
        money=0;}
      else {
        money = v['money'];
      }
      print(money);
      money+=10;
      await FirebaseFirestore.instance
          .collection("avatars")
          .doc(pid)
          .set({'money':money}, SetOptions(merge: true));
    }
    return Scaffold(body:
    Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x79F13D), Colors.white])),
      child: Stack(
        children: [
          Positioned(
              top: -150,
              child: Container(
                child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 0.7),
                    duration: Duration(seconds: 1),
                    builder:
                        (BuildContext context, double percent, Widget? child) {
                      return CustomPaint(
                          painter: _LoadBar(
                              percent: 0, size: MediaQuery.of(context).size),
                          size: MediaQuery.of(context).size);
                    }),
                // color:Colors.green
              )),Positioned(bottom:0,
            child:Image.asset("images/Soldier3.png")
          ),
          /*Stack(children: [
                      Align(
                      alignment: FractionalOffset.bottomRight,
                      child: Container(
                        child: FittedBox(
                          child: Image.asset('images/shibi_pages/money.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ), Positioned(
                        bottom: 0.5*0.65* MediaQuery.of(context).size.height,
                        left: 0,
                        right:0,
                        top:0,
                        child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                      children:[  Text(
                        "יאייייי!",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.assistant(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),),Text(
                        " זכית ב"+this.to_give.toString()+" מטבעות",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.assistant(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),),Text(
                        "השתמשו בהם בחוכמה ;]",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.assistant(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),)



                ]))],)*/
          Align(
            alignment: Alignment.topRight,
            child: Container(
              child: FloatingActionButton(
                elevation: 0,
                disabledElevation: 0,
                backgroundColor: Colors.grey.shade400,
                onPressed: () {},
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
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Colors.transparent,
                    onPressed: () {},
                    child: new IconTheme(
                      data:
                      new IconThemeData(size: 35, color: Color(0xff6f6ca7)),
                      child: new Icon(Icons.menu),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "            דיווח שיא",
                      //textAlign: TextAlign.center,
                      style: GoogleFonts.assistant(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(20,20,20,0),
                      child: Text(
                        "שתפו, איך הרגשתם?",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.assistant(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ))
                ],
              ),
              Container(
                height: 25),Container(
                width: 370,
                height: 252,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(31),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ],
                  color: Color(0xffe0dfd9),
                ),
                child: Stack(children: [Column(children: [
                  Container(height: 42),
                  Container(
                    width: 360,
                    height: 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0x2d34248a),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(height: 42),
                  Container(
                    width: 360,
                    height: 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0x2d34248a),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(height: 42),
                  Container(
                    width: 360,
                    height: 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0x2d34248a),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(height: 42),
                  Container(
                    width: 360,
                    height: 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0x2d34248a),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(height: 42),
                  Container(
                    width: 360,
                    height: 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0x2d34248a),
                        width: 1,
                      ),
                    ),
                  ),

                ],),
                  Positioned(
                      top: -10,
                      right: 0,
                      left: 0,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          height: 2.25,
                          fontFamily: "Assistant",
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: InputDecoration(
                          hintText: '...',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        textDirection: TextDirection.rtl,
                        controller: _controller,
                        maxLines: 5,
                      )),
                  Positioned(
                      top: 193,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xff35258a),
                              shape: CircleBorder(),
                              fixedSize: Size(55, 55),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: 40,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(36)),
                                    backgroundColor: Color(0xffECECEC),
                                    content: Container(
                                      height:height*0.6,
                                      width:width*0.8,

                                      child:Stack(children: [
                                      Positioned(
                                        bottom:-30,
                                        right:-20,
                                        child: Container(
                                          child: FittedBox(
                                            child: Image.asset('images/Soldier4.png'),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ), Positioned(
                                          bottom: 0.5*0.65* MediaQuery.of(context).size.height,
                                          left: 0,
                                          right:0,
                                          top:0,
                                          child:Column(

                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                                              children:[

                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                          Home())),
                                                  child: const Text(
                                                    'x',
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                ),Text(
                                                "יאייייי!",
                                                textDirection: TextDirection.rtl,
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.assistant(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w900,
                                                ),),Text(
                                                " זכית ב 10"+" מטבעות",
                                                textDirection: TextDirection.rtl,
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.assistant(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900,
                                                ),),Text(
                                                "השתמשו בהם בחוכמה ;]",
                                                textDirection: TextDirection.rtl,
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.assistant(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),)



                                              ]))],),)

                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      )),
              ]),

              /*Container(
                child: Text
                  (
                  "0                                                   100",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Assistant",
                    //fontWeight: FontWeight.w700,
                  ),
                ),

              ),*/
              )],
          ),

        ],
      ),
    ));
  }}
class ExpoData {
  ExpoData(
      {required this.adata,
      required this.theCase,
      required this.body_task,
      required this.feelings_task,
      required this.thoughts_task}) {
    while (feelings.length % 8 != 0) {
      feelings.add('');
    }

    introductions = [
      all_introductions[0][body_task],
      all_introductions[1][feelings_task],
      all_introductions[2][thoughts_task]
    ];
  }
  int body_task, feelings_task, thoughts_task;
  String theCase;
  List<Color> colors = [
    Color(0xfff3f1de),
    Color(0xffdef3df),
    Color(0xffefd6ee)
  ];
  List<List<Tuple2<String, String>>> all_introductions = [
    [Tuple2('זיהוי גוף', 'חשוב שנלמד לזהות כיצד הגוף משפיע על החרדה שלנו.')],
    [Tuple2('זיהוי רגשות', 'הרגש הוא חלק מהותי מן החרדה שלנו......')],
    [Tuple2('זיהוי מחשבות', 'המחשבות הם מחל מהמחשבה, וחשוב שנאתרן...')]
  ];
  List<Tuple2<String, String>> introductions = [];

  List<bool> done = [false, false, false];
  int stress = 50;
  List<String> thoughts = [
    'אני תמיד אגיד או אעשה משהו...',
    'הכי נורא שיכול לקרות זה...',
    'תמיד כשאני עושה דברים כאלו...',
    'אף אחד אף פעם לא אוהב ש...',
    'אני מרגישה לא בנוח ולכן...',
    'אני לא אדע איך...'
  ];
  List<String> replies = ['', '', '', '', '', ''];
  List<String> feelings = [
    'סיבוך',
    'פגיעות',
    'עצב',
    'בדידות',
    'ריקנות',
    'אבודה',
    'נידוי',
    'אכזבה',
    'בחילה',
    'תיעוב',
    'גועל',
    'חוסר נוחות',
    'היסוס',
    'אדישות',
    'חרטה',
    'מוצף',
    'מפוחד',
    'מופתע',
    'נואשות',
    '',
    'לחץ',
    'מבועט',
    'ספקנות',
    'פאניקה',
    'ביטחון עצמי',
    'השראה',
    'ריגוש',
    'תקווה',
    '',
    'גאווה',
    'שמחה',
    'הקלה',
    'מרמור',
    'השפלה',
    '',
    'מופתע',
    'נואשות',
    'כעס',
    'עצבנות',
    'תסכול',
    'רוגז',
    'קימום'
  ];
  List<int> felt = [];

  List<String> painSpots = [];
  AvatarData adata;
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
    canvas.drawCircle(
        center,
        size.width * 1.05,
        painter
          ..color = Color(0xE5F3DE)
          ..style = PaintingStyle.fill);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width * 1.05),
        0,
        pi,
        false,
        painter
          ..color = Color(0xffc4c4c4)
          ..style = PaintingStyle.stroke);
    double pad = 0.2;

    Offset off1 = center +
        Offset(-sin(pi / 6 - pad) * size.width, cos(pi / 6 - pad) * size.width);
    painter
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    Offset off2 = center + //
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
