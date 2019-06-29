import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'welcome_screen.dart';

class IntroScreens extends StatelessWidget {
  static final String id='intro_screen';
  final pages = [
    PageViewModel(
      pageColor: const Color(0xFF1F2432),
      iconImageAssetPath: 'images/logo.png',
      iconColor: null,
      bubbleBackgroundColor: Colors.red,
      body: Text(
        'Instant message delivery powered by Google\'s Firestore',style: TextStyle(fontFamily: 'DancingScript',fontSize: 28),
      ),
      title: Text('Flash Chat',style: TextStyle(fontFamily: 'Kaushan',fontWeight:FontWeight.bold ),),
      mainImage: Image.asset(
        'images/logo.png',
        alignment: Alignment.bottomCenter,
      ),
    ),
    PageViewModel(
      pageColor: Colors.blueGrey,
      iconImageAssetPath: 'images/planicon.png',
      iconColor: null,
      bubbleBackgroundColor: Colors.green,
      body: Text(
        'Can\'t get people to play your favourite sport? \nPlan out games with strangers around you in a ⚡',style: TextStyle(fontFamily: 'DancingScript',fontSize: 28)
      ),
      title: Text('Flash Plan',style: TextStyle(fontFamily: 'Kaushan',fontWeight:FontWeight.bold )),
      mainImage: Image.asset(
        'images/plan.png',
        alignment: Alignment.bottomCenter,
      ),
    ),
    PageViewModel(
      pageColor: Colors.deepPurple[900],
      iconImageAssetPath: 'images/Badminton.png',
      iconColor: null,
      bubbleBackgroundColor: Colors.yellow[600],
      body: Text(
        'Enjoy your game with your new flash buddies 🥳',style: TextStyle(fontFamily: 'DancingScript',fontSize: 28)
      ),
      title: Text('Flash Play',style: TextStyle(fontFamily: 'Kaushan',fontWeight:FontWeight.bold )),
      mainImage: Image.asset(
        'images/play.png',
        alignment: Alignment.bottomCenter,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroViewsFlutter(
        pages,
        onTapDoneButton: () {
          Navigator.pushNamed(context, WelcomeScreen.id);
        } //MaterialPageRoute

        ,
        pageButtonTextStyles: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    );
  }
}
