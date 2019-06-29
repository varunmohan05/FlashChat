import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/intro_screen.dart';
import 'package:flash_chat/screens/sport_choices.dart';

void main() => runApp(FlashChat());
class FlashChat extends StatefulWidget {
  @override
  _FlashChatState createState() => _FlashChatState();
}

class _FlashChatState extends State<FlashChat> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool check;
  checkLoggedIn()async{
    bool temp;
    FirebaseUser user=await auth.currentUser();
      if(user!=null)
        temp= true;
      else
        temp= false;
    setState(() {
      check=temp;
    });

  }

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      routes: {
        IntroScreens.id: (context) => IntroScreens(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        SportChoices.id: (context) => SportChoices(),
      },
      initialRoute: check
          ? SportChoices.id
          : IntroScreens.id,
    );
  }
}

