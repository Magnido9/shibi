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
  });
  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    Offset center = Offset(size.width / 2, -size.width * 0.3);
    canvas.drawCircle(center, size.width*1.05,painter..color = Color(0xffEFFBFF)
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

class feeling1_1 extends StatefulWidget {
  feeling1_1();

  @override
  _feeling1_state createState() => _feeling1_state();
}

class _feeling1_state extends State<feeling1_1> {


  double pointer = 0;
  ScrollController _controller = ScrollController(initialScrollOffset: 0);
  @override
  @override

  Color _getColor() {
    double i = pointer;
    double blue_border = 20,
        green_border = 40,
        yellow_border = 60,
        pink_border = 80,
        red_border = 101,
        percent;
    if (i < blue_border) {
      percent = i / blue_border;
      return Color.alphaBlend(Color(0xffA3A2EE).withOpacity(1 - percent),
          Color(0xffA6D6C3).withOpacity(percent));
    }
    if (i < green_border) {
      percent = (i - blue_border) / (green_border - blue_border);
      return Color.alphaBlend(Color(0xffA6D6C3).withOpacity(1 - percent),
          Color(0xffF1B31C).withOpacity(percent));
    }
    if (i < yellow_border) {
      percent = (i - green_border) / (yellow_border - green_border);
      return Color.alphaBlend(Color(0xffF1B31C).withOpacity(1 - percent),
          Color(0xffEFB3E2).withOpacity(percent));
    }
    if (i < pink_border) {
      percent = (i - yellow_border) / (pink_border - yellow_border);
      return Color.alphaBlend(Color(0xffEFB3E2).withOpacity(1 - percent),
          Color(0xffFE615E).withOpacity(percent));
    } else {
      percent = (i - pink_border) / (red_border - pink_border);
      return Color.alphaBlend(Color(0xffFE615E).withOpacity(1 - percent),
          Color(0xffEC015E).withOpacity(percent));
    }
  }

  String _label() {
    double i = pointer;
    double blue_border = 20,
        green_border = 40,
        yellow_border = 60,
        pink_border = 80,
        red_border = 101,
        percent;
    if (i < blue_border) {
      return 'עצב';
    }
    if (i < green_border) {
      return 'גועל';
    }
    if (i < yellow_border) {
      return 'פחד';
    }
    if (i < pink_border) {
      return 'שמחה';
    } else {
      return 'כעס';
    }
  }

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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key:scaffoldKey,
      drawer:Drawer(
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
                  builder: (BuildContext context) => Home()));
            },
          ),
          ListTile(
            title: Text("שאלון יומי",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => MyQuestions()));
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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getColor(),
                Colors.white,
              ],
            )),
        child: Stack(
          children: [

            Positioned(top:-150,child:
            Container(
              child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 0.7),
                  duration: Duration(seconds: 1),
                  builder:
                      (BuildContext context, double percent, Widget? child) {
                    return CustomPaint(
                        painter: _LoadBar(percent: 1.1, size: MediaQuery.of(context).size),
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
                    Container(
                      height: 10,
                    ),



                  ],
                ),
                margin: EdgeInsets.all(30),
              ),
            ),
            Positioned(
              top:100,
              left: 20,
              child:
              Container(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image.asset('images/expo/smile.png',
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
                        "           זיהוי רגש",
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
                      width: width * 0.8,
                      margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "בואו נזהה יחד את הרגשות המוצפים.",
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
                            "בחרי את הרגשות שאת מרגישה כעת",
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
                Container(
                  height: 10,
                ),
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                      height: height * 0.5,
                      width: width * 5.5,
                      // color: Colors.green,
                      child: Consumer<ExpoData>(
                        builder: (context, data, widget){
                          return Builder(builder: (context) {
                            height = height * 0.5;
                            double x = 50,
                                offset = 0,
                                radius = height * 0.125,
                                dis = radius * 0.1;
                            List<Widget> l = [];
                            List<Widget> m = [];
                            var f = (i, j) => _circle(
                                color: _getColor(),
                                text: data.feelings[i * 8 + j],
                                radius: radius,
                                isChosen: data.felt.contains(i * 8 + j),
                                onTap: () {
                                  if (data.felt.contains(i * 8 + j)) {
                                    setState(() {
                                      data.felt.remove(i * 8 + j);

                                    });

                                  } else {
                                    setState(() {
                                      data.felt.add(i * 8 + j);
                                    });

                                  }
                                });

                            // List<double>
                            for (int i = 0;
                            i < (data.feelings.length - data.feelings.length % 8) / 8;
                            i++) {
                              l.addAll([
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [f(i, 0)],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: x * 0),
                                      child: f(i, 1),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: x * 1),
                                        child: f(i, 2)),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(left: x * 0),
                                        child: f(i, 3)),
                                    Container(
                                      margin: EdgeInsets.only(left: x * 1),
                                      child: f(i, 4),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: x * 2),
                                      child: f(i, 5),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: x * 0),
                                      child: f(i, 6),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: x * 1),
                                      child: f(i, 7),
                                    ),
                                  ],
                                ),
                              ]);
                            }
                            for (int i = 0; i < l.length; i++) {
                              m.add(Positioned(
                                child: l[i],
                                left: offset,
                                height: height,
                              ));
                              if (i % 4 == 0) offset += 2 * radius + dis - x / 2;
                              if (i % 4 == 1) offset += 2 * radius + dis - x / 2;
                              if (i % 4 == 2) offset += 2 * radius + dis + x;
                              if (i % 4 == 3) offset += 2 * radius + dis + x;
                            }
                            return Stack(
                              children: m,
                            );
                          });
                        },
                      )),
                ),
                Container(
                  width: 30340304,
                  margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),

                  child: SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Color(0xffFFFFFF).withOpacity(0.8),
                        //thumbColor: Colors.black,
                        activeTrackColor: _getColor(),


                      ),


                      child: Slider(
                        //activeColor: _getColor(),
                        //thumbColor: Colors.grey,
                        value: pointer,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: _label(),
                        onChanged: (double value) {
                          setState(() {
                            pointer = value;
                            _controller.jumpTo(value / 100 * width * 4.5);
                          });
                        },
                      )),),
              ],
            ),
            if (Provider.of<ExpoData>(context, listen: false).felt.length >= 3)
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
                          Provider.of<ExpoData>(context, listen: false).done[1]=true;
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
      ),
    );
  }
}

class _circle extends StatelessWidget {
  _circle(
      {required this.color,
        this.text = "",
        required this.radius,
        this.onTap,
        this.isChosen = false});
  final double radius;
  final String text;
  final Color color;
  final isChosen;
  var onTap;
  @override
  Widget build(BuildContext context) {
    onTap = onTap ?? () {};
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(radius * 0.2),
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
            border: (isChosen && text != '')
                ? Border.all(color: Colors.black, width: 1)
                : null,
            color: (text == '') ? null : color,
            shape: BoxShape.circle),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: "Assistant",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      onTap: (text == '') ? () {} : onTap,
    );
  }
}
