library authentication;

import 'package:application/screens/Avatar/avatar.dart';
import 'package:application/screens/Avatar/give_money.dart';
import 'package:application/screens/login/pre_design.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home/home.dart';
import 'homescreen.dart';
import 'login.dart';
import 'package:flutter/services.dart';

class Password extends StatelessWidget {
  Password({required this.first});
  bool first;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PasswordPage(title: 'Pattern Lock Screen Flutter', first: first),
    );
  }
}

class PasswordPage extends StatefulWidget {
  PasswordPage({Key? key, required this.title, required this.first})
      : super(key: key);

  final String title;
  final bool first;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PasswordPage> {
  Offset offset = Offset(0, 0);
  List<int> codes = [];

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var sizeOfPattern = 0.6;
    var button = widget.first
        ? ElevatedButton(onPressed: _submit, child: Text('submit'))
        : Container();
    var button_text = widget.first ? "!יוצאים לדרך" : "כניסה לשיבי";
    return Scaffold(
      body: Stack(
        children: [
          Positioned(left: 10 ,bottom:0,child:Image.asset('images/shibi_pages/'+((codes.isEmpty)? 'clean' : 'dirty')+'.png')),
          CustomPaint(
            painter: _Painter(),
            size: MediaQuery.of(context).size,
          ),
          Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height * 0.1),
                      Text(
                        "ציירו את הסיסמה שלכם",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.assistant(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Container(height: 10),
                      Text(
                        ",בכדי שנוכל לשמור על פרטיותכם \n    .צרו פאטרן על גבי העיגולים, בעזרתו תכנסו לשיבי",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.assistant(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(height: 10),
                      Text(
                        "הסיסמא היא אישית לך ואינה \n.ניתנת לגורמים אחרים",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.assistant(
                          color: Color(0xff6f6ca7),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(height: 30),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Center(
                            child: Container(
                              margin: EdgeInsets.all(4),
                              child: GestureDetector(
                                child: CustomPaint(
                                  painter: _LockScreenPainter(
                                      codes: codes,
                                      offset: offset,
                                      onSelect: _onSelect),
                                  size: Size.square(
                                      constraints.maxWidth * sizeOfPattern),
                                ),
                                onPanStart: _onPanStart,
                                onPanUpdate: _onPanUpdate,
                                onPanEnd: _onPanEnd,
                              ),
                            ),
                          );
                        },
                      ),
                      Container(height: 20),
                      widget.first?
                      Center(
                          child: Stack(children: [
                        Container(
                            width: 200,
                            height: 39,
                            child: MaterialButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                                  if (widget.first) {
                                    _submit();
                                  } else {
                                    _continue();
                                  }
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
                                      ((() {
                                        if (widget.first) {
                                          return "!יוצאים לדרך";
                                        }

                                        return "כניסה לשיבי";
                                      })()),
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
                                  border:
                                      Border.all(color: Colors.white, width: 9),
                                ))),
                      ])):Container(),
                    ],
                  ))),
          Container(
            margin: EdgeInsets.all(30),
            child: FloatingActionButton(
                backgroundColor: Color(0xffC1DBBF),
                child: Icon(Icons.subdirectory_arrow_left_sharp),
                onPressed:  ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>Login(),)
                )
            ),
          ),

        ],
      ),
    );
  }

  _onPanStart(DragStartDetails event) => _clearCodes();

  _onPanUpdate(DragUpdateDetails event) =>
      setState(() => offset = event.localPosition);

  _onPanEnd(DragEndDetails event) async {
    setState(() => {offset = Offset(0, 0)});
    if (!widget.first) await _continue();
    if (!widget.first) _clearCodes();
  }

  _onSelect(int code) {
    if (codes.isEmpty || !codes.contains(code)) {
      codes.add(code);
    }
  }

  _submit() async {
    String? pid = AuthRepository.instance().user?.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(pid)
        .set({'password': codes.join(' ')}, SetOptions(merge: true));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PreDesign()));
  }

  _continue() async {
    String? pid = AuthRepository.instance().user?.uid;
    String n_pass = (await FirebaseFirestore.instance
        .collection("users")
        .doc(pid)
        .get())['password'];
    // print(n_pass.toString());
    // print(codes.toString());
    if (n_pass == codes.join(' ')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      final snackBar = SnackBar(
        duration: Duration(seconds:1),
        content: const Text('Wrong Password'),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _clearCodes() => setState(() {
        codes = [];
        offset = Offset(0, 0);
      });
}

class _LockScreenPainter extends CustomPainter {
  final int _total = 16;
  final int _col = 4;
  Size size = Size(0, 0);

  final List<int> codes;
  final Offset offset;
  final Function(int code) onSelect;

  _LockScreenPainter({
    required this.codes,
    required this.offset,
    required this.onSelect,
  });

  double get _sizeCode => size.width / _col;

  Paint get _painter => Paint()
    ..color = Colors.white
    ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;

    for (var i = 0; i < _total; i++) {
      var _offset = _getOffetByIndex(i);
      var _color = _getColorByIndex(i);

      var _radiusOut = _sizeCode / 2.0 * 0.6;
      _drawCircle(canvas, _offset, _radiusOut, i);

      var _pathGesture = _getCirclePath(_offset, _radiusOut);
      if (offset != Offset(0, 0) && _pathGesture.contains(offset)) onSelect(i);
    }

    for (var i = 0; i < codes.length; i++) {
      var _start = _getOffetByIndex(codes[i]);
      if (i + 1 < codes.length) {
        var _end = _getOffetByIndex(codes[i + 1]);
        _drawLine(canvas, _start, _end);
      } else if (offset != Offset(0, 0)) {
        var _end = offset;
        _drawLine(canvas, _start, _end);
      }
    }
  }

  Path _getCirclePath(Offset offset, double radius) {
    var _rect = Rect.fromCircle(radius: radius, center: offset);
    return Path()..addOval(_rect);
  }

  void _drawCircle(Canvas canvas, Offset offset, double radius, int i) {
    var _path = _getCirclePath(offset, radius);
    var _painter = this._painter
      ..color = _getColorByIndex(i, def: true)
      ..style = PaintingStyle.fill;
    canvas.drawPath(_path, _painter);
    _path = _getCirclePath(offset, radius * 0.5);
    canvas.drawPath(_path, _painter..color = _getColorByIndex(i, def: false));
  }

  void _drawLine(Canvas canvas, Offset start, Offset end) {
    var _painter = this._painter
      ..color = Color(0xff35258A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    var _path = Path();
    _path.moveTo(start.dx, start.dy);
    _path.lineTo(end.dx, end.dy);
    canvas.drawPath(_path, _painter);
  }

  Color _getColorByIndex(int i, {bool def = false}) {
    if (def) return Color(0xffC4C4C4);
    return codes.contains(i) ? Color(0xff35258A) : Color(0xffC4C4C4);
  }

  Offset _getOffetByIndex(int i) {
    var _dxCode = _sizeCode * (i % _col + .5);
    var _dyCode = _sizeCode * ((i / _col).floor() + .5);
    var _offsetCode = Offset(_dxCode, _dyCode);
    return _offsetCode;
  }

  @override
  bool shouldRepaint(_LockScreenPainter oldDelegate) {
    return offset != oldDelegate.offset;
  }
}

class _Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width * 0.5, size.height * 0.2);
    double radius = size.width;
    var painter = Paint()
      ..style = PaintingStyle.fill
      ..color = Color(0xffC1DBBF).withOpacity(0.26);
    canvas.drawCircle(center, radius, painter);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return false;
  }
}
