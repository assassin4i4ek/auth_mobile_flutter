import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AlertWidget extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => AlertWidgetState();
}

enum _AlertType {
  SUCCESS, INFO, ERROR
}

class AlertWidgetState extends State<AlertWidget> {
  Map<_AlertType, Icon> _icons = {
    _AlertType.INFO: Icon(
      Icons.info_outline,
      color: Color(0xFF099EFF),
      size: 200,
    ),
    _AlertType.ERROR: Icon(
      Icons.error_outline,
      color: Color(0xFFF15B5A),
      size: 200,
    ),
    _AlertType.SUCCESS: Icon(
      Icons.check_circle_outline,
      color: Color(0xFF4CAF50),
      size: 200,
    )
  };

  String _message = "";
  Icon _icon = Icon(
    Icons.error_outline,
    color: Color(0x00000000),
    size: 200,
  );

  success(String message) {
    setState(() {
      _message = message;
      _icon = _icons[_AlertType.SUCCESS];
    });
  }

  info(String message) {
    setState(() {
      _message = message;
      _icon = _icons[_AlertType.INFO];
    });
  }

  error(String message) {
    setState(() {
      _message = message;
      _icon = _icons[_AlertType.ERROR];
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        _icon,
        Html(
            data:_message,
            defaultTextStyle: TextStyle(
                fontSize: 18,
                color: Colors.black54
            )
        ),
      ],
    );
  }
}