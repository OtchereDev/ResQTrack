import 'dart:async';

import 'package:flutter/material.dart';

class VerificationCountDownProvider extends ChangeNotifier {
  late Timer _timer;
  int _start = 30;

  int get start => _start;

  changeTime(int value) {
    _start = value;
    notifyListeners();
    startTimer();
  }

  VerificationCountDownProvider() {
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
        } else {
          _start--;
          notifyListeners();
        }
      },
    );
  }

  void throwAway() {
    _timer.cancel();
    notifyListeners();
  }
}
