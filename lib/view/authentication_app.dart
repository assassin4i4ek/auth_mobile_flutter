import 'package:authentication_mobile/blocs/authentication_bloc.dart';
import 'package:authentication_mobile/view/authentication_page.dart';
import 'package:authentication_mobile/view/log_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Authentication Mobile",
        theme: ThemeData(
          primaryColor: Color(0xFF0DB7C4),
          primaryColorDark: Color(0xFF1198A1),
          accentColor: Color(0xFFF15B5A),
          primaryColorBrightness: Brightness.dark
        ),
        home: AuthenticationPage(),
    );
  }
}