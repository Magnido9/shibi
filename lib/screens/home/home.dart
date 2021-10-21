library home;

import 'dart:async';
import 'dart:math';

import 'package:application/screens/Avatar/give_money.dart';
import 'package:application/screens/home/personal_diary.dart';
import 'package:application/screens/home/psycho.dart';
import 'package:application/screens/home/stars.dart';
import 'package:application/screens/home/stars_explanation.dart';
import 'package:application/screens/map/map.dart';
import 'package:application/screens/map/meditation.dart';
import 'package:application/screens/map/questioneer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Avatar/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../login/login.dart';
import '../../services/auth_services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static Future<String> loadMoney() async {
    String? pid = AuthRepository.instance().user?.uid;
    var v =
        (await FirebaseFirestore.instance.collection("avatars").doc(pid).get());
    var a = v['money'];
    var s = a.toString();
    return s;
  }

  Future<AvatarData>? _adata;
  Future<String>? _name;
  var moneyd;
  @override
  void initState() {
    super.initState();
    _adata = AvatarData.load();
    _name = _getname();
    moneyd = loadMoney();
    reset();
  }

  Future<String> _getname() async {
    var name = (await FirebaseFirestore.instance
        .collection("users")
        .doc(AuthRepository.instance().user?.uid)
        .get())['name'];
    return name;
  }

  static const countdownDuration = Duration(seconds: 4);
  Duration duration = Duration();
  Timer? timer;
  int medistage = 0;
  String medi = "תלחצו על הכפתור כדי להתחיל במדיטציה";
  bool countDown = true;

  int page_index = 0;
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        medistage += 1;
        if (medistage == 1) {
          medi = "בוא נתחיל בשאיפה דרך האף";
          duration = Duration(seconds: 4);
        } else if (medistage == 2) {
          medi = "ועכשיו להחזיק את האוויר בריאות";
          duration = Duration(seconds: 6);
        } else if (medistage == 3) {
          medi = "ועכשיו לנשוף!";
          duration = Duration(seconds: 8);
        } else {
          timer?.cancel();
          medistage = 0;
          medi = "בוא נתחיל בשאיפה דרך האף";
          startTimer();
        }
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    medi = "לחצו על הכפתור להתחלת תרגילי נשימה";
    medistage = 0;
    setState(() => timer?.cancel());
  }

  Widget medBody() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Stack(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  medi,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.assistant(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 10,
                ),
                buildTime(),
                buildButtons(),
                SizedBox(
                  height: 10,
                ),
                Image.asset("images/meditate9.png")
              ],
            ),
          ),
        ]));
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: seconds, header: ''),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Text(header, style: TextStyle(color: Colors.black45)),
        ],
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 12,
              ),
              Stack(children: [
                Container(
                    width: 200,
                    height: 39,
                    child: MaterialButton(
                        onPressed: () {
                          stopTimer();
                        },
                        minWidth: 200,
                        height: 39,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36)),
                        color: Color(0xff35258a),
                        child: Stack(children: <Widget>[
                          Positioned(
                            top: 5,
                            right: 50,
                            child: Text(
                              "הפסק!",
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
              ]),
            ],
          )
        : Stack(children: [
            Container(
                width: 200,
                height: 39,
                child: MaterialButton(
                    onPressed: () {
                      medistage = 1;
                      medi = "בוא נתחיל בשאיפה דרך האף";
                      startTimer();
                    },
                    minWidth: 200,
                    height: 39,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36)),
                    color: Color(0xff35258a),
                    child: Stack(children: <Widget>[
                      Positioned(
                        top: 5,
                        right: 30,
                        child: Text(
                          "בואו נתחיל!",
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
          ]);
  }

  Widget homeBody(size, _name) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
        height: height * 0.7,
        width: width,
        child: Stack(
          children: [
            Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 50, 5),
                    child: nameIt(_name, Colors.white))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 50, 5),
                    child: Text(
                      'כוכבי הלכת יעזרו לכם להבין טוב יותר את החרדה,\n ולהבין באיזה כלים אתם בדרך כלל משתמשים, \nעל מנת שתוכלו להחזיק ולהשלים את ארגז הכלים שלכם ',
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.assistant(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ))
              ]),
              // width:MediaQuery.of(context).size.width,
            ]),
            Positioned(
              right: 20,
              top: height * 0.25,
              child: GestureDetector(
                child: Container(
                    height: 200,
                    width: 200,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 5,
                            child: Container(
                              width: 165,
                              height: 165,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x0c000000),
                                    blurRadius: 18,
                                    offset: Offset(0, -2),
                                  ),
                                ],
                                color: Color(0xfffaf5c6),
                              ),
                            )),
                        Image.asset('images/Yellow_Star.png'),
                        Positioned(
                            child: Text(
                              'מחשבות',
                              style: GoogleFonts.assistant(),
                            ),
                            right: 85,
                            top: 70),
                      ],
                    )),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => Stars(cur_star: 3)));
                },
              ),
            ),
            Positioned(
                left: 70,
                top: MediaQuery.of(context).size.height * 0.3,
                child: GestureDetector(
                    child: Stack(
                      children: [
                        Positioned(
                            left: 5,
                            child: Container(
                              width: 98,
                              height: 98,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x0c000000),
                                    blurRadius: 18,
                                    offset: Offset(0, -2),
                                  ),
                                ],
                                color: Color(0xffa9e1f4),
                              ),
                            )),
                        Image.asset('images/Blue_Star.png'),
                        Positioned(
                            child: Text(
                              'רגש',
                              style: GoogleFonts.assistant(),
                            ),
                            right: 43,
                            top: 35),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Stars(cur_star: 2)));
                    })),
            Positioned(
                left: 5,
                top: height * 0.45,
                child: GestureDetector(
                    child: Container(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            Positioned(
                                left: 7,
                                top: 7,
                                child: Container(
                                  width: 74,
                                  height: 74,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x0c000000),
                                        blurRadius: 18,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                    color: Color(0xffefb3e2),
                                  ),
                                )),
                            Image.asset('images/Pink_Star.png'),
                            Positioned(
                                child: Text(
                                  'התנהגות',
                                  style: GoogleFonts.assistant(),
                                ),
                                right: 28,
                                top: 32),
                          ],
                        )),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Stars(cur_star: 0)));
                    })),
            Positioned(
                right: 150,
                top: height * 0.50,
                child: GestureDetector(
                    child: Container(
                        height: 150,
                        width: 150,
                        child: Stack(
                          children: [
                            Positioned(
                                left: 3,
                                top: -1,
                                child: Container(
                                  width: 132,
                                  height: 132,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x0c000000),
                                        blurRadius: 18,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                    color: Color(0xffc7f5e0),
                                  ),
                                )),
                            Image.asset('images/Green_Star.png'),
                            Positioned(
                                child: Text(
                                  'גוף',
                                  style: GoogleFonts.assistant(),
                                ),
                                right: 75,
                                top: 55),
                          ],
                        )),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Stars(cur_star: 1)));
                    })) /*Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  // color: Colors.green,
                  height: 500),
              Container(
                  // color: Colors.green,
                  width: size.width * 0.5,
                  height: size.height,
                  child: FutureBuilder<AvatarData>(
                    future: _adata,
                    builder: (BuildContext context,
                        AsyncSnapshot<AvatarData> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var data = snapshot.data ??
                            AvatarData(body: AvatarData.body_default);
                        return AvatarStack(data: data);
                      }
                      return CircularProgressIndicator();
                    },
                  )),
            ])
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                width: 100,
                height: 100,
                child: _TaskIcon(
                  daily: true,
                  text: 'test',
                  slices: 5,
                  complete: 3,
                ),
              ),
            ),
         */
          ],
        ));
  }

  Widget diaryBody() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextEditingController? _controller = TextEditingController(text: "");
    return Stack(children: <Widget>[
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
                  shape: BoxShape.circle, //3
                  color: Color(0xffc4c4c4),
                ),
              ),
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: AlertDialog(
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
                                  'זה היומן האישי שלכם, כל מה שתכתבו כאן אישי לכם ואף אדם אחר לא יוכל לראות אותו.\n'),
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
                  ),
                ),
              ),
            ),
            Container(width: 30),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "היומן האישי שלך",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.assistant(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Text(
                    "אתם יכולים לכתוב כאן כל מה שעל ליבכם",
                    textAlign: TextAlign.right,
                    style: GoogleFonts.assistant(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Container(width: 20),
          ]),
      Column(
        children: [
          Container(height: 70),
          Container(
            width: 370,
            height: height * 0.6,
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
            child: Stack(children: [
              Column(
                children: [
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
                ],
              ),
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
                      hintText: '',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    textDirection: TextDirection.rtl,
                    controller: _controller,
                    maxLines: 11,
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
          )
        ],
      )
    ]);
  }

  Widget psychoBody(_name) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
        height: height * 0.7,
        width: width,
        child: Stack(
          children: [
            Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 50, 5),
                    child: nameIt(_name, Colors.white))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 50, 5),
                    child: Text(
                      'כוכבי הלכת האלו מכילים הסברים על החרדה שלכם ',
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.assistant(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ))
              ]),
              // width:MediaQuery.of(context).size.width,
            ]),
            Positioned(
              right: 20,
              top: height * 0.45,
              child: GestureDetector(
                child: Container(
                    height: 200,
                    width: 200,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 5,
                            child: Container(
                              width: 165,
                              height: 165,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x0c000000),
                                    blurRadius: 18,
                                    offset: Offset(0, -2),
                                  ),
                                ],
                                color: Color(0xfffaf5c6),
                              ),
                            )),
                        Image.asset('images/Yellow_Star.png'),
                        Positioned(
                            child: Text(
                              'מחשבות',
                              style: GoogleFonts.assistant(),
                            ),
                            right: 85,
                            top: 70),
                      ],
                    )),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          StarsExp(cur_star: 3)));
                },
              ),
            ),
            Positioned(
                right: 120,
                top: MediaQuery.of(context).size.height * 0.25,
                child: GestureDetector(
                    child: Stack(
                      children: [
                        Positioned(
                            left: 5,
                            child: Container(
                              width: 98,
                              height: 98,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x0c000000),
                                    blurRadius: 18,
                                    offset: Offset(0, -2),
                                  ),
                                ],
                                color: Color(0xffa9e1f4),
                              ),
                            )),
                        Image.asset('images/Blue_Star.png'),
                        Positioned(
                            child: Text(
                              'רגש',
                              style: GoogleFonts.assistant(),
                            ),
                            right: 43,
                            top: 35),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StarsExp(cur_star: 2)));
                    })),
            Positioned(
                left: 25,
                top: height * 0.25,
                child: GestureDetector(
                    child: Container(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            Positioned(
                                left: 7,
                                top: 7,
                                child: Container(
                                  width: 74,
                                  height: 74,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x0c000000),
                                        blurRadius: 18,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                    color: Color(0xffefb3e2),
                                  ),
                                )),
                            Image.asset('images/Pink_Star.png'),
                            Positioned(
                                child: Text(
                                  'התנהגות',
                                  style: GoogleFonts.assistant(),
                                ),
                                right: 28,
                                top: 32),
                          ],
                        )),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StarsExp(cur_star: 0)));
                    })),
            Positioned(
                left: 50,
                top: height * 0.4,
                child: GestureDetector(
                    child: Container(
                        height: 150,
                        width: 150,
                        child: Stack(
                          children: [
                            Positioned(
                                left: 3,
                                top: -1,
                                child: Container(
                                  width: 132,
                                  height: 132,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x0c000000),
                                        blurRadius: 18,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                    color: Color(0xffc7f5e0),
                                  ),
                                )),
                            Image.asset('images/Green_Star.png'),
                            Positioned(
                                child: Text(
                                  'גוף',
                                  style: GoogleFonts.assistant(),
                                ),
                                right: 75,
                                top: 55),
                          ],
                        )),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StarsExp(cur_star: 1)));
                    })) /*Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  // color: Colors.green,
                  height: 500),
              Container(
                  // color: Colors.green,
                  width: size.width * 0.5,
                  height: size.height,
                  child: FutureBuilder<AvatarData>(
                    future: _adata,
                    builder: (BuildContext context,
                        AsyncSnapshot<AvatarData> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var data = snapshot.data ??
                            AvatarData(body: AvatarData.body_default);
                        return AvatarStack(data: data);
                      }
                      return CircularProgressIndicator();
                    },
                  )),
            ])
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                width: 100,
                height: 100,
                child: _TaskIcon(
                  daily: true,
                  text: 'test',
                  slices: 5,
                  complete: 3,
                ),
              ),
            ),
         */
          ],
        ));
  }

  buildAppBar() {
    return AppBar(
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: 25.0),
          child: Text(
            "מפת דרכים",
            //textAlign: TextAlign.center,
            style: GoogleFonts.assistant(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: Color(0xb2ffffff),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: Builder(
            builder: (context) => GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 15.0),
                      child: Icon(
                        Icons.menu_rounded,
                        size: 50,
                      )),
                )),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 25.0),
              child: GestureDetector(
                onTap: () {},
                child: FutureBuilder<String>(
                  future: moneyd,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    // ...
                    if (snapshot.connectionState == ConnectionState.done) {
                      String data = snapshot.data ?? '';
                      return build_money(data);
                    }
                    return CircularProgressIndicator();
                  },
                ),
              )),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    var x = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    var size = Size(x, 0.7 * x);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title: Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                "מפת דרכים",
                //textAlign: TextAlign.center,
                style: GoogleFonts.assistant(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            backgroundColor: Color(0xb2ffffff),
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            leading: Builder(
                builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 15.0),
                          child: Icon(
                            Icons.menu_rounded,
                            size: 50,
                          )),
                    )),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0, top: 25.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: FutureBuilder<String>(
                      future: moneyd,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        // ...
                        if (snapshot.connectionState == ConnectionState.done) {
                          String data = snapshot.data ?? '';
                          return build_money(data);
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  )),
            ]),
        backgroundColor: Colors.deepPurple,
        body: Stack(
          children: [
            Positioned(
              left: -((1 * MediaQuery.of(context).size.height) -
                      MediaQuery.of(context).size.width) /
                  2,
              top: -0.91 * MediaQuery.of(context).size.height,
              child: Container(
                  width: 1 * MediaQuery.of(context).size.height,
                  height: 1 * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(
                        0xb2ffffff,
                      ))),
            ),
            Column(children: [
              Container(
                height: 80,
              ),
              (page_index == 0
                  ? homeBody(size, _name)
                  : page_index == 1
                      ? diaryBody()
                      : page_index == 2
                          ? psychoBody(_name)
                          : page_index == 3
                              ? medBody()
                              : homeBody(size, _name))
            ])
          ],
        ),
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
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xb2ffffff),
            currentIndex: page_index,
            onTap: (int page) {
              setState(() {
                page_index = page;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (page_index != 0)
                        ? Color(0xff9e7fe0)
                        : Color(0xff35258a),
                  ),
                  child: Image.asset('images/thumbsup.png'),
                ),
                label: 'מפת דרכים',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (page_index != 1)
                        ? Color(0xff9e7fe0)
                        : Color(0xff35258a),
                  ),
                  child: Image.asset('images/cloud.png'),
                ),
                label: 'יומן',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (page_index != 2)
                        ? Color(0xff9e7fe0)
                        : Color(0xff35258a),
                  ),
                  child: Image.asset('images/smiley.png'),
                ),
                label: 'פסיכוחינוך',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (page_index != 3)
                        ? Color(0xff9e7fe0)
                        : Color(0xff35258a),
                  ),
                  child: Image.asset('images/human.png'),
                ),
                label: 'תרגילים',
              ),
            ]));
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
      ..color = Colors.lightGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    Offset center = Offset(size.width / 2, -size.width * 0.3);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width), 0, pi,
        false, painter);
    double pad = 0.1;
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width),
        pi / 2 - pi / 6 + pad,
        (2 * pi / 6 - 2 * pad) * percent,
        false,
        painter..color = Colors.deepPurple);

    Offset off1 = center +
        Offset(-sin(pi / 6 - pad) * size.width, cos(pi / 6 - pad) * size.width);
    painter
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.drawCircle(off1, size.width * 0.04, painter);
    canvas.drawCircle(off1, size.width * 0.03, painter..color = Colors.white);

    Offset off2 = center +
        Offset(sin(pi / 6 - pad) * size.width, cos(pi / 6 - pad) * size.width);
    painter
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.drawCircle(off2, size.width * 0.04, painter);
    canvas.drawCircle(off2, size.width * 0.03, painter..color = Colors.white);
  }

  @override
  bool shouldRepaint(_LoadBar oldDelegate) {
    return percent != oldDelegate.percent;
  }
}

class _TaskIcon extends StatelessWidget {
  _TaskIcon(
      {this.text,
      this.surprise = false,
      this.daily = false,
      required this.slices,
      required this.complete});

  final String? text;
  final bool surprise, daily;
  final int slices, complete;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          Container(
            height: 0.7 * min(constraints.maxWidth, constraints.maxHeight),
            width: 0.7 * min(constraints.maxWidth, constraints.maxHeight),
            child: Stack(children: [
              CustomPaint(
                size: Size.square(
                    0.7 * min(constraints.maxWidth, constraints.maxHeight)),
                painter: _PaintTask(slices: slices, complete: complete),
              ),
              Center(
                child: Container(
                  height: 0.5 * constraints.maxHeight,
                  width: 0.5 * constraints.maxWidth,
                  child: Center(
                    child: Text(
                      (surprise)
                          ? '?'
                          : ((daily)
                              ? date.day.toString() +
                                  '/' +
                                  (date.month.toString())
                              : ""),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ]),
          ),
          if (daily) Text('עדכון יומי'),
          if (surprise) Text('הפתעה'),
          if (text != null && !daily && !surprise) Text((text ?? ''))
        ],
      );
    });
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

Widget nameIt(Future<String> _name, color) {
  return FutureBuilder<String>(
    future: _name,
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      // ...
      if (snapshot.connectionState == ConnectionState.done) {
        String data = snapshot.data ?? '';
        return Text(
          'היי $data,',
          textDirection: TextDirection.rtl,
          style: GoogleFonts.assistant(
              fontSize: 24, fontWeight: FontWeight.w800, color: color),
        );
      }
      return CircularProgressIndicator();
    },
  );
}

Widget build_money(String text) {
  return Stack(children: [
    Image.asset('images/coin.png'),
    Positioned(
      top: 8,
      left: 7,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.assistant(
          height: 0.65,
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    ),
  ]);
}
