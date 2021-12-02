import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:waassist/navigation/myHome.dart';
import 'package:waassist/services/ad_state.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    var _status = await Permission.storage.status;
    copyImage(item, to) async {
      // Here I have to put file name with extension like xyz.png
      // In our case interpolation out already contains extension

      var now = DateTime.now();
      var yeseterday = DateTime(now.year, now.month, now.day - 1);

      var todayCode = DateFormat('yyyyMMdd').format(now);
      var yesterdayCode = DateFormat('yyyyMMdd').format(yeseterday);

      var filenameToday = "$to/$todayCode${File(item).path.split('/').last}";
      var filenameYesterday =
          "$to/$yesterdayCode${File(item).path.split('/').last}";
      print("................############################### $item");
      print("................############################### $filenameToday");
      print(
          "................############################### $filenameYesterday");
      if (!(await Directory(filenameToday).exists() ||
          await Directory(filenameYesterday).exists())) {
        await File(item).copy(filenameToday);
      }
    }

    if(_status.isGranted){
      switch (task) {
      // case simpleTaskKey:
      //   print("$simpleTaskKey was executed. inputData = $inputData");
      //   final prefs = await SharedPreferences.getInstance();
      //   prefs.setBool("test", true);
      //   print("Bool from prefs: ${prefs.getBool("test")}");
      //   break;
      // case rescheduledTaskKey:
      //   final key = inputData!['key']!;
      //   final prefs = await SharedPreferences.getInstance();
      //   if (prefs.containsKey('unique-$key')) {
      //     print('has been running before, task is successful');
      //     return true;
      //   } else {
      //     await prefs.setBool('unique-$key', true);
      //     print('reschedule task');
      //     return false;
      //   }
      // case failedTaskKey:
      //   print('failed task');
      //   return Future.error('failed');
      // case simpleDelayedTask:
      //   print("$simpleDelayedTask was executed");
      //   break;
        case simplePeriodicTask:
          refreshRecord(from, to) async {
            // from - Donor Directory
            // to - Recipient Directory
            // This step creating a list of all item of Donor Directory
            var itemList =
            Directory(from).listSync().map((item) => item.path).where((item) {
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
                  await Directory(to).create(recursive: true).then((value) {
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
                    await Directory(to).create(recursive: true).then((value) {
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
              "/storage/emulated/0/.WA Assist/WhatsApp/cache/Media");

          // Refresh WhatsApp Business
          await activateRefreshRecord(
              "/storage/emulated/0/WhatsApp Business/Media/.Statuses/",
              "/storage/emulated/0/.WA Assist/WhatsApp Business/cache/Media");

          // Refresh Dual WhatsApp
          await activateRefreshRecord(
              "/storage/emulated/999/WhatsApp/Media/.Statuses",
              "/storage/emulated/0/.WA Assist/Dual WhatsApp/cache/Media");

          // Refresh Dual WhatsApp Business
          await activateRefreshRecord(
              "/storage/emulated/999/WhatsApp Business/Media/.Statuses/",
              "/storage/emulated/0/.WA Assist/Dual WhatsApp Business/cache/Media");

          print("$simplePeriodicTask was executed");
          break;
      // case simplePeriodic1HourTask:
      //   print("$simplePeriodic1HourTask was executed");
      //   break;
      // case Workmanager.iOSBackgroundTask:
      //   print("The iOS background fetch was triggered");
      //   Directory? tempDir = await getTemporaryDirectory();
      //   String? tempPath = tempDir.path;
      //   print(
      //       "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
      //   break;
      }
    }
    return Future.value(true);
  });
}

const simpleTaskKey = "simpleTask";
const rescheduledTaskKey = "rescheduledTask";
const failedTaskKey = "failedTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  // Background service Start
  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );

  // Workmanager().registerOneOffTask("1", "simpleTask");
  Workmanager().registerPeriodicTask(
    "2",
    "simplePeriodicTask",
    initialDelay: Duration(seconds: 20),
    // frequency: Duration(minutes: 15),
    // tag: "refreshStatusBackup",
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresBatteryNotLow: true,
      // requiresCharging: true,
      // requiresDeviceIdle: true,
      requiresStorageNotLow: true,
    ),
    // backoffPolicy: BackoffPolicy.exponential,
    // backoffPolicyDelay: Duration(seconds: 10),
  );
  // Background service End

  await FlutterDownloader.initialize(
    debug: true,
  );
  await Firebase.initializeApp();
  final adState = AdState(initFuture);

  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    Permission.storage.request();
    return MaterialApp(
      title: 'WA Assist',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: MyHome(),
    );
  }
}
