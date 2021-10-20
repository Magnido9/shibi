library expo;


import 'package:application/screens/Avatar/avatar.dart';
import 'package:application/screens/expo1/start.dart';
import 'package:application/screens/home/home.dart';
import 'package:application/screens/login/homescreen.dart';
import 'package:application/screens/login/login.dart';
import 'package:application/screens/login/password.dart';
import 'package:application/screens/map/questioneer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/auth_services.dart';
import 'package:flutter/material.dart';
import '../Avatar/color_switch.dart';
import 'dart:math';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;
import 'dart:ui';

import 'package:flutter/services.dart';
class thought1_1 extends StatefulWidget {
  thought1_1();

  @override
  _thought1_state createState() => _thought1_state();
}

class _thought1_state extends State<thought1_1> {
  UI.Image? image;

  Future<AvatarData>? _adata;
  Future<String>? _name;
  @override
  void initState() {
    super.initState();
    _adata = AvatarData.load();
    _name = _getname();
  }

  Future<String> _getname() async {
    var name = (await FirebaseFirestore.instance
        .collection("users")
        .doc(AuthRepository.instance().user?.uid)
        .get())['name'];
    print(name);
    return name;
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
  /**/


  double feeling = 50;
  List<int> chosen = [];

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(key: scaffoldKey,
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Stack(children: [
                Stack(
                  children: [
                    Positioned(
                        child: Image.asset('images/talky.png'),
                        top: 0,
                        right: 0),
                    Positioned(
                        top: 10,
                        right: 6,
                        child: FutureBuilder<String>(
                          future: _name,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            // ...
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              String data = snapshot.data ?? '';
                              return Text(
                                'היי $data\n מה קורה?',
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.assistant(),
                              );
                            }
                            return CircularProgressIndicator();
                          },
                        )),
                  ],
                ),
                Positioned(
                    child: FutureBuilder<AvatarData>(
                      future: _adata,
                      builder: (BuildContext context,
                          AsyncSnapshot<AvatarData> snapshot) {
                        // ...
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AvatarStack(
                              data: (snapshot.data ??
                                  AvatarData(body: AvatarData.body_default)));
                        }
                        return CircularProgressIndicator();
                      },
                    )),
              ])),
          ListTile(
            title: Text("עצב דמות",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Avatar(first: false, data: _adata)));
            },
          ),
          ListTile(
            title: Text("מפת דרכים",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Home()));
            },
          ),ListTile(
            title: Text("שאלון יומי",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      MyQuestions()));
            },
          ),
          ListTile(
            title: Text("התנתק",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {
              Future<void> _signOut() async {
                await FirebaseAuth.instance.signOut();
              }

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Login()));
            },
          ),
        ]),
      ),
      body: Stack(
        children: [
          Positioned(top:-150,child:
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
          Positioned(child:Container(

            padding: EdgeInsets.all(5),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Image.asset('images/expo/brain.png',
                  color: Color(0xffB3E8EF)),
            ),
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff35258A),
            ),
          ),
          top:height*0.132,
          right:width*0.08
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 50,
              child: Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.grey.shade400,
                    disabledElevation: 0,
                    elevation:0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_forward),
                  ),
                  Container(
                    height: 10,
                  ),

                ],
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
                    onPressed:  () => scaffoldKey.currentState!.openDrawer(),
                    child: new IconTheme(
                      data: new IconThemeData(size: 35, color: Colors.black),
                      child: new Icon(Icons.menu_rounded),
                    ),
                  ),

                  Text(
                      "         זיהוי מחשבות",
                      //textAlign: TextAlign.center,
                      style: GoogleFonts.assistant(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                ],
              ),
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
                        shape: BoxShape.circle,
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
                    width: width * 0.78,
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "בואי נזהה מחשבות מכשילות!",
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
                          "בחרי ב-3 בלוני מחשבה אותם תרצי לאתגר.\n\nאתגור המחשבה יסיע להרגיע  את החרדה בכדי שתצליחי לבצע את החשיפה בהצלחה.",
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
                ],
              ),
              Flexible(
                child: Consumer<ExpoData>(
                  builder: (context, data, child) {

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        double w = constraints.maxWidth;
                        double h = constraints.maxHeight;
                        List<Offset> offsets = [
                          Offset(w * 0.06, h * 0.2),
                          Offset(w * 0.05, h * 0.61),
                          Offset(w * 0.4, h * 0.6),
                          Offset(w * 0.4, h * 0.1),
                          Offset(w * 0.75, h * 0.4),
                          Offset(w * 0.7, h * 0)
                        ];
                        List<double> diameters = [100, 120, 110, 140, 100, 110];
                        List<double> angles = [
                          0.1,
                          0.2,
                          -0.2,
                          -0.1,
                          -0.12,
                          0.1
                        ];
                        List<Widget> wlist = [];
                        for (int i = 0; i < min(6, data.thoughts.length); i++) {
                          wlist.add(Positioned(
                              top: offsets[i].dy,
                              left: offsets[i].dx,
                              child: GestureDetector(
                                child: Baloon(
                                  chosen: chosen.contains(i),
                                  id: i,
                                  angle: angles[i],
                                  diameter: diameters[i],
                                  text: data.thoughts[i],
                                  secondery: data.replies[i],
                                  color: i % 4,
                                ),
                                onTap: () async {
                                  if (chosen.contains(i))
                                    setState(() {
                                      chosen.remove(i);
                                    });
                                  else {
                                    var x = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => _BallonPage(
                                                color: i,
                                                text: data.thoughts[i],
                                                secondery: data.replies[i],
                                              )),
                                    );
                                    setState(() {
                                      data.replies[i] = x;
                                      chosen.insert(chosen.length, i);
                                    });
                                    print(chosen);
                                  }
                                },
                              )));
                        }
                        return Stack(
                          children: List.from(wlist)
                            ..addAll([
                              if (chosen.isNotEmpty)
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      width: 64,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(36),
                                        color: Color(0xffb9b8b8),
                                      ),
                                      padding: const EdgeInsets.only(
                                        top: 7,
                                        bottom: 8,
                                      ),
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Center(
                                        child: Text(
                                          chosen.length.toString() + "/3",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: "Assistant",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )),
                                ),
                              if (chosen.length == 3)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Color(0xff35258a),
                                            shape: CircleBorder(),
                                          ),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            // Provider.of<ExpoData>(context,
                                            //         listen: false)
                                            //     .replies = replies;
                                            _save(data);
                                            Navigator.pushNamed(
                                                context, '/thoughts/2',
                                                arguments: chosen);

                                            // Navigator.pop(context,_controller?.text.trim());
                                          },
                                        ),
                                        margin: EdgeInsets.all(12),
                                      ),
                                    ],
                                  ),
                                )
                            ]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  void _save(data) async {
    String? pid = AuthRepository.instance().user?.uid;
    await FirebaseFirestore.instance.collection("balloons").doc(pid).set({
      'chosen': chosen,'replies':data.replies,'thoughts':data.thoughts
    });
  }
}

class thought2_1 extends StatefulWidget {
  @override
  _thought2_state createState() => _thought2_state();
}

class _thought2_state extends State<thought2_1> {
  List<int> chosen = [];

  Future<AvatarData>? _adata;
  Future<String>? _name;
  @override
  void initState() {
    super.initState();
    _adata = AvatarData.load();
    _name = _getname();
  }

  Future<String> _getname() async {
    var name = (await FirebaseFirestore.instance
        .collection("users")
        .doc(AuthRepository.instance().user?.uid)
        .get())['name'];
    print(name);
    return name;
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
  /**/

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    chosen = ModalRoute.of(context)!.settings.arguments as List<int>;
    print(width);
    return Scaffold(key: scaffoldKey,
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Stack(children: [
                Stack(
                  children: [
                    Positioned(
                        child: Image.asset('images/talky.png'),
                        top: 0,
                        right: 0),
                    Positioned(
                        top: 10,
                        right: 6,
                        child: FutureBuilder<String>(
                          future: _name,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            // ...
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              String data = snapshot.data ?? '';
                              return Text(
                                'היי $data\n מה קורה?',
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.assistant(),
                              );
                            }
                            return CircularProgressIndicator();
                          },
                        )),
                  ],
                ),
                Positioned(
                    child: FutureBuilder<AvatarData>(
                      future: _adata,
                      builder: (BuildContext context,
                          AsyncSnapshot<AvatarData> snapshot) {
                        // ...
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AvatarStack(
                              data: (snapshot.data ??
                                  AvatarData(body: AvatarData.body_default)));
                        }
                        return CircularProgressIndicator();
                      },
                    )),
              ])),
          ListTile(
            title: Text("עצב דמות",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Avatar(first: false, data: _adata)));
            },
          ),
          ListTile(
            title: Text("מפת דרכים",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {
              Future<void> _signOut() async {
                await FirebaseAuth.instance.signOut();
              }

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Home()));
            },
          ),ListTile(
            title: Text("שאלון יומי",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {
              Future<void> _signOut() async {
                await FirebaseAuth.instance.signOut();
              }

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      MyQuestions()));
            },
          ),
          ListTile(
            title: Text("התנתק",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {
              Future<void> _signOut() async {
                await FirebaseAuth.instance.signOut();
              }

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Login()));
            },
          ),
        ]),
      ),
      body: Stack(
        children: [
          Positioned(top:-150,child:
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
      )), TweenAnimationBuilder(
              tween: Tween(begin: height, end: - width*1.7),
              duration: Duration(seconds: 10),
              builder: (context,double h,w){
                Provider.of<ExpoData>(context, listen: false).done[2]=true;
                Future.delayed(const Duration(seconds: 10), (){ Navigator.popUntil(context,ModalRoute.withName('/main'));});
                return Positioned(
                    child: Builder(
                      builder: (context){
                        height = width * 1.7;
                        return Container(
                          width: width,
                          height: height,
                          child: Consumer<ExpoData>(builder: (context, data, child) {
                            AvatarData x= data.adata.clone();
                            x.hands = 'images/handsbaloon.png';
                            return Stack(
                              children: [
                                Positioned(
                                  top: height*0.2,
                                  left: width*0.21,
                                  child: Container(
                                    width: width*0.5,
                                    height: height*0.5,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Image.asset('images/strings.png'),
                                    ),
                                  )
                                ),

                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    child: Transform.rotate(
                                        angle: -0.2 ,
                                        child: Container(
                                            height: width * 0.58,
                                            width: width * 0.6,
                                            child: AvatarStack(
                                              data: x,
                                            )
                                        )),
                                    margin: EdgeInsets.only(left: width*0.08),
                                  ),
                                ),
                                Positioned(
                                  child: Baloon(color:chosen[0], diameter: width*0.316, angle: -0.3, text: data.thoughts[chosen[0]],secondery: data.replies[chosen[0]],),
                                  top: height*0.23,
                                  left: width*0.11,),
                                Positioned(
                                  child: Baloon(color:chosen[1], diameter: width*0.316, angle: 0.3, text: data.thoughts[chosen[1]],secondery: data.replies[chosen[1]],),
                                  top: height*0.17,
                                  right: width*0.19,),
                                Positioned(
                                  child: Baloon(color:chosen[2], diameter: width*0.34, angle: 0, text: data.thoughts[chosen[2]],secondery: data.replies[chosen[2]],),
                                  top: height*0,
                                  left: width*0.3,),

                              ],
                            );
                          }),
                        );
                      },
                    ),
                    top: h
                );
              }
          ),  Positioned(child:Container(

            padding: EdgeInsets.all(5),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Image.asset('images/expo/brain.png',
                  color: Color(0xffB3E8EF)),
            ),
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff35258A),
            ),
          ),
              top:height*0.132,
              right:width*0.08
          ),


          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 50,
              child: Column(
                children: [
                  FloatingActionButton(
                    elevation: 0,
                    disabledElevation: 0,
                    backgroundColor: Colors.grey.shade400,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_forward),
                  ),
                  Container(
                    height: 10,
                  ),

                ],
              ),
              margin: EdgeInsets.all(30),
            ),
          ),
          Positioned(left: -width*0.07,top:height*0.005,child:
            Container(
              child:FlatButton(
                color: Colors.transparent,
                onPressed:  () => scaffoldKey.currentState!.openDrawer(),
                child: new IconTheme(
                  data: new IconThemeData(size: 35, color: Colors.black),
                  child: new Icon(Icons.menu_rounded),
                ),
              ),
              margin: EdgeInsets.all(30),

          )),
          Column(
            children: [
              Container(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "זיהוי מחשבות",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.assistant(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}

class _BallonPage extends StatefulWidget {
  _BallonPage(
      {required this.text, required this.color, required this.secondery});
  final int color;
  final String text;
  final String secondery;
  @override
  _ballonState createState() => _ballonState();
}

class _ballonState extends State<_BallonPage> {
  TextEditingController? _controller;
  double height = 0, width = 0;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.secondery);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (width == 0) width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(width: 20),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xff35258a),
                shape: CircleBorder(),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, _controller?.text.trim());
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                Positioned(
                    bottom: height * 0.8,
                    right: width * 0.8,
                    child: Baloon(
                      id: 1,
                      angle: 0,
                      diameter: width * 0.5,
                      color: 1,
                      text: '',
                    )),
                Positioned(
                    bottom: height * 0.8,
                    left: width * 0.7,
                    child: Baloon(
                      id: 1,
                      angle: 0.1,
                      diameter: width * 0.6,
                      color: 3,
                      text: '',
                    )),
                Positioned(
                    top: height * 0.6,
                    left: width * 0.7,
                    child: Baloon(
                      id: 1,
                      angle: 0,
                      diameter: width * 0.8,
                      color: 2,
                      text: '',
                    )),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      padding: EdgeInsets.only(top: height * 0.1),
                      child: Baloon(
                        id: 1,
                        angle: 0,
                        diameter: width * 0.95,
                        color: widget.color,
                        text: '',
                      )),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.2),
                    width: width * 0.7,
                    height: width * 0.7,
                    child: Column(children: [
                      Text(
                        widget.text + "...",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xff35258a),
                          fontSize: 26,
                          fontFamily: "Assistant",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: "Assistant",
                          fontWeight: FontWeight.w300,
                        ),
                        textDirection: TextDirection.rtl,
                        controller: _controller,
                        maxLines: 4,
                      )
                    ]),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class Baloon extends StatelessWidget {
  Baloon({
    required this.color,
    required this.diameter,
    required this.angle,
    required this.text,
     this.id,
    this.secondery = '',
    this.chosen = false,
  });
  final bool chosen;
  final int? id;
  final String? secondery;
  final String text;
  final double diameter;
  final double angle;
  final int color;
  final colors = [
    Color(0xffDEEEF3),
    Color(0xffDEEEF3),
    Color(0xffCFC781),
    Color(0xff81CF8D),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      child: Stack(
        children: [
          if (chosen)
            Container(
              width: diameter,
              height: diameter * 0.95,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue)),
            ),
          Container(
            width: diameter,
            height: diameter*0.93,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[color % 4],
            ),
          ),
          Transform.rotate(
            angle: angle,
            child: ImageColorSwitcher(
              height: diameter,
              width: diameter,
              imagePath: 'images/expo/baloon.png',
              main: Color(0xff000000),
              second: Color(0xff95DEF4),
              color: colors[color % 4],
            ),
          ),
          Center(
            child: Container(
              width: 0.8 * diameter,
              child: RichText(
                textDirection: TextDirection.rtl,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  children: <TextSpan>[
//
                    TextSpan(
                      text: text.trim() + " ",
                      style: TextStyle(
                        color: Color(0xff35258a),
                        fontSize: 0.1 * diameter,
                        fontFamily: "Assistant",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: secondery,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Assistant",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
    canvas.drawCircle(center, size.width*1.05,painter..color = Color(0xfff3f1de)
      ..style = PaintingStyle.fill );
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width*1.05), 0, pi,
        false, painter..color = Color(0xffc4c4c4)..style = PaintingStyle.stroke);
    double pad = 0.2;
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width*1.05),
        0,
        pi / 2 - pi / 6 + pad,
        false,
        painter..color = Color(0xff35258A)..style = PaintingStyle.stroke);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width*1.05),
        pi / 2 - pi / 6 + pad,
        (2 * pi / 6 - 2 * pad) * percent,
        false,
        painter..color = Color(0xff35258A));

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
