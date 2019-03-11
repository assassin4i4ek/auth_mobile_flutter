import 'package:authentication_mobile/blocs/authentication_bloc.dart';
import 'package:authentication_mobile/view/alert.dart';
import 'package:authentication_mobile/view/dialog_manager.dart';
import 'package:authentication_mobile/view/log_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class AuthenticationPageBlocProvider extends InheritedWidget {
  AuthenticationPageBlocProvider(
      this.authenticationBloc,
      Widget child): super(child: child);

  final AuthenticationBloc authenticationBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static AuthenticationPageBlocProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AuthenticationPageBlocProvider);
  }
}

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage() : super();

  @override
  State<StatefulWidget> createState() => AuthenticationPageState();
}

class AuthenticationPageState extends State<AuthenticationPage> {
  final AuthenticationBloc _authenticationBloc = AuthenticationBloc();

  @override
  void dispose() {
    super.dispose();
    _authenticationBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Мобільна реєстрація",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white,),
              onPressed: () =>
                  _authenticationBloc.userStateActionSink.add(
                      UserStateAction.UPDATE),
            ),
            IconButton(
                icon: Icon(Icons.assignment, color: Colors.white,),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => LogPage(_authenticationBloc.userLog)
                      )
                  );
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    _authenticationBloc.userStateActionSink
                        .add(UserStateAction.VIEW_LOG);
                  });
                }
            )
          ],
        ),
        body: AuthenticationPageBlocProvider(
          _authenticationBloc,
          Center(
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
                    StreamBuilder(
                      initialData: "",
                      stream: _authenticationBloc.phoneNumberStream,
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: StreamBuilder<bool>(
                      stream: _authenticationBloc.userStateStream,
                      initialData: null,
                      builder: (context, snapshot) {
                        return RaisedButton(
                          child: Text(
                            snapshot.data == true ?
                            "" "Зареєструвати вихід".toUpperCase()
                                : "Зареєструвати вхід".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16.0
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          disabledColor: Colors.black12,
                          onPressed: () =>
                          snapshot.data != null ?
                          _authenticationBloc.userStateActionSink
                              .add(UserStateAction.SWITCH)
                              : null
                          ,
                        );
                      }
                  ),
                ),
                DialogManager(),
              ],
            ),
          ),
        )
    );
  }
}