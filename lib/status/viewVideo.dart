import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewVideo extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final _path;
  final _itemList;
  final _index;
  ViewVideo(this._path, this._itemList, this._index);

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  late VideoPlayerController _controller;
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
  void initState() {
    print("---------------------------------------");
    super.initState();
    _controller = VideoPlayerController.file(File(widget._path))
      // ..initialize().then((_) {
      //   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      //   setState(() {});
      // });
      // Below line is cousing issue, caought in debug console
      // ..addListener(() => setState(() {}))
      ..setVolume(1)
      ..setLooping(true)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  }

  @override
  Widget build(BuildContext context) {
    print("pppppppppppppppppppp");
    print(widget._path);
    print(widget._itemList);
    print(widget._index);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: SafeArea(
        child: GestureDetector(
          child: Container(
            color: Color.fromRGBO(255, 255, 255, 1),
            child: Stack(
              children: [
                InteractiveViewer(
                  key: UniqueKey(),
                  maxScale: 100,
                  child: Align(
                    alignment: Alignment.topCenter,
                    // child: Image.file(
                    //   File(widget._path),
                    //   fit: BoxFit.contain,
                    // ),
                    child: Center(
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : Container(),
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
                Center(
                  // As pause is not available, to show button video should not
                  // be playing and and it should be initailised
                  // *** None initialised show a flash of paly button button at every start.
                  child: (!_controller.value.isPlaying &&
                          _controller.value.isInitialized)
                      ? Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(
                            Icons.play_circle,
                            size: 90,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                        )
                      : Container(),
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
          onTap: () {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
            // Set State to show play/pause button
            setState(() {});
          },
          onLongPress: () {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
            // Set State to show play/pause button
            setState(() {});
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            print(details.primaryDelta);

            // Display next one
            // Avoid overflow request
            if (((widget._itemList).length - 1) > widget._index) {
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
                      _controller.pause();
                      _controller.dispose;
                      return ViewVideo(widget._itemList[widget._index + 1],
                          widget._itemList, widget._index + 1);
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
                      _controller.pause();
                      _controller.dispose;
                      return ViewVideo(widget._itemList[widget._index - 1],
                          widget._itemList, widget._index - 1);
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
    );
  }
}
