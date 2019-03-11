import 'package:authentication_mobile/model/log_info.dart';
import 'package:authentication_mobile/view/authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LogPage extends StatelessWidget {
  final Stream<List<LogInfo>> logStream;

  LogPage(this.logStream);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Відвідування",
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        body: StreamBuilder<List<LogInfo>>(
          stream: logStream,
          initialData: List(0),
          builder: (context, snapshot) {
            if (snapshot.data.length > 0) {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                    height: 0.0,
                ),
                primary: false,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var logInfo = snapshot.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          logInfo.totalTime,
                          style: TextStyle(
                            fontSize: 16
                          )
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                            logInfo.registrationDate,
                            style: TextStyle(
                              color: Colors.grey,
                                fontSize: 14
                            )
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            else {
              return Container();
            }
          }
        )
    );
  }
}