import 'dart:io';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final _path;
  final _imageList;
  final _index;
  ViewImage(this._path, this._imageList, this._index);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  var downloadPath = '/storage/emulated/0/Download';

  copyImage(value) async {
    // Here I have to put file name with extension like xyz.png
    // In our case interpolation out already contains extension
    await File(value).copy('$downloadPath/${File(value).path.split('/').last}');
    print(File(value));
    print(File(value).path.split('/').last);

    print(File(value));
    print(await File('$downloadPath/${File(value).path.split('/').last}')
        .exists());
    setState(() {});
  }

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

  // _closeImage() {
  //   Navigator.of(context).pop();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
          child: GestureDetector(
            child: Container(
              color: Color.fromRGBO(255, 255, 255, 1),
              child: Stack(
                children: [
                  InteractiveViewer(
                    key: UniqueKey(),
                    maxScale: 100,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.file(
                        File(widget._path),
                        fit: BoxFit.contain,
                        // height: MediaQuery.of(context).size.height - 15,
                        // width: MediaQuery.of(context).size.width - 15,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
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
                                    fontSize: 20,
                                    letterSpacing: 1,
                                  ),
                                );
                              } else {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // color: Colors.amber,
                                          border: Border(
                                            right: BorderSide(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.download_done_rounded,
                                          size: 28,
                                          color: Color.fromRGBO(0, 255, 0, 1),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.amber,
                                            border: Border(
                                              left: BorderSide(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.delete_forever_rounded,
                                            size: 28,
                                          ),
                                        ),
                                        onTap: () =>
                                            deleteIfDownloaded(widget._path),
                                      ),
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
                          future: checkIfDownloaded(widget._path),
                        ),
                        onPressed: () {
                          copyImage(widget._path);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // onVerticalDragUpdate: (DragUpdateDetails details) {
            //   print(details.primaryDelta);
            //   if (details.primaryDelta as double > 30 ||
            //       details.primaryDelta as double < -30) {
            //     Navigator.of(context).pop();
            //   }
            // },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              print(details.primaryDelta);

              // Display next one
              // Avoid overflow request
              if (((widget._imageList).length - 1) > widget._index) {
                if (details.primaryDelta as double < -5) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 250),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secAnimation,
                          Widget child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                      // .push stack another contenet on the top while .pushReplacement replace current content
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secAnimation) {
                        return ViewImage(widget._imageList[widget._index + 1],
                            widget._imageList, widget._index + 1);
                      },
                    ),
                  );
                }
              }
              // Display previous one
              // To avoid going beyond index zero
              if (widget._index != 0) {
                if (details.primaryDelta as double >= 5) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 250),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secAnimation,
                          Widget child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secAnimation) {
                        return ViewImage(widget._imageList[widget._index - 1],
                            widget._imageList, widget._index - 1);
                      },
                    ),
                  );
                }
              }
            },
            onDoubleTap: () {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
