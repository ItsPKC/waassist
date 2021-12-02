import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waassist/content/trendingHome.dart';

class HomeScreen extends StatefulWidget {
  final Function pageNumberSelector, _showInterstitialAd;
  late final bool isAdsAvailable;
  final _banner;
  HomeScreen(this.pageNumberSelector, this.isAdsAvailable, this._banner,
      this._showInterstitialAd,
      {Key? key})
      : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // It is implement to avoid refresh when other widget is on the top of it
  // Otherwise banner ads will cause error in rendering
  var shouldShowHomeScreenAds = true;
  showHomeScreenAds() {
    shouldShowHomeScreenAds = !shouldShowHomeScreenAds;
    return shouldShowHomeScreenAds;
  }

  var contactNumber = '';
  var _countryCode = '91';

  // For Flag in ADS

  // var countryCode = 'us';
  // addItNow(asd) {
  //   return (asd + 127397);
  // }

  myGrid(icon, name, fnc) {
    return GestureDetector(
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width * 0.5 - 20,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(5),
          // border: Border.all(
          //   color: Color.fromRGBO(255, 0, 0, 1),
          //   width: 1.5,
          // ),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: icon,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 0, 0, 1),
                borderRadius: BorderRadius.circular(3.5),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: fnc,
    );
  }

  Future<void> _makeRequest(url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          print('Can\'t lauch now !!!');
        }
      } catch (e) {
        print(e);
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: FittedBox(
              child: Text(
                'No Internet connection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  letterSpacing: 1,
                  color: Color.fromRGBO(255, 0, 0, 1),
                ),
              ),
            ),
            actions: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 255, 255, 0.25),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 45) * 0.3,
                      alignment: Alignment.center,
                      // color: Color.fromRGBO(0, 0, 0, 0.5),
                      margin: EdgeInsets.fromLTRB(15, 0, 7.5, 0),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(255, 0, 0, 1),
                              width: 1.25,
                            ),
                          ),
                          height: 55,
                          width: (MediaQuery.of(context).size.width - 45) * 0.3,
                          alignment: Alignment.center,
                          child: Text(
                            '+ $_countryCode',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                            // exclude: <String>['KN', 'MF'],
                            //Optional. Shows phone code before the country name.
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              print('Select country: ${country.displayName}');
                              _countryCode = country.phoneCode;
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 45) * 0.7,
                      height: 55,
                      decoration: BoxDecoration(
                        // color: Colors.tealAccent,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color.fromRGBO(255, 0, 0, 1),
                          width: 1.25,
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(7.5, 0, 15, 0),
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'\d')),
                          ],
                          onChanged: (value) {
                            contactNumber = value;
                          },
                          // maxLength: 15,
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.left,
                          cursorColor: Colors.red,
                          decoration: InputDecoration(
                            hintText: 'Any Contact',
                            hintStyle: TextStyle(
                              fontFamily: 'Signika',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            // contentPadding: EdgeInsets.fromLTRB(15, 20, 11, 0),
                            isCollapsed: true,
                            isDense: false,
                          ),
                          keyboardType: TextInputType.number,
                          toolbarOptions: ToolbarOptions(
                            copy: true,
                            cut: true,
                            paste: true,
                            selectAll: true,
                          ),
                          cursorWidth: 3,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(255, 0, 0, 1),
                    ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      // width: MediaQuery.of(context).size.width * 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Chat Now',
                            style: TextStyle(
                              fontFamily: 'Signika',
                              fontSize: 23,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.send_rounded,
                            size: 36,
                          ),
                        ],
                      ),
                    ),
                    // onPressed: () async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url',
                    onPressed: () {
                      // Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => OpenWAredirect(contactNumber),
                      //   ),
                      // );
                      // We can use below to launch with or without phone number
                      // _makeRequest('https://api.whatsapp.com/send/?phone=$_countryCode$contactNumber&text=Hi...&app_absent=0');
                      // It's enough
                      // _makeRequest('whatsapp://send/?phone=$_countryCode$contactNumber&text=Hi...&app_absent=0');
                      // It will be best if we multi-language
                      _makeRequest(Uri.encodeFull(
                          'whatsapp://send/?phone=$_countryCode$contactNumber&text=Hii ...  ${String.fromCharCode(0x1F917)} ${String.fromCharCode(0x1F917)} ${String.fromCharCode(0x1F917)}&app_absent=0'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            children: [
              myGrid(
                Icon(
                  // Icons.download_for_offline_rounded,
                  Icons.file_download_outlined,
                  size: MediaQuery.of(context).size.width * 0.15,
                  color: Color.fromRGBO(36, 14, 123, 1),
                ),
                'Status Manager',
                () {
                  widget.pageNumberSelector(3);
                },
              ),
              myGrid(
                Icon(
                  Icons.account_balance_rounded,
                  // Icons.trending_up_rounded,
                  size: MediaQuery.of(context).size.width * 0.15,
                  color: Color.fromRGBO(36, 14, 123, 1),
                ),
                'Status Bank',
                () {
                  // widget.pageNumberSelector(6);

                  // It is added to prevent next ads insertition when this widget is not on the top
                  showHomeScreenAds();
                  print('_____________________________________________');
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TrendingHome(widget.pageNumberSelector,
                        widget._showInterstitialAd, showHomeScreenAds);
                  }));
                },
              ),
              myGrid(
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: Image.asset('assets/cat1.webp'),
                ),
                'Cat Sticker',
                () {
                  widget.pageNumberSelector(5);
                },
              ),
              myGrid(
                  Icon(
                    Icons.archive_rounded,
                    // Icons.cloud_download_rounded,
                    size: MediaQuery.of(context).size.width * 0.15,
                    color: Color.fromRGBO(36, 14, 123, 1),
                  ),
                  'BackUp', () {
                widget.pageNumberSelector(9);
              }),
              // myGrid(
              //   Icon(
              //     // Icons.camera_alt_rounded,
              //     Icons.backup_rounded,
              //     // Icons.download_rounded,
              //     // Icons.trending_up_rounded,
              //     size: 60,
              //     color: Colors.blue,
              //   ),
              //   'Contribute',
              //   () {
              //     widget.pageNumberSelector(7);
              //   },
              // ),
            ],
          ),
        ),
        Container(
          height: (MediaQuery.of(context).size.height <= 400)
              ? 32
              : ((MediaQuery.of(context).size.height > 720) ? 90 : 50),
          alignment: Alignment.center,
          color: Color.fromRGBO(235, 235, 235, 1),
          // '${countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(addItNow(match.group(0)?.codeUnitAt(0))))}',
          child: Builder(
            builder: (context) {
              return (widget.isAdsAvailable == true &&
                      shouldShowHomeScreenAds == true)
                  ? AdWidget(
                      // This key is only in this , I don't know why
                      // its giving already present in other widget.
                      ad: widget._banner,
                    )
                  : Container(
                      alignment: Alignment.center,
                      // margin: EdgeInsets.all(20),
                      child: Text(
                        'Ads',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 255, 1),
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
