// This screen is used to check whether following group is present or not.
// If present then transfer it to desired screen or show error message
// StatusHome -> Status -> imageGrid
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waassist/backup/backupImageGrid.dart';
import 'package:waassist/backup/backupVideoGrid.dart';
import 'package:waassist/permisson/storagePermissionDenied.dart';

class Backup extends StatefulWidget {
  final String _statusDirectory;
  final Function pageNumberSelector, _showInterstitialAd;
  final String currentFileType;
  Backup(this.pageNumberSelector, this._statusDirectory, this.currentFileType,
      this._showInterstitialAd);
  @override
  _BackupState createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  Future<int> checkStoragepermission() async {
    print(
        '.....................................................${widget._statusDirectory}');
    print('................................');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      setState(() {});
    }

    // To check whether directory exist or not
    var dirStatus = await Directory(widget._statusDirectory).exists();
    print(dirStatus);
    if (status.isGranted && dirStatus) {
      final directoryPath = Directory("storage/emulated/0/Download");
      if (await directoryPath.exists()) {
      } else {
        print("not exist");
        await directoryPath.create();
      }
      return 1;
    } else if (dirStatus == false) {
      return 2;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // color: Color.fromRGBO(255, 255, 0, 0.25),
    return WillPopScope(
      onWillPop: () => widget.pageNumberSelector(9),
      child: FutureBuilder(
        builder: (context, status) {
          if (status.data != null) {
            if (status.data == 1) {
              return (widget.currentFileType == ".jpg")
                  ? BackupImageGrid(
                      widget._statusDirectory,
                      widget.pageNumberSelector,
                      widget._showInterstitialAd,
                    )
                  : BackupVideoGrid(
                      widget._statusDirectory,
                      widget.pageNumberSelector,
                      widget._showInterstitialAd,
                    );
            } else if (status.data == 2) {
              return Center(
                child: Text(
                  // "Account logged out OR doesn't exist.",
                  "Oops!  No data found.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 0, 0, 1),
                    fontFamily: 'Signika',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    height: 1.5,
                  ),
                ),
              );
            } else {
              return StoragePermissionDenied(
                () => widget.pageNumberSelector(1),
              );
            }
          }
          return Container(
              margin: EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                ],
              ));
        },
        future: checkStoragepermission(),
      ),
    );
  }
}
