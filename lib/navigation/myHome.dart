import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:waassist/Stickers/sticker.dart';
import 'package:waassist/backup/backup.dart';
import 'package:waassist/backup/backupHome.dart';
import 'package:waassist/content/contributeHome.dart';
import 'package:waassist/content/homeScreen.dart';
import 'package:waassist/content/trendingHome.dart';
import 'package:waassist/status/statusHome.dart';
import 'package:waassist/Stickers/stickerHome.dart';
import 'package:waassist/content/updateApp.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waassist/status/status.dart';
import 'package:waassist/services/ad_state.dart';
import 'myDrawer.dart';
import 'homeButtonSet.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

// Ad refresh karne ke liye dispose add karna hai sab me
// @BAND  kare button me

class _MyHomeState extends State<MyHome> {
  //  These 3 lines are used to check the forced crashlytics of application
  // void initState(){
  //   super.initState();
  //   FirebaseCrashlytics.instance.crash();
  // }
  BannerAd? _banner1;
  var isAdsAvailableB1 = false;
  int _numBanner1Attempts = 0;
  BannerAd? _banner2;
  var isAdsAvailableB2 = false;
  int _numBanner2Attempts = 0;
  // Ads
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context, listen: false);
    adState.initialization.then(
      (status) {
        if (mounted) {
          setState(
            () {
              _banner1 = BannerAd(
                adUnitId: adState.bannerAdUnitId1,
                // ignore: deprecated_member_use
                size: AdSize.smartBanner,
                request: AdRequest(),
                // listener: adState.adListener,
                listener: BannerAdListener(
                  // Called when an ad is successfully received.
                  onAdLoaded: (Ad ad) {
                    _numBanner1Attempts = 0;
                    if (isAdsAvailableB1 == false) {
                      // Not using setState may lead to not showing ads on load completed when it is not showing.
                      // But it may help to avoid many unusual stuff, mainly when
                      // some other widget are active over ads containing page/widget.

                      // setState(() {
                      isAdsAvailableB1 = true;
                      // });
                    }
                    print('Ads Loaded');
                  },
                  // Called when an ad request failed.
                  onAdFailedToLoad: (Ad ad, LoadAdError error) {
                    ad.dispose();
                    print('Ad failed to load: $error');
                    if (isAdsAvailableB1 == false) {
                      reloadBanner1() async {
                        if (_numBanner1Attempts <= 2) {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult != ConnectivityResult.none) {
                            print('Ads loading - Banner1 - With Internet');
                            if (_numBanner1Attempts == 0) {
                              _numBanner1Attempts += 1;
                              // attemp = 0 mean ads is not denied, so their is no point to wait
                              _banner1!.load();
                            } else {
                              Future.delayed(Duration(seconds: 3), () {
                                _numBanner1Attempts += 1;
                                _banner1!.load();
                              });
                            }
                          } else {
                            print('Ads loading - Banner1 - No Internet');
                            Future.delayed(Duration(seconds: 2), () {
                              reloadBanner1();
                            });
                          }
                        }
                      }

                      reloadBanner1();
                    }
                  },
                  // Called when an ad opens an overlay that covers the screen.
                  onAdOpened: (Ad ad) => print('Ad opened.'),
                  // Called when an ad removes an overlay that covers the screen.
                  onAdClosed: (Ad ad) => print('Ad closed.'),
                  // Called when an impression is recorded for a NativeAd.
                  onAdImpression: (ad) {
                    print('Ad impression.');
                  },
                ),
              );
              _banner1!.load();
              _banner2 = BannerAd(
                adUnitId: adState.bannerAdUnitId2,
                // ignore: deprecated_member_use
                size: AdSize.smartBanner,
                request: AdRequest(),
                // listener: adState.adListener,
                listener: BannerAdListener(
                  // Called when an ad is successfully received.
                  onAdLoaded: (Ad ad) {
                    _numBanner2Attempts = 0;
                    if (isAdsAvailableB2 == false) {
                      isAdsAvailableB2 = true;
                    }
                    print('Ads Loaded');
                  },
                  // Called when an ad request failed.
                  onAdFailedToLoad: (Ad ad, LoadAdError error) {
                    ad.dispose();
                    print('Ad failed to load: $error');
                    // _reloadAds();
                    if (isAdsAvailableB2 == false) {
                      reloadBanner2() async {
                        if (_numBanner2Attempts <= 2) {
                          var connectivityResult =
                          await (Connectivity().checkConnectivity());
                          if (connectivityResult != ConnectivityResult.none) {
                            print('Ads loading - Banner2 - With Internet');
                            if (_numBanner2Attempts == 0) {
                              _numBanner2Attempts += 1;
                              // attemp = 0 mean ads is not denied, so their is no point to wait
                              _banner2!.load();
                            } else {
                              Future.delayed(Duration(seconds: 3), () {
                                _numBanner2Attempts += 1;
                                _banner2!.load();
                              });
                            }
                          } else {
                            print('Ads loading - Banner2 - No Internet');
                            Future.delayed(Duration(seconds: 2), () {
                              reloadBanner2();
                            });
                          }
                        }
                      }

                      reloadBanner2();
                    }
                  },
                  // Called when an ad opens an overlay that covers the screen.
                  onAdOpened: (Ad ad) => print('Ad opened.'),
                  // Called when an ad removes an overlay that covers the screen.
                  onAdClosed: (Ad ad) => print('Ad closed.'),
                  // Called when an impression is recorded for a NativeAd.
                  onAdImpression: (ad) {
                    print('Ad impression.');
                  },
                ),
              );
              _banner2!.load();
            },
          );
        }
      },
    );
  }

  // Interstitial Ads
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  var adUnitIdList = [
    'ca-app-pub-4788716700673911/3024678698',
    'ca-app-pub-4788716700673911/9051030996',
    'ca-app-pub-4788716700673911/7792939585',
    'ca-app-pub-4788716700673911/9303146581',
  ];
  var adUnitIdIndex = 0;

  void _createInterstitialAd() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      InterstitialAd.load(
        adUnitId: adUnitIdList[adUnitIdIndex],
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('Int ads $ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= 3) {
              Future.delayed(Duration(seconds: 2), () {
                _createInterstitialAd();
              });
            }
          },
        ),
      );
      if (adUnitIdIndex == 3) {
        adUnitIdIndex = 0;
      } else {
        adUnitIdIndex += 1;
      }
    } else {
      if (_numInterstitialLoadAttempts <= 3) {
        print("Int ads recheck for load");
        Future.delayed(Duration(seconds: 2), () {
          _createInterstitialAd();
        });
      }
    }
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('Int ads onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('Int ads $ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Int ads $ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // End Ads

  var myDrawerKey = GlobalKey<ScaffoldState>();
  var pageNumber = 1;
  final _statusDirectory = [
    '/storage/emulated/0/WhatsApp/Media/.Statuses',
    '/storage/emulated/0/WhatsApp Business/Media/.Statuses/',
    '/storage/emulated/999/WhatsApp/Media/.Statuses',
    '/storage/emulated/999/WhatsApp Business/Media/.Statuses/',
  ];
  final _stickerDirectory = [
    '/storage/emulated/0/.WA Assist/cache/Media/Type1',
    '/storage/emulated/0/.WA Assist/cache/Media/Type2',
    '/storage/emulated/0/.WA Assist/cache/Media/Type3',
    '/storage/emulated/0/.WA Assist/cache/Media/Type4',
  ];
  final _backupDirectory = [
    "/storage/emulated/0/.WA Assist/WhatsApp/cache/Media",
    "/storage/emulated/0/.WA Assist/WhatsApp Business/cache/Media",
    "/storage/emulated/0/.WA Assist/Dual WhatsApp/cache/Media",
    "/storage/emulated/0/.WA Assist/Dual WhatsApp Business/cache/Media",
  ];
  var currentGoingWhatsAppNumber = 0;
  var currentGoingStickerFolderNumber = 0;
  var currentGoingBackupFolderNumber = 0;
  var currentFileType = ".jpg";

  void pageNumberSelector(asd) {
    setState(() {
      pageNumber = asd;
    });
  }

  void currentGoingWhatsApp(asd) {
    setState(() {
      currentGoingWhatsAppNumber = asd;
    });
  }

  void currentGoingStickerFolder(asd) {
    setState(() {
      currentGoingStickerFolderNumber = asd;
    });
  }

  void currentGoingBackup(asd) {
    setState(() {
      currentGoingBackupFolderNumber = asd;
    });
  }

  void chooseFileType(val) {
    setState(() {
      currentFileType = val;
    });
  }

  pager(fnc, number) {
    var pageList = [
      // We can't use vacent late variable. late var should have some data on its first use.
      (isAdsAvailableB1 == true)
          ? HomeScreen(fnc, isAdsAvailableB1, _banner1, _showInterstitialAd)
          : HomeScreen(fnc, isAdsAvailableB1, null, _showInterstitialAd),
      Status(fnc, _statusDirectory[currentGoingWhatsAppNumber], currentFileType,
          _showInterstitialAd),

      (isAdsAvailableB2 == true)
          ? StatusHome(fnc, currentGoingWhatsApp, chooseFileType,
              isAdsAvailableB2, _banner2)
          : StatusHome(fnc, currentGoingWhatsApp, chooseFileType,
              isAdsAvailableB2, null),
      Sticker(fnc, _stickerDirectory[currentGoingStickerFolderNumber],
          _showInterstitialAd),
      (isAdsAvailableB2 == true)
          ? StickerHome(
              fnc, currentGoingStickerFolder, isAdsAvailableB2, _banner2)
          : StickerHome(fnc, currentGoingStickerFolder, isAdsAvailableB2, null),
      TrendingHome(fnc, _showInterstitialAd, () {}),
      ContributeHome(fnc),
      Backup(fnc, _backupDirectory[currentGoingBackupFolderNumber],
          currentFileType, _showInterstitialAd),
      (isAdsAvailableB2 == true)
          ? BackupHome(fnc, currentGoingBackup, chooseFileType,
              isAdsAvailableB2, _banner2)
          : BackupHome(
              fnc, currentGoingBackup, chooseFileType, isAdsAvailableB2, null),
    ];
    return pageList[number];
  }

  @override
  void dispose() {
    super.dispose();
    _banner1!.dispose();
    _banner2!.dispose();
  }

  // For checking and Displaying Update Notification

  var isUpdateAvailable = false;

  final FirebaseFirestore _firestore = Fire().getInstance;

  checkForUpdate() async {
    // Query q = _firestore.collection('updateApp');
    // QuerySnapshot querySnapshot = await q.get();
    // DocumentSnapshot a = querySnapshot.docs[0];
    // var _updatedVersion = a.data() as Map;
    // var updatedVersion = _updatedVersion['version'];
    // var _notice = a.data() as Map;
    // var notice = _notice['notice'];

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    _firestore
        .collection('updateApp')
        .get()
        .then((QuerySnapshot querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach(
        (doc) {
          print('======================================== ${doc["version"]}');
          var updatedVersion = '${doc["version"]}';
          var notice = '${doc["notice"]}';
          print(
              'Its verion 00000000000000000000000000000 $updatedVersion $currentVersion');
          print('Its notice !!!!!!!!!!!!!!!!!!!!!!!!!!!!! $notice');
          if (updatedVersion != currentVersion) {
            // pageNumberSelector(1);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UpdateApp('${doc["date"]}', '${doc["notice"]}');
            }));
          }
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: myDrawerKey,
      drawer: MyDrawer(),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color.fromRGBO(0, 0, 0, 1),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                'WA Assist',
                style: TextStyle(
                  fontSize: 22,
                  // color: Color.fromRGBO(35, 15, 123, 1),
                  color: Color.fromRGBO(0, 0, 255, 1),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  fontFamily: 'Signika',
                  // fontStyle: FontStyle.italic,
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: SizedBox(
                  child: Image.asset(
                    'assets/logo_rounded.png',
                    width: 36,
                  ),
                ),
              ),
              onTap: () {
                setState(
                  () {
                    pageNumberSelector(1);
                  },
                );
              },
            ),

            // SizedBox(
            //   height: 20,
            //   child: CircleAvatar(
            //     radius: 10,
            //     backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            //     backgroundImage: AssetImage('assets/logo_rounded.png'),
            //   ),
            // ),
          ],
        ),

        // To create illusion for buttons
        leading: Button1(myDrawerKey),

        // leading: IconButton(
        //   icon: Icon(
        //     Icons.home_rounded,
        //     size: 32,
        //   ),
        //   onPressed: () {
        //     myDrawerKey.currentState.openDrawer();
        //   },
        // ),
        // actions: [
        // (pageNumber != 1)
        //     ? Button11(
        //         () {
        //           pageNumberSelector(1);
        //         },
        //       )
        //     : Button12(),
        // (pageNumber != 2 && pageNumber != 6)
        //     ? Button21(
        //         () {
        //           pageNumberSelector(2);
        //         },
        //       )
        //     : Button22(),
        // (pageNumber != 3 && pageNumber != 7)
        //     ? Button31(
        //         () {
        //           pageNumberSelector(3);
        //         },
        //       )
        //     : Button32(),
        // (pageNumber != 4)
        //     ? Button41(
        //         () {
        //           pageNumberSelector(4);
        //         },
        //       )
        //     : Button42(),
        // (pageNumber != 5)
        //     ? Button51(
        //         () {
        //           pageNumberSelector(5);
        //         },
        //       )
        //     : Button52(),
        // IconButton(
        //   icon: Icon(
        //     // Icons.autorenew_rounded,
        //     Icons.reset_tv_rounded,
        //     size: 34,
        //     color: Color.fromRGBO(255, 0, 0, 1),
        //   ),
        //   onPressed: () {
        //     setState(
        //       () {},
        //     );
        //   },
        // ),

        // IconButton(
        //   icon: Icon(
        //     Icons.notifications_active_rounded,
        //     // Icons.error_outline_rounded,
        //     // Icons.info_outline_rounded,
        //     // Icons.pending_rounded,
        //     // Icons.verified_rounded,
        //     // Icons.verified_user_rounded,
        //     // Icons.eco_rounded,
        //     size: 30,
        //   ),
        //   onPressed: () {},
        // ),
        // ],
      ),
      body: Container(
        // OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
        key: UniqueKey(),
        child: pager(pageNumberSelector, (pageNumber - 1)),
      ),
    );
  }
}
