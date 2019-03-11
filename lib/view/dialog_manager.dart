import 'package:authentication_mobile/blocs/authentication_bloc.dart';
import 'package:authentication_mobile/view/authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DialogManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DialogManagerState();
}

class DialogManagerState extends State<DialogManager> {
  bool _isDialogOpened = false;

  @override
  Widget build(BuildContext context) {
    var authenticationBloc = AuthenticationPageBlocProvider.of(context)
        .authenticationBloc;

    var phoneNumberInputKey = GlobalKey<FormState>();

    return StreamBuilder<PhoneNumberState>(
      stream: authenticationBloc.phoneNumberStateStream,

      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (snapshot.data == PhoneNumberState.ABSENT_PHONE_NUMBER
                || snapshot.data == PhoneNumberState.INCORRECT_PHONE_NUMBER) {
              if (!_isDialogOpened) {
                _isDialogOpened = true;
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: AlertDialog(
                          title: Text(
                              "Введіть номер телефону"
                          ),
                          content: Form(
                            key: phoneNumberInputKey,
                            child: TextFormField(
                              initialValue: "+380",
                              keyboardType: TextInputType.phone,
                              autofocus: true,
                              maxLength: 13,
                              validator: (input) {
                                if (!authenticationBloc.validatePhoneNumber(
                                    input)) {
                                  return "Невірно введений номер";
                                }
                              },
                              onSaved: (input) {
                                authenticationBloc.phoneNumberSink.add(input);
                              },
                              decoration: InputDecoration(
                                labelText: "+380XXXXXXXXX",
                                //prefixIcon: Icon(Icons.phone)
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Підвердити"),
                              onPressed: () {
                                if (phoneNumberInputKey.currentState.validate()) {
                                  phoneNumberInputKey.currentState.save();
                                }
                              },
                            )
                          ],
                        ),
                      );
                    }
                );
              }
            }
            else if (snapshot.data == PhoneNumberState.CORRECT_PHONE_NUMBER) {
              if (_isDialogOpened) {
                Navigator.of(context).pop();
                authenticationBloc.userStateActionSink.add(UserStateAction.UPDATE);
                _isDialogOpened = false;
              }
            }
          });
        }
        return Container();
      },
    );
  }
}