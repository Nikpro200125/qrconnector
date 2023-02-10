import 'dart:core';
import 'package:qrconnector/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'MainWindow.dart';
import 'constants.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: "/",
            builder: (BuildContext context, GoRouterState state) {
              return Material(child: MainScreen());
            },
          ),
          GoRoute(
            path: "/scan/:sessionId",
            builder: (BuildContext context, GoRouterState state) {
              return Material(
                child: Chat(code: state.params['sessionId'] ?? "Error Code!"),
              );
            },
            redirect: (context, state) async {
              var snapshot = await FirebaseDatabase.instance
                  .ref("qrs/${state.params['sessionId']}")
                  .get();
              if (!snapshot.exists) {
                return "/errorPage";
              }
              return null;
            },
          ),
          GoRoute(
            path: "/errorPage",
            builder: (BuildContext context, GoRouterState state) {
              return Material(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 200),
                      SelectableText(
                        "QR link not valid, please close the page and retry",
                        style: Const.textStyleError,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        errorBuilder: (context, state) {
          return Material(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 200),
                  SelectableText(
                    "Page not found",
                    style: Const.textStyleError,
                  ),
                  CupertinoButton(
                    child: Text('Home page'),
                    onPressed: () => context.go("/"),
                  )
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
