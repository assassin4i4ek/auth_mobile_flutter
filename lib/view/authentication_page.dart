import 'package:authentication_mobile/view/alert.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  AuthenticationPage({this.title: ""}) : super();

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            title,
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white,),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AlertWidget(),
                ],
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "Номер телефону:",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54
                    ),
                  ),
                  margin: EdgeInsets.only(right: 8),
                ),
                Text(
                  "+380964337876",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: RaisedButton(
                child: Text(
                  "Зареєструвати вхід".toUpperCase(),
                  style: TextStyle(
                      fontSize: 16.0
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                disabledColor: Colors.black12,
                onPressed: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}