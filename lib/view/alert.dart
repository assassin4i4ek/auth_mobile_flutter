import 'package:authentication_mobile/blocs/authentication_bloc.dart';
import 'package:authentication_mobile/view/authentication_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final Map<AlertType, Icon> _icons = {
    AlertType.INFO: Icon(
      Icons.info_outline,
      color: Color(0xFF099EFF),
      size: 200,
    ),
    AlertType.ERROR: Icon(
      Icons.error_outline,
      color: Color(0xFFF15B5A),
      size: 200,
    ),
    AlertType.SUCCESS: Icon(
      Icons.check_circle_outline,
      color: Color(0xFF4CAF50),
      size: 200,
    )
  };

  @override
  Widget build(BuildContext context) {
    var authenticationBloc = AuthenticationPageBlocProvider.of(context)
        .authenticationBloc;

    return StreamBuilder<AlertMessage>(
      stream: authenticationBloc.messages,
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          return Column(
            children: <Widget>[
              _icons[(snapshot.data as AlertMessage).alertType],
              SizedBox(height: 16),
              Text(
                  (snapshot.data as AlertMessage).message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54
                  )
              ),
            ],
          );
        }
        else {
          return Container();
        }
      },
    );
  }
}