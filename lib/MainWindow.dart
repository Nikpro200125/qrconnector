import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qrconnector/services.dart';

import 'QRPage.dart';
import 'Waiting.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late DatabaseReference newRef;
  late StreamSubscription<DatabaseEvent> connectionState;
  String url = "Error: Waiting for a link";
  AppState state = AppState.QR;

  @override
  Widget build(BuildContext context) {
    late Widget widget;

    if (state == AppState.QR) {
      widget = QRPage(link: url);
    } else {
      widget = WaitingAndOut(newRef: newRef, link: url);
    }

    return widget;
  }

  @override
  void initState() {
    super.initState();
    connectDB();
  }

  void connectDB() {
    try {
      var QrRef = FirebaseDatabase.instance.ref("qrs");
      newRef = QrRef.push();
      newRef.set({"connected": false}).then((value) {
        setState(() {
          url = Const.pathToSite + "/#/scan/" + newRef.key.toString();
        });
      });
      var connectionRef = newRef.child("connected");
      connectionState = connectionRef.onValue.listen((DatabaseEvent event) {
        setState(() {
          bool isConnected = (event.snapshot.value ?? false) as bool;
          if (isConnected) {
            state = AppState.Waiting;
            connectionState.cancel();
          }
        });
      });
    } on FirebaseException catch (e) {
      showSnackBar(
          context: context,
          textSnackBar: "Произошла ошибка",
          duration: Duration(seconds: 4));
      print(e.stackTrace);
    }
  }
}

enum AppState { QR, Waiting }
