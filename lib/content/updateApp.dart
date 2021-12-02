import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateApp extends StatefulWidget {
  final String _date, _notice;
  UpdateApp(this._date, this._notice);
  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  Future<void> _makeRequestOutSide(url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          print('Can\'t lauch now !!!');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'WA Assist',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    letterSpacing: 1,
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ),
                content: Text(
                  'Failed to connect ...',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 1,
                    color: Color.fromRGBO(36, 14, 123, 1),
                  ),
                ),
                actions: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 0, 0, 1),
                        border: Border.all(
                          color: Color.fromRGBO(255, 0, 0, 1),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Close',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          letterSpacing: 2,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print(e);
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('WA Assist'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Icon(
                    Icons.network_check,
                    size: 32,
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ),
                Text(
                  'No Internet',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 1,
                    color: Color.fromRGBO(36, 14, 123, 1),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 0, 0, 1),
                    border: Border.all(
                      color: Color.fromRGBO(255, 0, 0, 1),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Close',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      letterSpacing: 2,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.3,
                  child: Image.asset('assets/logo_rounded.png'),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Update Available !!!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            'Updated on  :  ${widget._date}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            // '** Pankaj Kumar\n** I am from buxar.',
                            widget._notice,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Signika',
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(255, 0, 0, 1),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Not Now',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(255, 0, 0, 1),
                        ),
                        onPressed: () async {
                          var url =
                              "https://play.google.com/store/apps/details?id=com.icyindia.waassist";
                          _makeRequestOutSide(url);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
