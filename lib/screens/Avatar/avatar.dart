import 'dart:math';
import 'package:application/screens/Avatar/bars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_services.dart';
import 'package:tuple/tuple.dart';
import 'dart:convert';
import 'color_switch.dart';

class AvatarData {
  AvatarData(
      {this.body,
      this.glasses,
      this.hands,
      this.body_color,
      this.money,
        this.acquired,
      this.eye_color}) {
    legs = legs ?? 'images/legs.png';
    body = body ?? AvatarData.body_default;
    hands = hands ?? AvatarData.hand_default;
    glasses = glasses ?? "images/glasses1.png";
    acquired = acquired ?? AvatarShop.empty();
    body_color = body_color ?? color_default;
    eye_color = eye_color ?? Colors.black;
  }
  Color? eye_color;

  AvatarShop? acquired;
  String? body;
  String? glasses;
  String? hands;
  String? legs;
  int? money;
  Color? body_color;


  static Color color_default = Color(0xffdabfa0);

  static String body_default = "images/poo.png";
  static String hand_default = "images/handsopen.png";

  AvatarData clone(){
    return AvatarData(
      body: this.body,
        glasses: this.glasses,
        hands: this.hands,
        body_color: this.body_color,
        money: this.money,
        acquired: this.acquired,
        eye_color: this.eye_color
    );
  }

  static Future<AvatarData> load() async {
    String? pid = AuthRepository.instance().user?.uid;
    var v =
        (await FirebaseFirestore.instance.collection("avatars").doc(pid).get());


    print('load');
    var a = AvatarData(
        money: v['money'],
        body: v['body'],
        glasses: v['glasses'],
        eye_color: Color(int.parse(v['eye_color'], radix: 16)),
        body_color: Color(int.parse(v['body_color'], radix: 16)),
    );
    return a;
  }
}

class Avatar extends StatelessWidget {
  // This widget is the root of your application.
  Avatar({required this.first,  this.data});
  final bool first;
  final Future<AvatarData>? data;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (first)
          ? AvatarPage(
              title: "hey",
              data: AvatarData(
                  body: AvatarData.body_default,
                  money: 10))
          : FutureBuilder(
              future: data,
              builder:
                  (BuildContext context, AsyncSnapshot<AvatarData> snapshot) {
                if (snapshot.hasData) {
                  return AvatarPage(
                      title: "hey",
                      data: (snapshot.data ??
                          AvatarData(
                              body: AvatarData.body_default,
                              hands: AvatarData.hand_default,
                              body_color: AvatarData.color_default)));
                } else
                  return CircularProgressIndicator();
              }),
    );
  }
}

class AvatarPage extends StatefulWidget {
  AvatarPage({Key? key, required this.title, required this.data})
      : super(key: key);
  final String title;

  @override
  _AvatarPageState createState() => _AvatarPageState();
  final AvatarData data;
}

class _AvatarPageState extends State<AvatarPage> {
  void _save() async {
    String? pid = AuthRepository.instance().user?.uid;
    await FirebaseFirestore.instance.collection("avatars").doc(pid).update({
      'body': widget.data.body,
      'glasses': widget.data.glasses,
      'body_color': widget.data.body_color.toString().split('(0x')[1].split(')')[0],
      'purchased' : widget.data.acquired?.toString(),
      'money' : widget.data.money,
      'eye_color': widget.data.eye_color.toString().split('(0x')[1].split(')')[0],
    });
  }

  buy(int i, int j, int n){
    int money = widget.data.money ?? 0;
    if((widget.data.acquired?.acquired_items[i][j][n]?? false) || money>= AvatarShop.merch[i][j][n].item2){
     setState(() {
       widget.data.money =money - AvatarShop.merch[i][j][n].item2;
       widget.data.acquired?.acquired_items[i][j][n] = true;
     });
    }
  }

  choose(int group, int sub_group, int object){
    print('group: '+ group.toString()+' sub_group: '+ sub_group.toString()+ " object: "+object.toString());
    print(widget.data.acquired?.acquired_items);
    if(widget.data.acquired?.acquired_items[group][sub_group][object]?? false){
      switch (group){
        case 0:{
          if(sub_group==0)       setState(() {
            widget.data.glasses = AvatarShop.merch[group][sub_group][object].item1;
          });
        }break;
        case 1:{
          if(sub_group==0) {
            if(object ==0) setState(() {widget.data.body_color = Color(0xff6f6ca7);});
            if(object ==1) setState(() {widget.data.body_color = Color(0xffa6d6c3);});
            if(object ==2) setState(() {widget.data.body_color = Color(0xffdabfa0);});
            if(object ==3) setState(() {widget.data.body_color = Color(0xffefb3e2);});
          }
          else if(sub_group ==1){
            if(object ==0) setState(() {widget.data.eye_color = Color(0xff6f6ca7);});
            if(object ==1) setState(() {widget.data.eye_color = Color(0xffa6d6c3);});
            if(object ==2) setState(() {widget.data.eye_color = Color(0xffdabfa0);});
            if(object ==3) setState(() {widget.data.eye_color = Color(0xffefb3e2);});
          }
        }break;
      }
    }
  }


  Widget build_money(String text) {
    return Stack(children: [
      Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          color: Colors.white,
        ),
      ),
      Container(
        width: 24,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          color: Colors.white,
        ),
      ),
      Container(
        width: 24,
        height: 26,
        child: Center(
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
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _min = min(_width, _height);
    return Scaffold(
        body: Stack(children: [
          Positioned(
              left: -0.8 * MediaQuery.of(context).size.width,
              top: -1.25 * MediaQuery.of(context).size.height,
              child: Container(
                  width: 0.8125 * MediaQuery.of(context).size.height * 2,
                  height: 0.8125 * MediaQuery.of(context).size.height * 1.8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.data.body_color?.withOpacity(0.7)))),
          Positioned(
              right: 25,
              top: 75,
              child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "עיצוב השיבי שלך",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.assistant(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ]))),

          // Figma Flutter Generator Group304Widget - GROUP

          Positioned(
              left: 22,
              top: 131.32,
              child: build_money(widget.data.money.toString())),
          Positioned(
              right:  MediaQuery.of(context).size.width*0.08,
              top:  MediaQuery.of(context).size.height*0.19,child:Stack(children: [ Container(
            width: 192,
            height: 29,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(88),
              boxShadow: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
              color: Color(0xffc4c4c4),
            ),

          ),
          Container(
            width: 96,
            height: 29,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(88),
              color: Color(0xff35258a),
            ),
          ),
          Positioned(  child:Text('חנות',style:GoogleFonts.assistant(color:Colors.white,fontWeight: FontWeight.w700)),left:30,top:3),

            Positioned(  child:Text('המוצרים שלי',style:GoogleFonts.assistant(color:Colors.white,fontWeight: FontWeight.w700)),left:100,top:3)
          ],)),
          Positioned(
            left: 45,
            top: 120,
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {},
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(height: 200),
                Flexible(
                  flex:1,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height:MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(left:50, right: 50),
                      child: AvatarStack(
                        data: widget.data,
                      )),
                ),
                Container(height: 10),
                Row(
                  children: [
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
                        _save();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => Home()));
                      },
                    ),
                  ],
                ),
                AvatarBar(
                    shop: widget.data.acquired ?? AvatarShop(AvatarShop.empty().toString()),
                    tap: choose,
                    dtap: buy),

              ],
            ),
          )
        ]),
    );
  }
}

class AvatarStack extends StatelessWidget {
  AvatarStack({required this.data, Key? key}) : super(key: key);
  Map<String,Tuple3<double,double,double>> dits=
  {// image :            top offset , left offset, height
    'images/handsclosed.png': Tuple3(0.3,0,0.25,),
    'images/handsopen.png':   Tuple3(0.2,0,0.3,),
    'images/handsdown.png':   Tuple3(0.4,0.02,0.3,),
    'images/handsbaloon.png':   Tuple3(0,0,0.9,)


  };
  final AvatarData data;
  @override
  Widget build(BuildContext context) {
    return Center(child:
        LayoutBuilder(builder: (BuildContext context, BoxConstraints cons) {
      return Container(
          // color:Colors.grey,
          width: min(cons.maxWidth, cons.maxHeight),
          height: min(cons.maxWidth, cons.maxHeight),
          child: Stack(children: <Widget>[
            //legs
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.green,
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: ImageColorSwitcher(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight*0.35,
                              color: data.body_color!,
                              imagePath: data.legs!,
                              second:   Color(0xffAC957B),
                              main:Color(0xffDABFA0),
                            )
                        ),
                        height: constraints.maxHeight*0.35 ,
                        margin: EdgeInsets.only(
                          top: constraints.maxHeight * 0.6,
                          // left: constraints.maxWidth/14
                        ),
                      ),
                    ]);
              },
            ),
            //body
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var r = constraints.maxWidth * 0.5;
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Container(
                              width: r,
                              height: r,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(r),
                                  border: Border.all(
                                    color: data.body_color ?? Colors.grey,
                                    width: r * 45 / 128,
                                  ))),
                          margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.15,
                          )),
                    ]);
              },
            ),
            //hands
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (dits[data.hands!] == null) return Container();
                Tuple3<double,double,double> dit = dits[data.hands!]!;
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.green,
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: ImageColorSwitcher(
                              width: constraints.maxWidth*(1-dit.item2),
                              height: constraints.maxHeight*dit.item3,
                              color: data.body_color!,
                              imagePath: data.hands!,
                              second:  Color(0xffAC957B),
                              main:    Color(0xffDABFA0),
                            )
                        ),
                        height: constraints.maxHeight*dit.item3 ,
                        margin: EdgeInsets.only(
                          top: constraints.maxHeight * dit.item1,
                          left: constraints.maxWidth * dit.item2,
                          // left: constraints.maxWidth/14
                        ),
                      ),
                    ]);
              },
            ),
            //glasses
            if (data.glasses != null)
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: ImageColorSwitcher(
                      color: data.eye_color!,
                    height: constraints.maxHeight * 0.08,
                    width: constraints.maxWidth,
                    main: Color(0xff000000),
                    second: Color(0xff000000),
                    imagePath: data.glasses!,
                    forgive: 100,
                  ),
                          height: constraints.maxHeight * 0.08,
                          margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.18,
                            // left: constraints.maxWidth/14
                          ),
                        ),
                      ]);
                },
              )
          ]));
    }));
  }
}

class LoadAvatar extends StatefulWidget {
  @override
  _LoadAvatarState createState() => _LoadAvatarState();
}

class _LoadAvatarState extends State<LoadAvatar> {
  Future<AvatarData>? _data;

  @override
  void initState() {
    super.initState();
    _data = AvatarData.load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _data,
        builder: (BuildContext context, AsyncSnapshot<AvatarData> snapshot) {
          if (snapshot.hasData) {
            return AvatarStack(
                data: (snapshot.data ??
                    AvatarData(
                        body: AvatarData.body_default,
                        hands: AvatarData.hand_default,
                      )));
          } else
            return CircularProgressIndicator(
              color: Colors.green,
            );
        });
  }
}

class AvatarShop {
  AvatarShop(String s) : acquired_items=[] {
    fromString(s);
  }

  List<List<List<bool>>> acquired_items;
  static List<String> groups =
  [
    'images/face.png',
    'images/color.png',

  ];

  static List<List<String>> sub_groups =
  [
    [
      'images/eyes.png',
      'images/brows.png',
      'images/mouth.png',
    ],
    [
      'images/body.png',
      'images/eyes.png',
      'images/mouth.png',
    ]
  ];

  static List<List<List<Tuple2<String, int>>>> merch =
  [
    [ //face
      [ //eyes
        Tuple2('images/glasses1.png', 0),
        Tuple2('images/glasses2.png', 0),
        Tuple2('images/glasses3.png', 10),
        Tuple2('images/glasses4.png', 12),
      ],
      [], //brows
      [], //lips
    ],
    [ //color
      [ //body
        Tuple2('images/color(ff6f6ca7).png', 0),
        Tuple2('images/color(ffa6d6c3).png', 0),
        Tuple2('images/color(ffdabfa0).png', 0),
        Tuple2('images/color(ffefb3e2).png', 0),
      ],
      [ //eyes
        Tuple2('images/color(ff6f6ca7).png', 0),
        Tuple2('images/color(ffa6d6c3).png', 0),
        Tuple2('images/color(ffdabfa0).png', 0),
        Tuple2('images/color(ffefb3e2).png', 0),
      ],
      [ //lips
        Tuple2('images/color(ff6f6ca7).png', 0),
        Tuple2('images/color(ffa6d6c3).png', 0),
        Tuple2('images/color(ffdabfa0).png', 0),
        Tuple2('images/color(ffefb3e2).png', 0),
      ]
    ]
  ];

  static AvatarShop empty() {
    List<List<List<bool>>> ret = [];
    for (int i = 0; i < groups.length; i++) {
      ret.add([]);
      for (int j = 0; j < sub_groups[i].length; j++) {
        ret[i].add([]);
        for (int n = 0; n < merch[i][j].length; n++) {
          ret[i][j].add((merch[i][j][n].item2==0)? true : false);
        }
      }
    }
    var a = AvatarShop(ret.toString());
    a.acquired_items=ret;
    return a;
  }

  @override
  toString() {
    var ret = [];
    for (int i = 0; i < groups.length; i++) {
      ret.add([]);
      for (int j = 0; j < sub_groups[i].length; j++) {
        ret[i].add([]);
        for (int n = 0; n < merch[i][j].length; n++) {
          ret[i].add(acquired_items[i][j][n] ? 1 : 0);
        }
      }
    }
    return ret.toString();
  }

  fromString(String s) {
    var lists = json.decode(s);

    if (lists.length != merch.length) {
      acquired_items = AvatarShop
          .empty()
          .acquired_items;
      return;
    }
    for (int i = 0; i < groups.length; i++) {
      if (lists[i].length != merch[i].length) {
        acquired_items = AvatarShop
            .empty()
            .acquired_items;
        return;
      }
      for (int j = 0; j < sub_groups[i].length; j++) {
        if (lists[i][j].length != merch[i][j].length) {
          acquired_items = AvatarShop
              .empty()
              .acquired_items;
          return;
        }
      }
    }


    acquired_items = [];
    for (int i = 0; i < groups.length; i++) {
      acquired_items.add([]);
      for (int j = 0; j < sub_groups[i].length; j++) {
        acquired_items[i].add([]);
        for (int n = 0; n < merch[i][j].length; n++) {
          acquired_items[i][j].add((lists[i][j][n] == 1) ? true : false);
        }
      }
    }
  }


}
