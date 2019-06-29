import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({this.color, this.onPressed, this.label, this.heroTag});
  final Color color;
  final Function onPressed;
  final String label;
  final String heroTag;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Hero(
        tag: heroTag,
        child: Container(

          child: Material(
            color: color,
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(

              onPressed: () {
                onPressed();
              },
              minWidth: 200.0,
              height: 42.0,
              child: Text(
                label,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
