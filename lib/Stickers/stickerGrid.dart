import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';

class StickerGrid extends StatefulWidget {
  final String _path;
  final Function pageNumberSelector, _showInterstitialAd;
  StickerGrid(this._path, this.pageNumberSelector, this._showInterstitialAd);

  @override
  _StickerGridState createState() => _StickerGridState();
}

class _StickerGridState extends State<StickerGrid> {
  // To show the tick if selected
  List<String> isSelected = [];
  // list of selected items
  List<String> selectedItems = [];
  var imageList = [];
  var downloadPath = '';
  folderSetUp(_thePath) async {
    // final folderName = "WA Assist/Download";
    // final directoryPath = Directory("storage/emulated/0/$folderName");
    final directoryPath = Directory(_thePath);
    if (await directoryPath.exists()) {
    } else {
      print("not exist");
      await directoryPath.create();
    }
    // downloadPath = '/storage/emulated/0/WA Assist/Download';
    downloadPath = _thePath;
  }

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

  var buildKey = '0';

  Future<void> _refreshNow() async {
    // selectedItems = [];
    // isSelected.fillRange(0, isSelected.length, '');
    // setState(() {});
    // setState with new build key to reload everything;
    setState(() {
      buildKey = (int.parse(buildKey) + 1).toString();
    });
  }

  _onBackPressed() {
    if (selectedItems.isNotEmpty) {
      selectedItems = [];
      isSelected.fillRange(0, isSelected.length, '');
      setState(() {});
    } else {
      widget.pageNumberSelector(5);
    }
  }

  final firebase_storage.Reference _ref =
      firebase_storage.FirebaseStorage.instance.ref();
  // List<DocumentSnapshot> _details = [];
  var _details = [];
  bool loadingDetails = true;
  final int _perPage = 40;
  bool gettingMoreDetails = false;
  bool moreDetailsAvailable = true;
  // DocumentSnapshot _lastDocument;
  // var _lastDocument;
  final ScrollController _scrollController = ScrollController();

  _getDetails() async {
    print('loading Details');
    // Query q = _firestore.collection("Featured Video List").limit(_perPage);

    if (loadingDetails == false) {
      setState(() {
        loadingDetails = true;
      });
    }
    // QuerySnapshot querySnapshot = await q.get();
    var result = await _ref.child('S1').list(
          firebase_storage.ListOptions(maxResults: _perPage),
        );
    _details = result.items;
    if (_details.isNotEmpty) {
      // _lastDocument = _details[_details.length - 1];
    }
    setState(() {
      loadingDetails = false;
      // To give the start where we left to set State
      // adsListLengthStart = adsListLength;
      // adsListLength = _details.length;
      // didChangeDependencies();
    });
    print(_details);
    // imageList = _details.map((item) => item.getDownloadURL());
    // for (int i = 0; i < _details.length; i++) {
    //   imageList[i] = await _details[i].getDownloadURL();
    //   print(imageList[i]);
    // }
    // ignore: avoid_function_literals_in_foreach_calls
    _details.forEach(
      (element) async {
        // imageList.add(await element.getDownloadURL());
        isSelected.add('');
        imageList.add('');
      },
    );
  }

  Future<String> _getDownloadLink(getLinkFrom, index) async {
    var temp = await getLinkFrom.getDownloadURL();
    imageList[index] = temp;
    return temp;
  }

  Future<void> _findPath(String imageUrl, index) async {
    await DefaultCacheManager().getSingleFile(imageUrl).then(
      (file) {
        if (isSelected[index] == '') {
          isSelected[index] = file.path;
        } else {
          isSelected[index] = '';
        }
        // To clear last list items and fill the refersh list
        selectedItems.clear();
        for (int i = 0; i < isSelected.length; i++) {
          if (isSelected[i] != '') {
            selectedItems.add(isSelected[i]);
          }
        }
        setState(() {
          isSelected[index] = isSelected[index];
        });
      },
    );
    // print('For Share = $selectedItems');
    // print(isSelected);
  }

  @override
  void initState() {
    super.initState();
    widget._showInterstitialAd();
    _getDetails();
  }

  // _getMoreDetails() async {
  //   if (moreDetailsAvailable == false) {
  //     // In case if no details are available
  //     return;
  //   }
  //   if (gettingMoreDetails == true) {
  //     // means we are on the way to laoding details and prevent
  //     // from multiple call before finishing any one
  //     return;
  //   }
  //   gettingMoreDetails = true;
  //   print('loading More Details');
  //   Query q = _firestore
  //       .collection("Featured Video List")
  //       .startAfterDocument(_lastDocument)
  //       .limit(_perPage);
  //   QuerySnapshot querySnapshot = await q.get();
  //   if (querySnapshot.docs.length < _perPage) {
  //     moreDetailsAvailable = false;
  //   }
  //   _details.addAll(querySnapshot.docs);
  //   if (_details.length != 0) {
  //     _lastDocument = _details[_details.length - 1];
  //   }
  //   setState(() {
  //     loadingDetails = false;
  //     // To give the start where we left to set State
  //     // adsListLengthStart = adsListLength;
  //     // adsListLength = _details.length;
  //     didChangeDependencies();
  //   });
  //   gettingMoreDetails = false;
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    folderSetUp(widget._path);
    // var imageList = Directory(widget._path)
    //     .listSync()
    //     .map((item) => item.path)
    //     .where((item) => item.endsWith(".jpg"))
    //     .toList(growable: false);
    return WillPopScope(
      key: Key(buildKey),
      onWillPop: () => _onBackPressed(),
      child: RefreshIndicator(
        onRefresh: () => _refreshNow(),
        child: Stack(
          children: [
            (_details.isNotEmpty)
                ? GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: _details.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
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
                        // index is item - 1
                        margin: (index % 3 == 0)
                            ? EdgeInsets.fromLTRB(10, 15, 5, 7.5)
                            : ((index % 3 == 1)
                                ? EdgeInsets.fromLTRB(5, 15, 5, 7.5)
                                : EdgeInsets.fromLTRB(5, 15, 10, 7.5)),
                        child: Stack(
                          children: [
                            GestureDetector(
                              child: Container(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                alignment: Alignment.topCenter,
                                // child: Image.network(
                                //   '${imageList[index]}',
                                //   fit: BoxFit.contain,
                                //   // height: MediaQuery.of(context).size.height - 15,
                                //   // width: MediaQuery.of(context).size.width - 15,
                                // ),
                                // child: CachedNetworkImage(
                                //   imageUrl: '${imageList[index]}',
                                //   imageBuilder: (context, imageProvider) =>
                                //       Container(
                                //     decoration: BoxDecoration(
                                //       image: DecorationImage(
                                //         image: imageProvider,
                                //         fit: BoxFit.contain,
                                //       ),
                                //     ),
                                //   ),
                                //   placeholder: (context, url) => Center(
                                //     child: Text(
                                //       '...',
                                //       style: TextStyle(
                                //         fontSize: 36,
                                //       ),
                                //     ),
                                //   ),
                                //   errorWidget: (context, url, error) =>
                                //       Image.asset(
                                //     'assets/not_found.png',
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                                child: FutureBuilder(
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return CachedNetworkImage(
                                        imageUrl: '${snapshot.data}',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            backgroundColor: Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/not_found.png',
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                    return Center(
                                        child: Text(
                                      '...',
                                      style: TextStyle(
                                        fontSize: 36,
                                      ),
                                    ));
                                  },
                                  future:
                                      _getDownloadLink(_details[index], index),
                                ),
                              ),
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         ViewImage(imageList[index]),
                                //   ),
                                // );{
                                _findPath(imageList[index], index);
                              },
                            ),
                            ((isSelected.isNotEmpty)
                                    ? (isSelected[index] != '')
                                    : false)
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: Color.fromRGBO(0, 0, 255, 1),
                                    ),
                                  )
                                : Container(),
                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: Container(
                            //     width: double.infinity,
                            //     padding: EdgeInsets.symmetric(
                            //       horizontal: 20,
                            //     ),
                            //     color: Color.fromRGBO(0, 0, 0, 0.25),
                            //     child: ElevatedButton(
                            //       style: ElevatedButton.styleFrom(
                            //         primary: Color.fromRGBO(255, 0, 0, 1),
                            //       ),
                            //       child: FutureBuilder(
                            //         builder: (context, snapshot) {
                            //           if (snapshot.data != null) {
                            //             print(
                            //                 'Its date can be : ${snapshot.data}');
                            //             if (snapshot.data == 0) {
                            //               return Text(
                            //                 'Download',
                            //                 style: TextStyle(
                            //                   fontFamily: 'Signika',
                            //                   fontSize: 17,
                            //                   letterSpacing: 1,
                            //                 ),
                            //               );
                            //             } else {
                            //               // return Text(
                            //               //   'Done',
                            //               //   style: TextStyle(
                            //               //     fontFamily: 'Signika',
                            //               //     fontSize: 17,
                            //               //   ),
                            //               // );
                            //               return Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                 children: [
                            //                   Container(
                            //                     decoration: BoxDecoration(
                            //                       // color: Color.fromRGBO(0, 0, 0, 0.5),
                            //                       border: Border(
                            //                           // right: BorderSide(
                            //                           //   color:
                            //                           //       Color.fromRGBO(255, 255, 255, 1),
                            //                           //   width: 1,
                            //                           // ),
                            //                           // left: BorderSide(
                            //                           //   color:
                            //                           //       Color.fromRGBO(255, 255, 255, 1),
                            //                           //   width: 1,
                            //                           // ),
                            //                           ),
                            //                     ),
                            //                     child: Icon(
                            //                       // Icons.download_done_rounded,
                            //                       Icons.check_circle_rounded,
                            //                       size: 28,
                            //                       color: Color.fromRGBO(
                            //                           0, 255, 0, 1),
                            //                     ),
                            //                   ),
                            //                   GestureDetector(
                            //                     child: Container(
                            //                       decoration: BoxDecoration(
                            //                         // color: Colors.amber,
                            //                         border: Border(
                            //                             // right: BorderSide(
                            //                             //   color: Color.fromRGBO(
                            //                             //       255, 255, 255, 1),
                            //                             //   width: 1,
                            //                             // ),
                            //                             // left: BorderSide(
                            //                             //   color: Color.fromRGBO(
                            //                             //       255, 255, 255, 1),
                            //                             //   width: 1,
                            //                             // ),
                            //                             ),
                            //                       ),
                            //                       child: Icon(
                            //                         Icons.delete_forever_rounded,
                            //                         size: 28,
                            //                       ),
                            //                     ),
                            //                     onTap: () {},
                            //                   ),
                            //                 ],
                            //               );
                            //             }
                            //           }
                            //           return Text(
                            //             '---',
                            //             style: TextStyle(
                            //               fontFamily: 'Signika',
                            //               fontSize: 17,
                            //             ),
                            //           );
                            //         },
                            //         future: checkIfDownloaded(imageList[index]),
                            //       ),
                            //       onPressed: () {
                            //         copyImage(imageList[index]);
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "Connecting ...",
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
            (selectedItems.isNotEmpty)
                ? Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 13),
                    // padding: EdgeInsets.all(5),
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Share.shareFiles(selectedItems);
                      },
                      icon: Icon(
                        Icons.send,
                        size: 32,
                      ),
                      label: Text(
                        '${selectedItems.length}',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 0, 0, 1),
                          fontFamily: 'Signika',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.25,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        primary: Color.fromRGBO(0, 0, 255, 1),
                        backgroundColor: Color.fromRGBO(255, 255, 0, 1),
                        side: BorderSide(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          width: 2,
                        ),
                        elevation: 5,
                        padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
