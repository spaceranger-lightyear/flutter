import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:artpia/assets/config.dart';
import 'package:artpia/pages/interface.dart';
import 'package:artpia/pages/auth/authentic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ArtpiaConfig.auth = FirebaseAuth.instance;
  ArtpiaConfig.sharedPreferences = await SharedPreferences.getInstance();
  ArtpiaConfig.firestore = Firestore.instance;
  runApp(Artpia());
}

class Artpia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displaySplash();
  }

  displaySplash() {
    Timer(new Duration(seconds: 3), () async {
      if (await ArtpiaConfig.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (context) => InterfacePage());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (context) => AuthenticPage());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: Image.asset(
            'lib/assets/logo_path',
            scale: 0.5,
          ),
        ),
      ),
    );
  }
}
