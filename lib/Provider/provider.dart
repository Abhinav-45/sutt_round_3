import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:sutt_round3/Data%20Storage%20and%20API%20Calls/riverpod.dart';
import 'dart:async';

import 'package:sutt_round3/Models/movie_details.dart';

class SplashScreenModel with ChangeNotifier {
  final GoRouter _router;

  SplashScreenModel(this._router);

  void initiateTask() async {
    await Future.delayed(Duration(seconds: 2));
    _router.go('/login');
  }
}
