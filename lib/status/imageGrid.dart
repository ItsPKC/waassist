import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:waassist/status/viewImage.dart';

class ImageGrid extends StatefulWidget {
  final String _path;
  final Function pageNumberSelector, _showInterstitialAd;
  ImageGrid(this._path, this.pageNumberSelector, this._showInterstitialAd);

  @override
  _ImageGridState createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  var downloadPath = '/storage/emulated/0/Download';

  // folderSetUp() async {
  //   final folderName = "Download";
  //   final directoryPath = Directory("storage/emulated/0/$folderName");
  //   if (await directoryPath.exists()) {
  //   } else {
  //     print("not exist");
  //     await directoryPath.create();
  //   }
  //   downloadPath = '/storage/emulated/0/Download';
  // }

  copyImage(value) async {
    // for (int i = 0; i < imageList.length; i++) {
    //   print(File(imageList[i]));
    //   print(File(imageList[i]).path.split('/').last);
    //   // Filename based on number
    //   // await File(imageList[i]).copy('$path/filename$i.jpg');
    //   // Filename based on name
    //   await File(imageList[i])
    //       .copy('$path/${File(imageList[i]).path.split('/').last}.jpg');
    // }

    // Here I have to put file name with extension like xyz.png
    // In our case interpolation out already contains extension
    await File(value).copy('$downloadPath/${File(value).path.split('/').last}');
    print(File(value));
    print(File(value).path.split('/').last);

    print(File(value));
    print(await File('$downloadPath/${File(value).path.split('/').last}')
        .exists());
    setState(() {});
    // Please add any snack bar to confirm that download is completed
  }

  // Checking Whether image is downloaded or not
  Future<int> checkIfDownloaded(value) async {
    if (await File('$downloadPath/${File(value).path.split('/').last}')
        .exists()) {
      // print('${File(value).path.split('/').last} :: 1');
      return 1;
    } else {
      return 0;
    }
  }

  // Deleting Downloaded Image
  Future<void> deleteIfDownloaded(value) async {
    if (await File('$downloadPath/${File(value).path.split('/').last}')
        .exists()) {
      // print('${File(value).path.split('/').last} :: 1');
      await File('$downloadPath/${File(value).path.split('/').last}').delete();
    } else {}
    setState(() {});
  }

  // refresh Page
  Future<void> _refreshNow() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget._showInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // folderSetUp();
    var imageList = Directory(widget._path)
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".jpg"))
        .toList(growable: false);
    return WillPopScope(
      onWillPop: () {
        return widget.pageNumberSelector(3);
      },
      child: RefreshIndicator(
        onRefresh: () => _refreshNow(),
        child: (imageList.isNotEmpty)
            ? GridView.builder(
                itemCount: imageList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // childAspectRatio: (MediaQuery.of(context).size.width - 15) /
                  //     (MediaQuery.of(context).size.height - 15),
                  childAspectRatio: 9 / 16,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(255, 0, 0, 1),
                        // width: 1.5,
                      ),
                    ),
                    margin: (index % 2 == 0)
                        ? EdgeInsets.fromLTRB(10, 15, 5, 7.5)
                        : EdgeInsets.fromLTRB(5, 15, 10, 7.5),
                    child: Stack(
                      children: [
                        GestureDetector(
                          child: Container(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            alignment: Alignment.topCenter,
                            child: Image.file(
                              File(imageList[index]),
                              fit: BoxFit.contain,
                              // height: MediaQuery.of(context).size.height - 15,
                              // width: MediaQuery.of(context).size.width - 15,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewImage(
                                    imageList[index], imageList, index),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(255, 0, 0, 1),
                              ),
                              child: FutureBuilder(
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    print('Its date can be : ${snapshot.data}');
                                    if (snapshot.data == 0) {
                                      return Text(
                                        'Download',
                                        style: TextStyle(
                                          fontFamily: 'Signika',
                                          fontSize: 17,
                                          letterSpacing: 1,
                                        ),
                                      );
                                    } else {
                                      // return Text(
                                      //   'Done',
                                      //   style: TextStyle(
                                      //     fontFamily: 'Signika',
                                      //     fontSize: 17,
                                      //   ),
                                      // );
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              // color: Color.fromRGBO(0, 0, 0, 0.5),
                                              border: Border(
                                                  // right: BorderSide(
                                                  //   color:
                                                  //       Color.fromRGBO(255, 255, 255, 1),
                                                  //   width: 1,
                                                  // ),
                                                  // left: BorderSide(
                                                  //   color:
                                                  //       Color.fromRGBO(255, 255, 255, 1),
                                                  //   width: 1,
                                                  // ),
                                                  ),
                                            ),
                                            child: Icon(
                                              Icons.download_done_rounded,
                                              size: 28,
                                              color:
                                                  Color.fromRGBO(0, 255, 0, 1),
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                // color: Colors.amber,
                                                border: Border(
                                                    // right: BorderSide(
                                                    //   color: Color.fromRGBO(
                                                    //       255, 255, 255, 1),
                                                    //   width: 1,
                                                    // ),
                                                    // left: BorderSide(
                                                    //   color: Color.fromRGBO(
                                                    //       255, 255, 255, 1),
                                                    //   width: 1,
                                                    // ),
                                                    ),
                                              ),
                                              child: Icon(
                                                Icons.delete_forever_rounded,
                                                size: 28,
                                              ),
                                            ),
                                            onTap: () => deleteIfDownloaded(
                                                imageList[index]),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                  return Text(
                                    '---',
                                    style: TextStyle(
                                      fontFamily: 'Signika',
                                      fontSize: 17,
                                    ),
                                  );
                                },
                                future: checkIfDownloaded(imageList[index]),
                              ),
                              onPressed: () {
                                copyImage(imageList[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  "We are ready to LOAD,\nPlease check latest Status.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 120, 0, 1),
                    fontFamily: 'Signika',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    height: 2,
                  ),
                ),
              ),
      ),
    );
  }
}
