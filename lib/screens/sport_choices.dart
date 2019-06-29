import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';
import 'chat_screen.dart';
import 'package:flash_chat/location_details.dart';
import 'package:flash_chat/location_loading.dart';
import 'package:flash_chat/loading_Widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SportChoices extends StatefulWidget {
  static String selectedSport;
  static List<String> sportNames = [
    'Tennis',
    'Tabletennis',
    'Icehockey',
    'Squash',
    'Volleyball',
    'Rugby',
    'Basketball',
    'Badminton',
    'Football',
    'Cricket'
  ];
  static List<Color> sportColors = [
    Colors.yellow[800],
    Colors.green,
    Colors.deepPurple,
    Colors.pink,
    Colors.yellow[800],
    Colors.grey,
    Colors.red,
    Colors.deepOrange,
    Colors.blueGrey,
    Colors.pink
  ];
  static final String id = 'sport_choices';
  @override
  _SportChoicesState createState() => _SportChoicesState();
}

class _SportChoicesState extends State<SportChoices> {
  var location = new Location();
  bool locationServiceStatus;
  bool locationStatus = true;
  bool locationDialog = true;
  bool permissions;
  bool visibility = false;
  int index_copy;
  void welcomeToast() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser user = await auth.currentUser();
      Toast.show(
        'Welcome ${user.email}!',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
      );
    } catch (e) {
      Toast.show(
        '${e.message}',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> checkLocationStatus(int index) async {
    permissions = await location.hasPermission();
    locationServiceStatus = await location.serviceEnabled();
    setState(() {
      if (permissions == false || locationServiceStatus == false) {
        locationDialog = false;
        locationStatus = false;
        index_copy = index;
        throw 'Need to enable location';
      }
    });

    if (locationStatus == true) {
      LocationDetails.locality = await LoadingLocation().getLocation();
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                title: Center(
                    child: new Text('Leave this page?')),
                titleTextStyle:TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold),
                titlePadding: EdgeInsets.all(15),
                content: Text('Signing out would reset your subscriptions'),
                contentTextStyle: TextStyle(fontSize: 16,color: Colors.black54),
                contentPadding: EdgeInsets.all(20),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                        )),
                  ),
                  FlatButton(
                    onPressed: () async {
                      Toast.show(
                        'All subscribtions cleared',
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      FirebaseAuth _auth = FirebaseAuth.instance;
                      FirebaseUser user = await _auth.currentUser();
                      String email = await user.email;
                      Firestore _firestore = Firestore.instance;
                      try {
                        await _firestore
                            .collection('Subscriptions')
                            .document('$email')
                            .delete();
                      } catch (e) {
                        Toast.show(
                          '${e.message}',
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                      await _auth.signOut();
                      Navigator.popUntil(context, ModalRoute.withName(WelcomeScreen.id));
                    },
                    child: new Text('Sign Out',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 18)),
                  ),
                  FlatButton(
                      onPressed: () => SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop'),
                      child: new Text('Exit',
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 18))),
                ],
              ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    welcomeToast();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AbsorbPointer(
        absorbing: visibility,
        child: Stack(children: <Widget>[
          Scaffold(
            backgroundColor: Color(0xFF1F2432),
            body: Swiper(
              layout: SwiperLayout.DEFAULT,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        setState(() {
                          visibility = true;
                        });
                        await checkLocationStatus(index);
                        SportChoices.selectedSport =
                            SportChoices.sportNames[index];
                        if (SportChoices.selectedSport != null &&
                            locationStatus == true &&
                            LocationDetails.locality != null)
                          Navigator.pushNamed(context, ChatScreen.id);
                      } catch (e) {
                        Toast.show(
                          '$e',
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.TOP,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                        print(e);
                      }
                      setState(() {
                        visibility = false;
                      });
                    },
                    child: Material(
                        shadowColor: Colors.white70,
                        elevation: 7,
                        borderRadius: BorderRadius.circular(50),
                        color: SportChoices.sportColors[index],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                'images/${SportChoices.sportNames[index]}.png',
                                color: Colors.white,
                              ),
                              Text('${SportChoices.sportNames[index]}',
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        )),
                  ),
                );
              },
              fade: 0,
              viewportFraction: 0.5,
              scale: 0.4,
              itemCount: 10,
              onIndexChanged: (index) {
                print(index);
              },
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
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Center(
                child: locationDialog
                    ? Container(
                        height: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset('images/LocationLoading.gif'),
                                Text(
                                  'Enable Location!',
                                  style: TextStyle(
                                      fontFamily: 'Kaushan',
                                      color: Colors.white,
                                      fontSize: 25),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RaisedButton(
                                  elevation: 10,
                                  onPressed: () async {
                                    permissions =
                                        await location.requestPermission();
                                    locationServiceStatus =
                                        await location.requestService();
                                    if (permissions == true &&
                                        locationServiceStatus == true) {
                                      setState(() {
                                        locationDialog = true;
                                        locationStatus = true;
                                      });
                                    } else
                                      setState(() {
                                        locationDialog = true;
                                      });
                                  },
                                  child: Text(
                                    'Okay',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.blueAccent,
                                )
                              ],
                            ),
                          ),
                          borderRadius: BorderRadius.circular(40),
                          color: Color(0xFFE05A5A),
                        ),
                      ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
