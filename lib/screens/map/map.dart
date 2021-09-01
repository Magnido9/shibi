library home;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Avatar/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../login/login.dart';
import '../../services/auth_services.dart';




class MapPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body:SingleChildScrollView(child: Image.network("https://static.wikia.nocookie.net/candy-crush-saga/images/5/5c/World_1.jpg/revision/latest?cb=20160623022238")),


      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
        icon: Icon(Icons.error),

    label: 'Calls',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.camera),
    label: 'Camera',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.chat),
    label: 'Chats',
    ),
    ]
    )
    );
  }
}



