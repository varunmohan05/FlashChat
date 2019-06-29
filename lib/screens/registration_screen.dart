import 'package:flash_chat/screens/sport_choices.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/loading_Widget.dart';
import 'dart:ui';

import 'package:toast/toast.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool visibility = false;

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: visibility,
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        height: 210.0,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                      //Do something with the user input.
                    },
                    decoration: kFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                      //Do something with the user input.
                    },
                    decoration: kFieldDecoration.copyWith(
                      hintText: 'Enter your password',
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Button(
                    color: Colors.lightBlueAccent,
                    heroTag: 'register',
                    label: 'Register',
                    onPressed: () async {
                      setState(() {
                        visibility = true;
                      });

                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null)
                          Navigator.pushNamed(context, SportChoices.id);
                      } catch (e) {
                        Toast.show('${e.message}',context, duration: Toast.LENGTH_LONG,gravity: Toast.CENTER,backgroundColor: Colors.red,textColor: Colors.white,);
                      }
                      setState(() {
                        visibility = false;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Center(
                child: LoadingWidget.get(show: visibility),
              ),
            ),
          )
        ],
      ),
    );
  }
}
