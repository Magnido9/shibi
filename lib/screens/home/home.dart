library home;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Avatar/avatar.dart';


class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Text('cat'),
        floatingActionButton: FloatingActionButton(onPressed: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context) => Avatar()))
    }
    )
    );
  }
}
