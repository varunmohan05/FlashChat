import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/location_details.dart';
import 'package:flash_chat/screens/sport_choices.dart';
import 'package:toast/toast.dart';

String email;
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
final FirebaseMessaging fcm = FirebaseMessaging();

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Color selectedColor = SportChoices
      .sportColors[SportChoices.sportNames.indexOf(SportChoices.selectedSport)];
  final _auth = FirebaseAuth.instance;
  String messages;
  String messageText;
  final messageTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Toast.show('new message from ${message['notification']['body']}',context, duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM,backgroundColor: SportChoices.sportColors[
        SportChoices.sportNames.indexOf(SportChoices.selectedSport)],textColor: Colors.white,);

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        SportChoices();
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        String name=message['data']['from'];
        name=String.fromCharCodes(name.runes.toList().reversed);
        name=name.substring(0,name.indexOf('/',0));
        name=name.substring(0,name.indexOf('_',0));
        name=String.fromCharCodes(name.runes.toList().reversed);
        SportChoices.selectedSport=name;
        Navigator.pop(context);
        Navigator.pushNamed(context, ChatScreen.id);
        print(name);
      },
    );
    getCurrentUser();
  }

  void getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
      email=loggedInUser.email;
      print(loggedInUser.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(59),
          child: ChatScreenAppBar(sportName: SportChoices.selectedSport)),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    border: Border.all(
                      color: selectedColor,
                      width: 1.5,
                    )),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 30,
                      child: TextField(
                        controller: messageTextController,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          messageTextController.clear();
                          try {
                            _firestore
                                .collection(
                                '${LocationDetails.locality}_${SportChoices
                                    .selectedSport}')
                                .add({
                              'text': messageText,
                              'sender': loggedInUser.email
                            });
                          }
                          catch(e)
                          {Toast.show('${e.message}',context, duration: Toast.LENGTH_LONG,gravity: Toast.CENTER,backgroundColor: Colors.red,textColor: Colors.white,);}
                          messageText = '';
                        },
                        child: Text(
                          'Send',
                          style: TextStyle(
                              color: selectedColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Raleway'),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 0,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreenAppBar extends StatefulWidget {
  ChatScreenAppBar({this.sportName});
  final String sportName;

  @override
  _ChatScreenAppBarState createState() => _ChatScreenAppBarState();
}

class _ChatScreenAppBarState extends State<ChatScreenAppBar> {
  bool state=false;
  FirebaseUser user;
  DocumentSnapshot doc;
  DocumentReference docRef;
  void getSubscriptionState()async{
    docRef=_firestore.collection('Subscriptions').document('$email');
    doc= await docRef.get();

      if (doc.data!=null) {
        bool temp=doc.data['${LocationDetails.locality}_${SportChoices
            .selectedSport}'];
        setState(() {
          if(temp!=null)
          state = temp;
        });
      }
    }


  @override
  void initState() {
    try {
      getSubscriptionState();
    }
    catch(e)
    {
      Toast.show('${e.message}',context, duration: Toast.LENGTH_LONG,gravity: Toast.CENTER,backgroundColor: Colors.red,textColor: Colors.white,);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        Switch(
            value: state,
            onChanged: (value) async {
              try {
                if (value == true) {
                  setState(() {
                    state = value;
                  });
                    if(doc.data!=null)
                      {
                        await docRef.updateData({'${LocationDetails.locality}_${SportChoices
                            .selectedSport}': true});
                      }
                    else
                      {
                       await docRef.setData({'${LocationDetails.locality}_${SportChoices
                            .selectedSport}': true});
                      }
                  fcm.subscribeToTopic(
                      '${LocationDetails.locality}_${SportChoices
                          .selectedSport}');
                  Toast.show('Subscribed to notification alers : ${SportChoices
                      .selectedSport}', context, duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM,
                    backgroundColor: SportChoices.sportColors[
                    SportChoices.sportNames.indexOf(
                        SportChoices.selectedSport)],
                    textColor: Colors.white,);

                }
                else {
                  setState(() {
                    state = value;
                  });
                  if(doc.data!=null)
                  {
                    await docRef.updateData({'${LocationDetails.locality}_${SportChoices
                        .selectedSport}': false});
                  }
                  else
                  {
                    await docRef.setData({'${LocationDetails.locality}_${SportChoices
                        .selectedSport}': false});
                  }
                  fcm.unsubscribeFromTopic(
                      '${LocationDetails.locality}_${SportChoices
                          .selectedSport}');
                  Toast.show(
                    'Unsubscribed from notification alers : ${SportChoices
                        .selectedSport}', context, duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM,
                    backgroundColor: SportChoices.sportColors[
                    SportChoices.sportNames.indexOf(
                        SportChoices.selectedSport)],
                    textColor: Colors.white,);

                }
              }
              catch(e)
              {
                Toast.show('${e.message}',context, duration: Toast.LENGTH_LONG,gravity: Toast.CENTER,backgroundColor: Colors.red,textColor: Colors.white,);
                setState(() {
                  state = !value;
                });
              }
            }),
        SizedBox(
        width: 17,
        ),
        CircleAvatar(
          backgroundImage: AssetImage('images/${widget.sportName}.png'),
          radius: 28,
          backgroundColor: Colors.white70,
        )
      ],
      title: Align(
          alignment: Alignment.centerRight,
          child: Text('${widget.sportName}',
              style: TextStyle(
                  fontFamily: 'Raleway', color: Colors.white, fontSize: 30))),
      backgroundColor: SportChoices.sportColors[
          SportChoices.sportNames.indexOf(SportChoices.selectedSport)],
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(

        stream: _firestore
            .collection(
                '${LocationDetails.locality}_${SportChoices.selectedSport}')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Expanded(child: Center(child: CircularProgressIndicator()));
          }

          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];
            messageBubbles.add(MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: messageSender == loggedInUser.email,
            ));
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});

  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${sender.substring(0, sender.indexOf('@'))}',
            style: TextStyle(
                color: SportChoices.sportColors[SportChoices.sportNames
                    .indexOf(SportChoices.selectedSport)]),
          ),
          Material(
              color: isMe ? Colors.lightBlueAccent : Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                child: Text('$text',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Raleway')),
              )),
        ],
      ),
    );
  }
}
