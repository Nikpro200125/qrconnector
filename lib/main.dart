import 'dart:core';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qrconnector/chat/chat.dart';

import 'firebase_options.dart';
import 'host/hostWindow.dart';
import 'services.dart';

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
                child: Chat(code: state.params['sessionId']!),
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
                      const SizedBox(height: 200),
                      const SelectableText(
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
                  const SizedBox(height: 200),
                  const SelectableText(
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
