import 'dart:math';
import 'package:application/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/home.dart';
import 'package:flutter/material.dart';

class MyQuestions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyQuestionsState();
  }
}

class _MyQuestionsState extends State<MyQuestions> {
  var moneyd;
  @override
  void initState() {
    super.initState();
    moneyd = loadMoney();
  }
  static Future<String> loadMoney() async {
  String? pid = AuthRepository.instance().user?.uid;
  var v =
  (await FirebaseFirestore.instance.collection("avatars").doc(pid).get());
  print('load');
  var a = v['money'];
  var s = a.toString();
  print("ADADSDASD       " + a.toString());
  return s;
  }  final _questions = const [
    {
      'questionText': 'כשאני מפחד, קשה לי לנשום',
      'answers': [
        {'text': 'לעיתים קרובות', 'score': 2},
        {'text': 'לפעמים', 'score': 1},
        {'text': 'כמעט אף פעם', 'score': 0},
      ],
    },
    {
      'questionText': 'אני מודאג מאנשים שלא יחבבו אותי',
      'answers': [
        {'text': 'לעיתים קרובות', 'score': 2},
        {'text': 'לפעמים', 'score': 1},
        {'text': 'כמעט אף פעם', 'score': 0},
      ],
    },
    {
      'questionText': 'שאלה 3',
      'answers': [
        {'text': 'לעיתים קרובות', 'score': 2},
        {'text': 'לפעמים', 'score': 1},
        {'text': 'כמעט אף פעם', 'score': 0},
      ],
    },
    {
      'questionText': 'שאלה 4',
      'answers': [
        {'text': 'לעיתים קרובות', 'score': 2},
        {'text': 'לפעמים', 'score': 1},
        {'text': 'כמעט אף פעם', 'score': 0},
      ],
    },
  ];

  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score * (pow(10, _questionIndex).toInt());

    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    print(_questionIndex);
    if (_questionIndex < _questions.length) {
      print('We have more questions!');
    } else {
      print('No more questions!');
    }
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData(fontFamily: "Assistant"),
      home: Scaffold(
        backgroundColor: Colors.deepPurple,

        appBar:  AppBar(
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
            leading: Padding(padding:EdgeInsets.fromLTRB(0, 20, 0, 0), child:Builder(
              builder: (context) => GestureDetector(
                  onTap: () => {
                    if(_questionIndex>0)
                      setState(() => { _questionIndex-=1})
                  },
                  child: Icon(Icons.arrow_back, size: 40)),
            )),
            actions: <Widget>[
              GestureDetector(
              onTap: () => {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => Home()))
                  },
                  child: Padding(padding:EdgeInsets.fromLTRB(0, 20, 20, 0), child:Icon(Icons.home , size: 40,))),
              ])
         /* iconTheme: IconThemeData(color: Colors.black),
          leading: Builder(
            builder: (context) => GestureDetector(
                onTap: () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => Home()))
                    },
                child: Icon(Icons.arrow_back)),
          ),*/

        ,body: Stack(children:[ Positioned(
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


        Positioned(
          right: -100,
          top: height * 0.25,
child:Container(
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
                  ],
              )),
        ),

        Positioned(
            left: 20,
            top: MediaQuery.of(context).size.height * 0.12,
            child:Stack(
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

              ],
            )
                ),
        Positioned(
            left: 5,
            top: height * 0.45,
             child:Container(
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
                               ],
                )),
        ),
        Positioned(
            right: 50,
            bottom: 50,
             child:Container(
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

                  ],
                )),
        ),
        Positioned(bottom:20,left:20,child:Transform.rotate(angle: 180,child:Image.asset('images/skater.png'))),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: _questionIndex < _questions.length
              ? Quiz(
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex,
                  questions: _questions,
                ) //Quiz
              : Result(_totalScore, _resetQuiz),
        ),]) //Paddingk
      ), //Scaffold
      debugShowCheckedModeBanner: false,
    ); //MaterialApp
  }
}

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function answerQuestion;

  Quiz({
    required this.questions,
    required this.answerQuestion,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),

        ),
        child: Column(
          children: [
            Text(
              ' שאלה ${(questionIndex + 1).toString()} מתוך ${questions.length.toString()}\n\n\n\n\n',
              style:  GoogleFonts.assistant(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Question(
              questions[questionIndex]['questionText'].toString(),
            ), //Question
            ...(questions[questionIndex]['answers']
                    as List<Map<String, Object>>)
                .map((answer) {
              return Answer(() => answerQuestion(answer['score']),
                  answer['text'].toString());
            }).toList()
          ],
        )); //Column
  }
}

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        questionText + "\n\n",
        style: GoogleFonts.assistant(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ), //Text
    ); //Container
  }
}

class Answer extends StatelessWidget {
  final Function selectHandler;
  final String answerText;

  Answer(this.selectHandler, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: double.infinity,
      child: MaterialButton(
        minWidth: 300,
        height: 37,
        elevation: 0,
        disabledElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Color(0xff8ec3aa), width: 2)),
        color: Colors.deepPurple,
        splashColor: Colors.yellow[200],
        textColor: Colors.white,
        child: Text(answerText),
        onPressed: () {
          selectHandler();
        },
      ), //RaisedButton
    ); //Container
  }
}

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;

  Result(this.resultScore, this.resetHandler);

  //Remark Logic
  String get resultPhrase {
    String resultText;
    if (resultScore >= 41) {
      resultText = 'You are awesome!';
      print(resultScore);
    } else if (resultScore >= 31) {
      resultText = 'Pretty likeable!';
      print(resultScore);
    } else if (resultScore >= 21) {
      resultText = 'You need to work more!';
    } else if (resultScore >= 1) {
      resultText = 'You need to work hard!';
    } else {
      resultText = 'This is a poor score!';
      print(resultScore);
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Text
          Text(
            'תודה ששיתפת',
            style:  GoogleFonts.assistant(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ), //Text
          FlatButton(
            child: Text(
              'חזור למסך הבית',
              style:  GoogleFonts.assistant(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ), //Text
            onPressed: () => {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) => Home()))
            },
          ), //FlatButton
        ], //<Widget>[]
      ), //Column
    ); //Center
  }
}
