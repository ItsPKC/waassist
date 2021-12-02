// This screen is used to check whether following group is present or not.
// If present then transfer it to desired screen or show error message
// check of any UPDATES available.
// StatusHome -> Sticker -> imageGrid

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waassist/Stickers/stickerGrid.dart';
import 'package:waassist/permisson/storagePermissionDenied.dart';

class Sticker extends StatefulWidget {
  final String _stickerDirectory;
  final Function pageNumberSelector, _showInterstitialAd;
  Sticker(this.pageNumberSelector, this._stickerDirectory,
      this._showInterstitialAd);
  @override
  _StickerState createState() => _StickerState();
}

class _StickerState extends State<Sticker> {
  Future<int> checkStoragepermission() async {
    print(
        '.....................................................${widget._stickerDirectory}');
    print('................................');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      setState(() {});
    }
    // To check whether directory exist or not

    // var dirStatus = await Directory(widget._statusDirectory).exists();
    // print(dirStatus);
    if (status.isGranted) {
      print(widget._stickerDirectory);
      if (!(await Directory(widget._stickerDirectory).exists())) {
        await Directory(widget._stickerDirectory).create(recursive: true);
      }
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // color: Color.fromRGBO(255, 255, 0, 0.25),
    return FutureBuilder(
      builder: (context, status) {
        if (status.data != null) {
          if (status.data == 1) {
            print('Sticker is ready ///////////////////////////////////');
            return StickerGrid(
              widget._stickerDirectory,
              widget.pageNumberSelector,
              widget._showInterstitialAd,
            );
          }
          // else if (status.data == 2) {
          //   return Center(
          //     child: Text(
          //       "Account logged out OR doesn't exist.",
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         color: Color.fromRGBO(255, 0, 0, 1),
          //         fontFamily: 'Signika',
          //         fontSize: 20,
          //         fontWeight: FontWeight.w600,
          //         letterSpacing: 1,
          //         height: 1.5,
          //       ),
          //     ),
          //   );
          // }
          else {
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
    );
  }
}
