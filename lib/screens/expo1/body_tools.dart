library expo;
import 'package:application/screens/home/home.dart';
import 'package:application/screens/login/login.dart';
import 'package:application/screens/map/questioneer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
import 'ToolsChoosing.dart';
import 'body.dart';
import 'feelings.dart';
import 'thoughts.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:async';

class BodyTools extends StatelessWidget {
  BodyTools({required this.adata, required this.theCase,required this.prev});
  final int prev;
  final AvatarData adata;
  final String theCase;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Provider(
      create: (context) => ExpoData(adata: adata, theCase: theCase, body_task: 0, feelings_task: 0, thoughts_task: 0),
      child: MaterialApp(
        title: 'חשיפה 1',
        // Start the app with the "/" named route. In this case, the app starts
        // on the FirstScreen widget.
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => _Page1(prev:prev,adata:adata,theCase:theCase),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/second': (context) => _Page2(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/3': (context) => _Page3(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/4': (context) => _Page4(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/5': (context) => _Page5(),
          '/main': (context) => _Main(),
          '/thoughts/1': (context) => thought1_1(),
          '/thoughts/2': (context) => thought2_1(),
          '/feelings/1': (context) => feeling1_1(),
          '/body/1' : (context) => body1_1() ,
          '/tools': (context) => tools(theCase: theCase,adata: adata),
        },
      ),)
    );
  }
}

class _Page1 extends StatefulWidget {
  _Page1({required this.adata, required this.theCase,required this.prev});
  final int prev;
  final AvatarData adata;
  final String theCase;
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<_Page1> {

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
          child: FloatingActionButton(
            elevation: 0,
            disabledElevation: 0,
            backgroundColor: Colors.grey.shade400,
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                     this.widget.prev==0?Home():tools(adata:this.widget.adata, theCase:this.widget.theCase)));
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
                  onPressed:  () => scaffoldKey.currentState!.openDrawer(),
                  child: new IconTheme(
                    data: new IconThemeData(size: 35, color: Colors.black),
                    child: new Icon(Icons.menu_rounded),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "           הרפיית גוף",
                    //textAlign: TextAlign.center,
                    style: GoogleFonts.assistant(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),),

              ],
            )
    ]),
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
      Positioned(
          right:10,
          left:10,
          top:height*0.25,child: Row(
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
                  width:40
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "בחרו בהרפיה אותה תרצו לבצע",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.assistant(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                  width:20
              ),
            ],
          )),
          Positioned(
      right:20,
          left:20,
          top:height*0.35,
            child:Container(
          width: 362,
          height: 258,
          child: Stack(
            children:[Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                child:
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/second');
                  },
                    child:Container(
                  width: 173,
                  height: 118,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffe0cbdd),
                  ),
                  padding: const EdgeInsets.only(top: 37, bottom: 32, ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      SizedBox(
                        width: 169,
                        height: 23,
                        child: Text(
                          "הרפיית שרירים",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.assistant(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      SizedBox(
                        width: 173,
                        height: 19,
                        child: Text(
                          "12 דקות",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.assistant(
                          color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child:
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/3');
                    },
                    child:Container(
                    width: 173,
                    height: 118,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xffdeeef3),
                    ),
                    padding: const EdgeInsets.only(top: 67, bottom: 32, ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:[
                        SizedBox(
                          width: 173,
                          height: 19,
                          child: Text(
                            "2 דקות",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.assistant(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child:
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/4');
                    },
                    child:Container(
                    width: 173,
                    height: 118,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0x42cfc780),
                    ),
                    padding: const EdgeInsets.only(top: 39, bottom: 30, ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        SizedBox(
                          width: 169,
                          height: 23,
                          child: Text(
                            "דמיון מודרך",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.assistant(

                            color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        SizedBox(
                          width: 173,
                          height: 19,
                          child: Text(
                            "9 דקות",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.assistant(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child:
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/5');
                    },
                    child:Container(
                    width: 173,
                    height: 118,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0x428f52cc),
                    ),
                    padding: const EdgeInsets.only(top: 67, bottom: 32, ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:[
                        SizedBox(
                          width: 173,
                          height: 19,
                          child: Text(
                            "13 דקות",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.assistant(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              Positioned(
                left: 188,
                top: 37,
                child: SizedBox(
                  width: 174,
                  height: 23,
                  child: Text(
                    "תרגילי נשימה",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.assistant(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 188,
                top: 177,
                child: SizedBox(
                  width: 174,
                  height: 23,
                  child: Text(
                    "מדיטציה",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.assistant(

                    color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),],
          ),
        )),

           Positioned(bottom:10,left:100,child:Image.asset('images/shibi_pages/green.png'))
            ]
      ),
    );
  }
}

class _Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<_Page2> {
  double feeling = 50;
  AudioPlayer music=AudioPlayer();
  Duration _position = new Duration();
  Timer? timer;
  Duration duration = Duration();
  int length=60*12+55;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    audioCache.clearAll();
    music.stop();
  }

  void reset() {
      setState(() => duration = Duration());

  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      if (seconds >=length) {
          stopTimer(resets:true);
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = false}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }
  bool playing=false;

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
    return name;
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
  /**/
  AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();

  Widget _tab(List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children
              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
              .toList(),
        ),
      ),
    );
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }

  Widget localAsset() {
    return _tab([
      Text('Play Local Asset \'audio.mp3\':'),
      _btn('Play', () => audioCache.play('audio.mp3'))
    ]);
  }
   // create this
  bool first=true;
  void _playFile() async{
    if(first){
      startTimer();
      music = await audioCache.play('music/muscles.mp3');}
     // assign player here
    else{

      startTimer();
      music.resume();

    }
    first=false;
  }
  void _stopFile() {
    stopTimer();
    music.pause(); // stop the file like this
  }
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
        children: [  Positioned(top:-150,child:
        Container(
          child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 0.7),
              duration: Duration(seconds: 1),
              builder:
                  (BuildContext context, double percent, Widget? child) {
                return CustomPaint(
                    painter: _LoadBar(percent: -1, size: MediaQuery.of(context).size),
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
                  timer?.cancel();
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
                    onPressed:  () => scaffoldKey.currentState!.openDrawer(),
                    child: new IconTheme(
                      data: new IconThemeData(size: 35, color: Colors.black),
                      child: new Icon(Icons.menu_rounded),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "        הרפיית שרירים",
                      //textAlign: TextAlign.center,
                      style: GoogleFonts.assistant(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),),

                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
            Container(
                width: 358,
                height: 255,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:[
                    Container(
                      width: 358,
                      height: 255,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3f000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: Color(0xffdeeef3),
                      ),
                      padding: const EdgeInsets.only(left: 30, right: 31, top: 37, bottom: 25, ),
                      child:Column(children:[
                          Text(
                            "לפני התחלת תרגיל הרפיית השרירים\n"
                            "עברו למצב של שכיבה\n",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.assistant(
                              color: CupertinoColors.systemGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                        Text(" לחצו על הכפתור להתחלת התרגיל",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.assistant(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        //                        " לחצו על הכפתור להתחלת התרגיל",
                          Container(height:20),
                        Row(children:[
                        TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xff8eafc3),
                        shape: CircleBorder(),
                        fixedSize: Size(
                            57,
                            57
                        ),
                      ),
                      child:playing? Icon(
                        Icons.pause_rounded,
                        size: 45,
                        color: Colors.white,
                      ):Icon(
                        Icons.play_arrow_rounded,
                        size: 45,
                        color: Colors.white,
                      )

                          ,
                      onPressed:   ()   {
setState(() {
  if(playing){
    _stopFile();
    playing=false;
  }else{
    _playFile();
    playing=true;
  }
  }
  );          }

                      ,
                    ),
                          Container(width:230,child:
                          SliderTheme(
                              child:Slider(
                              value: duration.inSeconds.toDouble(),
                              min: 0.0,
                              max: 12*60+17,

                              onChanged: (double value) {
                                setState(() {
                                  value = value;
                                });})
                              ,data:SliderTheme.of(context).copyWith(

                              inactiveTrackColor: Color(0xffc1c1c1) ,
                              activeTrackColor: Color(0xff6c92a7),
                              overlayColor: Color(0xff6c92a7),
                              trackHeight: 2,
                              thumbColor: Colors.transparent,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
                          ),)

                        ])
                        ])

              ),])),
        ],
      ),
          Positioned(
            bottom: 0,
                child: Image.asset('images/meditate1.png')
          )
    ]));
  }
}
class _Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<_Page3> {
  double feeling = 50;
  AudioPlayer music=AudioPlayer();
  Duration _position = new Duration();
  Timer? timer;
  Duration duration = Duration();
  int length=60*1+49;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    audioCache.clearAll();
    music.stop();
  }

  void reset() {
    setState(() => duration = Duration());

  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      if (seconds >=length) {
        stopTimer(resets:true);
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = false}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }
  bool playing=false;

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
    return name;
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
  /**/
  AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();

  Widget _tab(List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children
              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
              .toList(),
        ),
      ),
    );
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }

  Widget localAsset() {
    return _tab([
      Text('Play Local Asset \'audio.mp3\':'),
      _btn('Play', () => audioCache.play('audio.mp3'))
    ]);
  }
  // create this
  bool first=true;
  void _playFile() async{
    if(first){
      startTimer();
      music = await audioCache.play('music/breathing.mp3');}
    // assign player here
    else{

      startTimer();
      music.resume();

    }
    first=false;
  }
  void _stopFile() {
    stopTimer();
    music.pause(); // stop the file like this
  }
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
            children: [  Positioned(top:-150,child:
            Container(
              child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 0.7),
                  duration: Duration(seconds: 1),
                  builder:
                      (BuildContext context, double percent, Widget? child) {
                    return CustomPaint(
                        painter: _LoadBar(percent: -1, size: MediaQuery.of(context).size),
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
                      timer?.cancel();
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
                        onPressed:  () => scaffoldKey.currentState!.openDrawer(),
                        child: new IconTheme(
                          data: new IconThemeData(size: 35, color: Colors.black),
                          child: new Icon(Icons.menu_rounded),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "        תרגילי נשימה",
                          //textAlign: TextAlign.center,
                          style: GoogleFonts.assistant(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),),

                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Container(
                      width: 358,
                      height: 255,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            Container(
                                width: 358,
                                height: 255,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  color: Color(0xffdeeef3),
                                ),
                                padding: const EdgeInsets.only(left: 30, right: 31, top: 37, bottom: 25, ),
                                child:Column(children:[
                                  Text(
                                    "תרגיל זה יעזור לכם \n"
                                        "להירגע במקרים של לחץ וחרדה\n",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.assistant(
                                      color: CupertinoColors.systemGrey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Text(" לחצו על הכפתור להתחלת התרגיל",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.assistant(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  //                        " לחצו על הכפתור להתחלת התרגיל",
                                  Container(height:20),
                                  Row(children:[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xff8eafc3),
                                        shape: CircleBorder(),
                                        fixedSize: Size(
                                            57,
                                            57
                                        ),
                                      ),
                                      child:playing? Icon(
                                        Icons.pause_rounded,
                                        size: 45,
                                        color: Colors.white,
                                      ):Icon(
                                        Icons.play_arrow_rounded,
                                        size: 45,
                                        color: Colors.white,
                                      )

                                      ,
                                      onPressed:   ()   {
                                        setState(() {
                                          if(playing){
                                            _stopFile();
                                            playing=false;
                                          }else{
                                            _playFile();
                                            playing=true;
                                          }
                                        }
                                        );          }

                                      ,
                                    ),
                                    Container(width:230,child:
                                    SliderTheme(
                                      child:Slider(
                                          value: duration.inSeconds.toDouble(),
                                          min: 0.0,
                                          max: 12*60+17,

                                          onChanged: (double value) {
                                            setState(() {
                                              value = value;
                                            });})
                                      ,data:SliderTheme.of(context).copyWith(

                                        inactiveTrackColor: Color(0xffc1c1c1) ,
                                        activeTrackColor: Color(0xff6c92a7),
                                        overlayColor: Color(0xff6c92a7),
                                        trackHeight: 2,
                                        thumbColor: Colors.transparent,
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
                                    ),)

                                  ])
                                ])

                            ),])),
                ],
              ),
              Positioned(
                  bottom: 0,
                  child: Image.asset('images/meditate1.png')
              )
            ]));
  }
}
class _Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<_Page4> {
  double feeling = 50;
  AudioPlayer music=AudioPlayer();
  Duration _position = new Duration();
  Timer? timer;
  Duration duration = Duration();
  int length=60*9+12;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    audioCache.clearAll();
    music.stop();
  }

  void reset() {
    setState(() => duration = Duration());

  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      if (seconds >=length) {
        stopTimer(resets:true);
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = false}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }
  bool playing=false;

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
    return name;
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
  /**/
  AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();

  Widget _tab(List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children
              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
              .toList(),
        ),
      ),
    );
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }

  Widget localAsset() {
    return _tab([
      Text('Play Local Asset \'audio.mp3\':'),
      _btn('Play', () => audioCache.play('audio.mp3'))
    ]);
  }
  // create this
  bool first=true;
  void _playFile() async{
    if(first){
      startTimer();
      music = await audioCache.play('music/guided.mp3');}
    // assign player here
    else{

      startTimer();
      music.resume();

    }
    first=false;
  }
  void _stopFile() {
    stopTimer();
    music.pause(); // stop the file like this
  }
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
            children: [  Positioned(top:-150,child:
            Container(
              child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 0.7),
                  duration: Duration(seconds: 1),
                  builder:
                      (BuildContext context, double percent, Widget? child) {
                    return CustomPaint(
                        painter: _LoadBar(percent: -1, size: MediaQuery.of(context).size),
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
                      timer?.cancel();
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
                        onPressed:  () => scaffoldKey.currentState!.openDrawer(),
                        child: new IconTheme(
                          data: new IconThemeData(size: 35, color: Colors.black),
                          child: new Icon(Icons.menu_rounded),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "        דמיון מודרך",
                          //textAlign: TextAlign.center,
                          style: GoogleFonts.assistant(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),),

                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Container(
                      width: 358,
                      height: 255,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            Container(
                                width: 358,
                                height: 255,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  color: Color(0xffdeeef3),
                                ),
                                padding: const EdgeInsets.only(left: 30, right: 31, top: 37, bottom: 25, ),
                                child:Column(children:[
                                  Text(
                                    "לפני התחלת תרגיל הדמיון המודרך\n"
                                        " עצמו עיניים והתכוננו לתרגיל\n",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.assistant(
                                      color: CupertinoColors.systemGrey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Text(" לחצו על הכפתור להתחלת התרגיל",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.assistant(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  //                        " לחצו על הכפתור להתחלת התרגיל",
                                  Container(height:20),
                                  Row(children:[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xff8eafc3),
                                        shape: CircleBorder(),
                                        fixedSize: Size(
                                            57,
                                            57
                                        ),
                                      ),
                                      child:playing? Icon(
                                        Icons.pause_rounded,
                                        size: 45,
                                        color: Colors.white,
                                      ):Icon(
                                        Icons.play_arrow_rounded,
                                        size: 45,
                                        color: Colors.white,
                                      )

                                      ,
                                      onPressed:   ()   {
                                        setState(() {
                                          if(playing){
                                            _stopFile();
                                            playing=false;
                                          }else{
                                            _playFile();
                                            playing=true;
                                          }
                                        }
                                        );          }

                                      ,
                                    ),
                                    Container(width:230,child:
                                    SliderTheme(
                                      child:Slider(
                                          value: duration.inSeconds.toDouble(),
                                          min: 0.0,
                                          max: 12*60+17,

                                          onChanged: (double value) {
                                            setState(() {
                                              value = value;
                                            });})
                                      ,data:SliderTheme.of(context).copyWith(

                                        inactiveTrackColor: Color(0xffc1c1c1) ,
                                        activeTrackColor: Color(0xff6c92a7),
                                        overlayColor: Color(0xff6c92a7),
                                        trackHeight: 2,
                                        thumbColor: Colors.transparent,
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
                                    ),)

                                  ])
                                ])

                            ),])),
                ],
              ),
              Positioned(
                  bottom: 0,
                  child: Image.asset('images/meditate1.png')
              )
            ]));
  }
}
class _Page5 extends StatefulWidget {
  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<_Page5> {
  double feeling = 50;
  AudioPlayer music=AudioPlayer();
  Duration _position = new Duration();
  Timer? timer;
  Duration duration = Duration();
  int length=60*12+55;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    audioCache.clearAll();
    music.stop();
  }

  void reset() {
    setState(() => duration = Duration());

  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      if (seconds >=length) {
        stopTimer(resets:true);
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = false}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }
  bool playing=false;

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
    return name;
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
  /**/
  AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();

  Widget _tab(List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children
              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
              .toList(),
        ),
      ),
    );
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }

  Widget localAsset() {
    return _tab([
      Text('Play Local Asset \'audio.mp3\':'),
      _btn('Play', () => audioCache.play('audio.mp3'))
    ]);
  }
  // create this
  bool first=true;
  void _playFile() async{
    if(first){
      startTimer();
      music = await audioCache.play('music/meditation.mp3');}
    // assign player here
    else{

      startTimer();
      music.resume();

    }
    first=false;
  }
  void _stopFile() {
    stopTimer();
    music.pause(); // stop the file like this
  }
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
            children: [  Positioned(top:-150,child:
            Container(
              child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 0.7),
                  duration: Duration(seconds: 1),
                  builder:
                      (BuildContext context, double percent, Widget? child) {
                    return CustomPaint(
                        painter: _LoadBar(percent: -1, size: MediaQuery.of(context).size),
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
                      timer?.cancel();
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
                        onPressed:  () => scaffoldKey.currentState!.openDrawer(),
                        child: new IconTheme(
                          data: new IconThemeData(size: 35, color: Colors.black),
                          child: new Icon(Icons.menu_rounded),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "            מדיטציה",
                          //textAlign: TextAlign.center,
                          style: GoogleFonts.assistant(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),),

                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Container(
                      width: 358,
                      height: 255,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            Container(
                                width: 358,
                                height: 255,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  color: Color(0xffdeeef3),
                                ),
                                padding: const EdgeInsets.only(left: 30, right: 31, top: 37, bottom: 25, ),
                                child:Column(children:[
                                  Text(
                                    "לפני התחלת תרגיל המדיטציה\n"
                                        "עברו למצב של ישיבה או שכיבה\n",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.assistant(
                                      color: CupertinoColors.systemGrey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Text(" לחצו על הכפתור להתחלת התרגיל",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.assistant(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  //                        " לחצו על הכפתור להתחלת התרגיל",
                                  Container(height:20),
                                  Row(children:[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xff8eafc3),
                                        shape: CircleBorder(),
                                        fixedSize: Size(
                                            57,
                                            57
                                        ),
                                      ),
                                      child:playing? Icon(
                                        Icons.pause_rounded,
                                        size: 45,
                                        color: Colors.white,
                                      ):Icon(
                                        Icons.play_arrow_rounded,
                                        size: 45,
                                        color: Colors.white,
                                      )

                                      ,
                                      onPressed:   ()   {
                                        setState(() {
                                          if(playing){
                                            _stopFile();
                                            playing=false;
                                          }else{
                                            _playFile();
                                            playing=true;
                                          }
                                        }
                                        );          }

                                      ,
                                    ),
                                    Container(width:230,child:
                                    SliderTheme(
                                      child:Slider(
                                          value: duration.inSeconds.toDouble(),
                                          min: 0.0,
                                          max: 12*60+17,

                                          onChanged: (double value) {
                                            setState(() {
                                              value = value;
                                            });})
                                      ,data:SliderTheme.of(context).copyWith(

                                        inactiveTrackColor: Color(0xffc1c1c1) ,
                                        activeTrackColor: Color(0xff6c92a7),
                                        overlayColor: Color(0xff6c92a7),
                                        trackHeight: 2,
                                        thumbColor: Colors.transparent,
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
                                    ),)

                                  ])
                                ])

                            ),])),
                ],
              ),
              Positioned(
                  bottom: 0,
                  child: Image.asset('images/meditate1.png')
              )
            ]));
  }
}

class _Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<_Main> {
  int choose = -1;

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
                onPressed:  () => scaffoldKey.currentState!.openDrawer(),
                child: new IconTheme(
                  data: new IconThemeData(size: 35, color: Colors.black),
                  child: new Icon(Icons.menu_rounded),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "                  זיהוי",
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
                width:80
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "בואי נזהה יחד את החרדה",
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
                      "בחרי עם איזה זיהוי להתחיל",
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
                  child: Consumer<ExpoData>(
                    builder: (context, data, w) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _MyButton(
                              isDone: data.done[0],
                              isSelected: (choose == 0),
                              name: 'גוף',
                              func: () {
                                setState(() {
                                  choose = 0;
                                });
                              },
                              image: 'images/expo/meditate.png'),
                          _MyButton(
                              isDone: data.done[1],
                              isSelected: (choose == 1),
                              name: 'רגשות',
                              func: () {
                                setState(() {
                                  choose = 1;
                                });
                              },
                              image: 'images/expo/smile.png'),
                          _MyButton(
                              isDone: data.done[2],
                              isSelected: (choose == 2),
                              name: 'מחשבות',
                              func: () {
                                setState(() {
                                  choose = 2;
                                });
                              },
                              image: 'images/expo/brain.png'),
                        ],
                      );
                    },
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
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "Assistant",
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
                          style: TextStyle(
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
              await Navigator.pushNamed(context, '/thoughts/1');
            } else if (choose == 0) {
              await Navigator.pushNamed(context, '/body/1');
            } else if (choose == 1) {
              await Navigator.pushNamed(context, '/feelings/1');
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
    var x = Provider.of<ExpoData>(context, listen: false).introductions;
    if (choose == 0) return x[0].item1;
    if (choose == 1) return x[1].item1;
    if (choose == 2) return x[2].item1;
    return '';
  }

  String _text() {
    var x = Provider.of<ExpoData>(context, listen: false).introductions;
    if (choose == 0) return  x[0].item2;
    if (choose == 1) return x[1].item2;
    if (choose == 2) return  x[2].item2;
    return '';
  }

  Color _color() {
    var x = Provider.of<ExpoData>(context, listen: false).colors;
    if (choose == 0) return  x[1];
    if (choose == 1) return x[2];
    if (choose == 2) return  x[0];
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

class ExpoData {
  ExpoData({required this.adata, required this.theCase,required this.body_task,required this.feelings_task,required this.thoughts_task}) {

    while (feelings.length % 8 != 0) {
      feelings.add('');
    }

    introductions=[all_introductions[0][body_task],all_introductions[1][feelings_task], all_introductions[2][thoughts_task]];
  }
  int body_task, feelings_task, thoughts_task;
  String theCase;
  List<Color> colors=[
    Color(0xfff3f1de),
    Color(0xffdef3df),
    Color(0xffefd6ee)
  ];
  List<List<Tuple2<String,String>>> all_introductions=[
    [Tuple2('זיהוי גוף','חשוב שנלמד לזהות כיצד הגוף משפיע על החרדה שלנו.'  )],
    [Tuple2('זיהוי רגשות',  'הרגש הוא חלק מהותי מן החרדה שלנו......')],
    [Tuple2( 'זיהוי מחשבות',  'המחשבות הם מחל מהמחשבה, וחשוב שנאתרן...')]];
  List<Tuple2<String,String>> introductions=[];

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

  List<String> painSpots=[];
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

    canvas.drawCircle(center, size.width*1.05,painter..color = Color(0xffdef3df)
      ..style = PaintingStyle.fill );
    if (percent != -1)
      canvas.drawArc(Rect.fromCircle(center: center, radius: size.width*1.05), 0, pi,
        false, painter..color = Color(0xffc4c4c4)..style = PaintingStyle.stroke);
    else
      canvas.drawArc(Rect.fromCircle(center: center, radius: size.width*1.05), 0, pi,
          false, painter..color = Color(0xffDEF3DF)..style = PaintingStyle.stroke);

    double pad = 0.2;
    if (percent != -1)

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width*1.05),
        0,
        pi / 2 - pi / 6 + pad,
        false,
        painter..color = Color(0xff35258A)..style = PaintingStyle.stroke);
    if (percent != -1)

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
