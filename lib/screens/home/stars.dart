library home;

import 'dart:async';
import 'dart:math';

import 'package:application/screens/Avatar/color_switch.dart';
import 'package:application/screens/Avatar/give_money.dart';
import 'package:application/screens/expo1/body_tools.dart';
import 'package:application/screens/expo1/feelings_tools.dart';
import 'package:application/screens/expo1/start.dart';
import 'package:application/screens/expo1/thougths_challenge.dart';
import 'package:application/screens/home/personal_diary.dart';
import 'package:application/screens/home/psycho.dart';
import 'package:application/screens/login/homescreen.dart';
import 'package:application/screens/map/map.dart';
import 'package:application/screens/map/meditation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import '../Avatar/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../login/login.dart';
import '../../services/auth_services.dart';
import 'home.dart';

class Stars extends StatefulWidget {
  Stars({required this.cur_star});
  int cur_star;
  @override
  StarsState createState() {
    return new StarsState(cur_star: cur_star);
  }
}

class StarsState extends State<Stars> {
  StarsState({required this.cur_star});
  int cur_star;
  static Future<String> loadMoney() async {
    String? pid = AuthRepository.instance().user?.uid;
    var v =
        (await FirebaseFirestore.instance.collection("avatars").doc(pid).get());
    print('load');
    var a = v['money'];
    var s = a.toString();
    print("ADADSDASD       " + a.toString());
    return s;
  }

  Future<AvatarData>? _adata;
  Future<String>? _name;
  var expos;
  var moneyd;
  final _pageController = PageController();

  ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);
  Future<String> _getname() async {
    var name = (await FirebaseFirestore.instance
        .collection("users")
        .doc(AuthRepository.instance().user?.uid)
        .get())['name'];
    print(name);
    return name;
  }

  Future<List<dynamic>> _getExpos() async {
    print("sadsadas THE EXPOS:------------------------");
    var name = (await FirebaseFirestore.instance
        .collection("expos")
        .doc(AuthRepository.instance().user?.uid)
        .get());

    print(name['tasks']);
    return name['tasks'];
  }

  Color _chooseColor() {
    int i = _currentPageNotifier.value;
    if (i == 0) return Color(0xffEEDBEA);
    if (i == 1) return Color(0xffC7F5E1);
    if (i == 2)
      return Color(0xffA9E1F4);
    else
      return Color(0xffFBF6C6);
  }

  String _chooseTitle() {
    int i = _currentPageNotifier.value;
    if (i == 0) return "התנהגות";
    if (i == 1) return "גוף";
    if (i == 2)
      return "רגש";
    else
      return "מחשבה";
  }

  String _chooseIcon() {
    int i = _currentPageNotifier.value;
    if (i == 0) return "images/expo/ppl.png";
    if (i == 1) return "images/expo/meditate.png";
    if (i == 2)
      return "images/expo/smile.png";
    else
      return "images/expo/brain.png";
  }

  int _chooseIndicator() {
    int i = _currentPageNotifier.value;
    return i;
  }

  @override
  void initState() {
    super.initState();
    _adata = AvatarData.load();
    _name = _getname();
    moneyd = loadMoney();
    expos = _getExpos();
    _currentPageNotifier = ValueNotifier<int>(cur_star);
  }

  @override
  Widget build(BuildContext context) {
    /*GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Icon(Icons.menu))*/

    var x = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    var size = Size(x, 0.7 * x);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
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
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      // ...
                      if (snapshot.connectionState == ConnectionState.done) {
                        String data = snapshot.data ?? '';
                        print("datata:" + data);
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
            Container(
                height: height * 0.8,
                width: width,
                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        right: -height * 0.7 * 0.15,
                        child: Container(
                          width: height * 0.7,
                          height: height * 0.7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _chooseColor(),
                          ),
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (int index) {
                              _currentPageNotifier.value = index;
                              setState(() {});
                            },
                            itemCount: 4,
                            controller: _pageController,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ExpoStars(3,expos,_adata,0,_currentPageNotifier.value),
                              ExpoStars(2,expos,_adata,3,_currentPageNotifier.value),
                                    Container(height: 5)
                                  ]);
                            },
                          ),
                        )),
                    Positioned(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CirclePageIndicator(
                            itemCount: 4,
                            currentPageNotifier: _currentPageNotifier,
                            size: 10,
                            dotColor: Colors.white54,
                            selectedSize: 10,
                            selectedDotColor: Colors.white,
                          ),
                        ),
                        top: height * 0.75,
                        right: width * 0.4)
                  ],
                ))
          ]),
          Positioned(
            top: 0.13 * height,
            left: (_currentPageNotifier.value == 0 ||
                    _currentPageNotifier.value == 3)
                ? width * 0.4
                : width * 0.45,
            child: Text(
              _chooseTitle(),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.assistant(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff35258A)),
            ),
          ),
          Positioned(
            top: 60,
            left: width * 0.44,
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Image.asset(_chooseIcon(), color: Color(0xffB3E8EF)),
              ),
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff35258A),
              ),
            ),
          ),
          Positioned(child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xff35258a),
              shape: CircleBorder(),
              fixedSize: Size(
                  48,
                  48
              ),
            ),
            child: Icon(
              Icons.arrow_forward_sharp,
              size: 35,
              color: Colors.white,
            ),
            onPressed:   ()   {Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (BuildContext context) =>
    Home()));
    }
            ,
          ),
          top:30,
          left:width*0.8
          ),
          Positioned(
              child: Image.asset('images/Shoola.png'),
              bottom: 10,
              left: 0)
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
            title: Text("מפה",
                textDirection: TextDirection.rtl,
                style: GoogleFonts.assistant()),
            onTap: () {
              Future<void> _signOut() async {
                await FirebaseAuth.instance.signOut();
              }

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Money(to_give: 10, first: false)));
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
    );
  }
}

ExpoStars(int amount,expos,_adata,prevs,curr_page){

  List<Widget> stars=[Container(width: 20)];
  print(stars.length);
  for(int i=prevs; i<amount+prevs;i++){

    stars.add(        FutureBuilder<dynamic>(
        future: expos,
        builder: (BuildContext context,
            AsyncSnapshot<dynamic>
            snapshot1) {
          if (snapshot1.connectionState ==
              ConnectionState.done) {

            String data1;
            if(i<snapshot1.data.length){data1=
                snapshot1.data![i] ?? '';
            print(data1);}
            else{
              return Image.asset(
                  "images/staroff.png");
            }
            return FutureBuilder<
                AvatarData>(
              future: _adata,
              builder:
                  (BuildContext context,
                  AsyncSnapshot<
                      AvatarData>
                  snapshot) {
                if (snapshot
                    .connectionState ==
                    ConnectionState
                        .done) {
                  AvatarData data =
                      snapshot.data ??
                          AvatarData();
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(
                            context)
                            .pushReplacement(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                (curr_page==0)?Expo1(
                                      adata: data,
                                      theCase: data1,
                                    ):(curr_page==1)?BodyTools(
                                  adata: data,
                                  theCase: data1,
                                ):(curr_page==2)?FeelingsTools(
                                  adata: data,
                                  theCase: data1,
                                ):ThoughtsChallenge(
                                  adata: data,
                                  theCase: data1,
                                )
                            ));
                      },
                      child: Image.asset(
                          "images/staron.png"));
                }
                return CircularProgressIndicator();
              },
            );
          }
          return CircularProgressIndicator();
        })
    );
  }
  stars.add(
      Container(width: 20));
  return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: stars);
}
Widget build_money(String text) {
  return Stack(children: [
    Image.asset('images/coin.png'),
    Positioned(
      top: 10,
      left: 10,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          height: 0.65,
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    ),
  ]);
}
