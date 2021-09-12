import 'package:crud/login.dart';
import 'package:crud/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'gopage.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: _initialization,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return Container();
    //     }
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         title: 'Flutter Demo',
    //         theme: ThemeData(
    //           primarySwatch: Colors.blue,
    //         ),
    //         home: Login(),
    //         routes: {
    //           "/login": (context) => Login(),
    //           "/register": (context) => Register(),
    //           "/home": (context) => Home(),
    //         },
    //       );
    //     }

    //     return Container();
    //   },
    // );

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: GoPage(),
            routes: {
              "/gopage": (context) => GoPage(),
              "/login": (context) => Login(),
              "/register": (context) => Register(),
              "/home": (context) => Home(),
            },
          );
        }

        return Container();
      },
    );
  }
}
