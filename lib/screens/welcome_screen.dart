import 'dart:ui';

import 'package:flash_chat/screens/sport_choices.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {


  AnimationController controller;
  Animation animation;
  Animation animationLogo;
  @override
  void initState() {

    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = ColorTween(begin: Colors.yellow[800], end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });

  }

//  @override
//  void dispose() {
//    controller.dispose();
//    super.dispose();
//  }
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        backgroundColor: animation.value,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 180,
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ColorizeAnimatedTextKit(
                        colors: [
                          Colors.black,
                          Colors.yellow[600],
                          Colors.yellow[800],
                          Colors.black,
                        ],
                        textAlign: TextAlign.start,
                        duration: Duration(seconds: 1),
                        text: ["FLASH CHAT"],
                        textStyle: TextStyle(
                            fontSize: 43.0,
                            color: Colors.black,
                            fontFamily: 'Kaushan',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              Button(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                label: 'Log In',
                heroTag: 'login',
              ),
              Button(
                color: Colors.lightBlueAccent,
                onPressed: () async{
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                label: 'Register',
                heroTag: 'register',
              ),
            ],
          ),
        ),
      ),

    ]);
  }
}
