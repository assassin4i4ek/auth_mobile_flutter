import 'package:flutter/material.dart';

class HelloWorldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello World",

      home: HelloWorldWidget(title: "Hello World Demo",),
    );
  }
}

class HelloWorldWidget extends StatefulWidget {
  HelloWorldWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HelloWorldState createState() => HelloWorldState();
}

class HelloWorldState extends State<HelloWorldWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title)
      ),
      body: Center(
        child: Text(
            "Hello World!!!"
        ),
      ),
    );
  }
}

