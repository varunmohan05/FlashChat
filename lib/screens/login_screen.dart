import 'package:flutter/material.dart';
import 'package:flash_chat/button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/loading_Widget.dart';
import 'package:toast/toast.dart';
import 'dart:ui';

import 'sport_choices.dart';
class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String email;
  String password;
  bool visibility = false;


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
                    color: Colors.blueAccent,
                    onPressed: () async {
                      try {
                        setState(() {
                          visibility = true;
                        });
                        user =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (user != null)
                          Navigator.pushNamed(context, SportChoices.id);
                      } catch (e) {
                        Toast.show('${e.message}',context, duration: Toast.LENGTH_LONG,gravity: Toast.CENTER,backgroundColor: Colors.red,textColor: Colors.white,);

                      }
                      setState(() {
                        visibility = false;
                      });
                    },
                    heroTag: 'login',
                    label: 'Log In',
                  ),
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
          ),

        ],
      ),
    );
  }
}
