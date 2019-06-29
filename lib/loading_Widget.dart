import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget {

  static Widget get({bool show}) {
    if (show == true) {
      return SpinKitPulse(
        color: Colors.blueAccent,
        size: 60.0,
        duration: Duration(milliseconds: 300),
      );
    } else
      return Container(
        height: 0,
      );
  }
}
