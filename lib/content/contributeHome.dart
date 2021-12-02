import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import '../main.dart';

class ContributeHome extends StatefulWidget {
  final Function pageNumberSelector;
  ContributeHome(this.pageNumberSelector, {Key? key}) : super(key: key);
  @override
  _ContributeHomeState createState() => _ContributeHomeState();
}

class _ContributeHomeState extends State<ContributeHome> {
  // myGrid(name, currentGoingWhatsAppNumber) {f
  //   return GestureDetector(
  //     child: Container(
  //       height: 100,
  //       width: MediaQuery.of(context).size.width * 0.5 - 20,
  //       decoration: BoxDecoration(
  //         color: Color.fromRGBO(255, 255, 255, 1),
  //         borderRadius: BorderRadius.circular(5),
  //         border: Border.all(
  //           color: Color.fromRGBO(255, 0, 0, 1),
  //           width: 1.5,
  //         ),
  //       ),
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: Icon(
  //               Icons.camera_alt_rounded,
  //               size: 36,
  //             ),
  //           ),
  //           Container(
  //             alignment: Alignment.bottomCenter,
  //             width: double.infinity,
  //             padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
  //             decoration: BoxDecoration(
  //               color: Color.fromRGBO(0, 0, 0, 0.5),
  //               borderRadius: BorderRadius.circular(3.5),
  //             ),
  //             child: Text(
  //               name,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontFamily: 'Signika',
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color.fromRGBO(255, 255, 255, 1),
  //                 letterSpacing: 1.5,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     onTap: () async {
  //       // print(widget.currentGoingWhatsApp);
  //       // print(widget.pageNumberSelector);
  //       // widget.currentGoingWhatsApp(currentGoingWhatsAppNumber);
  //       // widget.pageNumberSelector(2);
  //     },
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () => widget.pageNumberSelector(1),
  //     child: Column(
  //       children: [
  //         Expanded(
  //           child: GridView(
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               childAspectRatio: 1.25,
  //               crossAxisSpacing: 15,
  //               mainAxisSpacing: 15,
  //             ),
  //             padding: EdgeInsets.all(15),
  //             children: [
  //               // WhatsApp
  //               myGrid('Image', 0),
  //               // WhatsApp Bussiness
  //               myGrid('GIF', 1),
  //               // WhatsApp Clone
  //               myGrid('Video', 2),
  //               // WhatsApp Bussiness Clones
  //               myGrid('Dual WA-B', 3),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: (MediaQuery.of(context).size.height <= 400)
  //               ? 32
  //               : ((MediaQuery.of(context).size.height > 720) ? 90 : 50),
  //           alignment: Alignment.center,
  //           color: Color.fromRGBO(255, 255, 0, 1),
  //           child: Text(
  //             // '${countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(addItNow(match.group(0)?.codeUnitAt(0))))}',
  //             'ADS',
  //             style: TextStyle(
  //               fontSize: 24,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget.pageNumberSelector(1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Plugin initialization"),
            TextButton(
                child: Text("Start the Flutter background service"),
                onPressed: () {
                  Workmanager().initialize(
                    callbackDispatcher,
                    isInDebugMode: true,
                  );
                }),
            SizedBox(height: 16),
            Text("One Off Tasks (Android only)"),
            //This task runs once.
            //Most likely this will trigger immediately
            Container(
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                child: Text("Register OneOff Task"),
                onTap: () {
                  Workmanager().registerOneOffTask(
                    "1",
                    simpleTaskKey,
                    // inputData: <String, dynamic>{
                    //   'int': 1,
                    //   'bool': true,
                    //   'double': 1.0,
                    //   'string': 'string',
                    //   'array': [1, 2, 3],
                    // },
                  );
                },
              ),
            ),
            Container(
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                child: Text("Register rescheduled Task"),
                onTap: () {
                  Workmanager().registerOneOffTask(
                    "1-rescheduled",
                    rescheduledTaskKey,
                    inputData: <String, dynamic>{
                      'key': Random().nextInt(64000),
                    },
                  );
                },
              ),
            ),
            Container(
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                child: Text("Register failed Task"),
                onTap: () {
                  Workmanager().registerOneOffTask(
                    "1-failed",
                    failedTaskKey,
                  );
                },
              ),
            ),
            //This task runs once
            //This wait at least 10 seconds before running
            Container(
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                  child: Text("Register Delayed OneOff Task"),
                  onTap: () {
                    Workmanager().registerOneOffTask(
                      "2",
                      simpleDelayedTask,
                      initialDelay: Duration(seconds: 10),
                    );
                  }),
            ),
            SizedBox(height: 8),
            Text("Periodic Tasks (Android only)"),
            //This task runs periodically
            //It will wait at least 10 seconds before its first launch
            //Since we have not provided a frequency it will be the default 15 minutes
            Container(
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                  child: Text("Register Periodic Task"),
                  onTap: () {
                    Workmanager().registerPeriodicTask(
                      "3",
                      simplePeriodicTask,
                      initialDelay: Duration(seconds: 10),
                    );
                  }),
            ),
            //This task runs periodically
            //It will run about every hour
            Container(
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                  child: Text("Register 1 hour Periodic Task"),
                  onTap: () {
                    Workmanager().registerPeriodicTask(
                      "5",
                      simplePeriodic1HourTask,
                      frequency: Duration(hours: 1),
                    );
                  }),
            ),
            Container(
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                child: Text(
                  "Cancel All",
                ),
                onTap: () async {
                  await Workmanager().cancelAll();
                  print('Cancel all tasks completed');
                },
              ),
            ),
            GestureDetector(
              child: Container(
                color: Colors.amber,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(10),
                child: Text("pankaj"),
              ),
              onTap: () async {
                print("creating ............");

                copyImage(item, to) async {
                  // Here I have to put file name with extension like xyz.png
                  // In our case interpolation out already contains extension

                  var now = DateTime.now();
                  // 10 is added to every place to make sure that they are 2 digit long.
                  var td =
                      (int.parse(DateFormat('d').format(now)) + 10).toString();
                  var tM =
                      (int.parse(DateFormat('M').format(now)) + 10).toString();
                  var ty = DateFormat('y').format(now);
                  print(
                      "................############################### $item");
                  // print("############################################### $to");
                  print("$td $tM $ty");
                  var yeseterday = DateTime(now.year, now.month, now.day - 1);
                  var yd = (int.parse(DateFormat('d').format(yeseterday)) + 10)
                      .toString();
                  var yM = (int.parse(DateFormat('M').format(yeseterday)) + 10)
                      .toString();
                  var yy = DateFormat('y').format(yeseterday);
                  print("$yd $yM $yy");
                  var filenameToday =
                      "$to/$ty$tM$td${File(item).path.split('/').last}";
                  var filenameYesterday =
                      "$to/$yy$yM$yd${File(item).path.split('/').last}";
                  if (!(await Directory(filenameToday).exists() ||
                      await Directory(filenameYesterday).exists())) {
                    await File(item).copy(filenameToday);
                  }
                }

                refreshRecord(from, to) async {
                  // from - Donor Directory
                  // to - Recipient Directory
                  // This step creating a list of all item of Donor Directory
                  var itemList = Directory(from)
                      .listSync()
                      .map((item) => item.path)
                      .where((item) {
                    if (item.endsWith(".mp4")) {
                      return item.endsWith(".mp4");
                    } else {
                      return item.endsWith(".jpg");
                    }
                  }).toList(growable: false);

                  // After Donor Directory list is created then every element in the list processed ONE by ONE
                  for (var i = 0; i < itemList.length; i++) {
                    // Request for copy every items to target directory
                    // itemList[i] - Single Status file in seen /.Status folder (mp4/jpg)
                    // to - target Directory
                    copyImage(itemList[i], to);
                  }
                }

                activateRefreshRecord(from, to) async {
                  // from - Donor Directory
                  // to - Recipient Directory
                  // Check whether Storage Access permission is given or not
                  var status = Permission.storage.status;
                  // If permission given
                  if (await status.isGranted) {
                    // Check whether Donor directory exist or NOT, if not present then nothing to do.
                    if (await Directory(from).exists()) {
                      // If Donor directory exist, then
                      // Check whether Recepient directory exist or NOT
                      // If Recepient directory doesn't exist, FIRST create it then request SYNC process
                      if (await Directory(to).exists()) {
                        // Requesting SYNC process
                        refreshRecord(from, to);
                      } else {
                        // Create Recepient Directory
                        await Directory(to)
                            .create(recursive: true)
                            .then((value) {
                          refreshRecord(from, to);
                        });
                      }
                    }
                  } else {
                    // If NOT given, Request storage access permission
                    Permission.storage.request().then((value) async {
                      if (await Directory(from).exists()) {
                        if (await Directory(to).exists()) {
                          refreshRecord(from, to);
                        } else {
                          await Directory(to)
                              .create(recursive: true)
                              .then((value) {
                            refreshRecord(from, to);
                          });
                        }
                      }
                    });
                  }
                }

                // ********************* Concept ********************
                // activateRefreshRecord(Donor directory, Recipient directory)

                // Refresh WhatsApp
                await activateRefreshRecord(
                    "/storage/emulated/0/WhatsApp/Media/.Statuses",
                    "/storage/emulated/0/WA Assist/WhatsApp/cache/Media");

                // Refresh WhatsApp Business
                await activateRefreshRecord(
                    "/storage/emulated/0/WhatsApp Business/Media/.Statuses/",
                    "/storage/emulated/0/WA Assist/WhatsApp Business/cache/Media");

                // Refresh Dual WhatsApp
                await activateRefreshRecord(
                    "/storage/emulated/999/WhatsApp/Media/.Statuses",
                    "/storage/emulated/0/WA Assist/Dual WhatsApp/cache/Media");

                // Refresh Dual WhatsApp Business
                await activateRefreshRecord(
                    "/storage/emulated/999/WhatsApp Business/Media/.Statuses/",
                    "/storage/emulated/0/WA Assist/Dual WhatsApp Business/cache/Media");
              },
            )
          ],
        ),
      ),
    );
  }
}
