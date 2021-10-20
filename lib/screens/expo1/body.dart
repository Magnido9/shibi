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
import 'dart:ui';

class _LoadBar extends CustomPainter {
  final double percent;
  final Size size;

  _LoadBar({
    required this.percent,
    required this.size,
  });//1
  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    Offset center = Offset(size.width / 2, -size.width * 0.3);
    canvas.drawCircle(center, size.width*1.05,painter..color = Color(0xffDEF3DF)
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


class body1_1 extends StatefulWidget {

  @override
  _body1_state createState() => _body1_state();
}

class _body1_state extends State<body1_1> {
  bool isBack= false;

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
                      painter: _LoadBar(percent: 0.5, size: MediaQuery.of(context).size),
                      size: MediaQuery.of(context).size);
                }),
            // color:Colors.green
          )),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 50,
              child: Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.grey.shade400,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_forward),
                  ),

                ],
              ),
              margin: EdgeInsets.all(30),
            ),
          ),
          Positioned(
            top:140,
            left: 190,
            child:
            Container(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Image.asset('images/expo/meditate.png',
                    color: Color(0xffB3E8EF)),
              ),
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff35258A),
              ),
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "         זיהוי הגוף",
                      //textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: "Assistant",
                        fontWeight: FontWeight.w700,
                      ),
                    ),),

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
                                        'בחרו את האזורים בגוף בהם אתם מרגישים כאב.\n'),

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
                    width: width * 0.8,
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "היכן אתם מרגישים כאב?",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "Assistant",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          "סובבו את שיבי וסמנו את המקומות בהם אתם מרגישים כאב.",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
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
                    AvatarData x = data.adata.clone();
                    x.hands = 'images/handsdown.png';
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        double w = constraints.maxWidth;
                        double h = constraints.maxHeight;
                        print(h);
                        print(w);
                        double dx = min(w,h), radius = dx*0.02;
                        var f = (str)=> _circle(isSelected: (data.painSpots.contains(str)),width: radius*2,onTap: (){ setState(() {data.painSpots.add(str);}); }, );
                        List<Widget> widgets = [
                          Positioned( top:dx*0.4 , left: dx*0.5-radius, child: f('בטן')),
                          Positioned( top:dx*0.24 , left: dx*0.5-radius, child: f('סנטר')),
                          Positioned( top:dx*0.1 , left: dx*0.5-radius, child: f('ראש')),
                          Positioned( top:dx*0.29 , left: dx*0.38-radius, child: f('חזה')),
                          Positioned( top:dx*0.29 , left: dx*0.62-radius, child: f('לב')),
                          Positioned( top:dx*0.31 , left: dx*0.7-radius, child: f('כתף')),
                          Positioned( top:dx*0.31 , left: dx*0.3-radius, child: f('כתף')),
                          Positioned( top:dx*0.38 , left: dx*0.28-radius, child: f('יד')),
                          Positioned( top:dx*0.38 , left: dx*0.72-radius, child: f('יד')),
                          Positioned( top:dx*0.6 , left: dx*0.43-radius, child: f('רגל')),
                          Positioned( top:dx*0.6 , left: dx*0.57-radius, child: f('רגל')),







                        ];
                        return Container(
                          width: dx,
                          height: dx,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  child: Container(
                                    height: w*0.3,
                                    width: w,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Image.asset('images/platform.png'),
                                    ),
                                  ),
                                  onTap: (){
                                    return setState(() {
                                      isBack = !isBack;
                                    });
                                  },
                                ),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child:Container(
                                    margin: EdgeInsets.only(bottom:dx*0.2),
                                    child:  AvatarStack(data: x),
                                  )
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: w*0.2,
                                  child: ListView.builder(
                                    itemCount: data.painSpots.length,
                                    itemBuilder: (BuildContext context, int index){
                                      return GestureDetector(
                                        onTap: (){setState(() {
                                          data.painSpots.remove(data.painSpots[index]);
                                        });},
                                        child:  Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                              Icon(Icons.remove, color:Color(0xff35258a)),
                                              Text(
                                                data.painSpots[index],
                                                textDirection: TextDirection.rtl  ,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),)],),
                                            height: 31,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Color(0xffebebeb),
                                            )),
                                      );
                                    },
                                  ),
                                )
                              )
                            ]..addAll(widgets),

                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
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
                      Provider.of<ExpoData>(context, listen: false).done[0]=true;
                      Navigator.popUntil(
                          context, ModalRoute.withName('/main'));
                    },
                  ),
                  margin: EdgeInsets.all(8),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _circle extends StatelessWidget{
  _circle({required this.width,required this.isSelected,required this.onTap, });
  double width;
  bool isSelected;
  var onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(isSelected)? (){} : onTap,
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
            border: Border.all(
                color: Color(0xff35258A)
            ),
            shape: BoxShape.circle,
            color: (isSelected)? Color(0xffEDE74C) : Color(0xffC4C4C4)
        ),
      ),
    );
  }
}
