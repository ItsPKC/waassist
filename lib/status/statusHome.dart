import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StatusHome extends StatefulWidget {
  final Function pageNumberSelector, currentGoingWhatsApp, chooseFileType;
  final isAdsAvailable;
  final _banner;
  StatusHome(
    this.pageNumberSelector,
    this.currentGoingWhatsApp,
    this.chooseFileType,
    this.isAdsAvailable,
    this._banner,
  );
  @override
  _StatusHomeState createState() => _StatusHomeState();
}

class _StatusHomeState extends State<StatusHome> {
  tapWarningDialog(name, currentGoingWhatsAppNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 255, 1),
              fontFamily: "Signika",
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.25,
            ),
          ),
          content: Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Icon(
                  Icons.network_check,
                  size: 32,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            // Container(
            //   width: double.infinity,
            //   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            //   child: TextButton(
            //     child: Text('Close'),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   ),
            // ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: GestureDetector(
                    // Container is used to expand touch area
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.image_rounded,
                        size: 28,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.currentGoingWhatsApp(currentGoingWhatsAppNumber);
                      widget.pageNumberSelector(2);
                      widget.chooseFileType(".jpg");
                    },
                  ),
                ),
                Container(
                  color: Color.fromRGBO(12, 217, 2, 1),
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  height: 28,
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.video_collection_rounded,
                        size: 27,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.currentGoingWhatsApp(currentGoingWhatsAppNumber);
                      widget.chooseFileType(".mp4");
                      widget.pageNumberSelector(2);
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  myGrid(name, icon, currentGoingWhatsAppNumber) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5 - 20,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(3.5),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Expanded(
          //   child: Icon(
          //     Icons.camera_alt_rounded,
          //     size: 36,
          //   ),
          // ),

          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
            decoration: BoxDecoration(
              // color: Color.fromRGBO(12, 217, 2, 1),
              borderRadius: BorderRadius.circular(3.5),
              gradient: LinearGradient(
                colors: const [
                  Color.fromRGBO(12, 217, 2, 0.8),
                  Color.fromRGBO(12, 217, 2, 1)
                  // Color.fromRGBO(255, 0, 0, 0.8),
                  // Color.fromRGBO(255, 0, 0, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Signika',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(255, 255, 255, 1),
                letterSpacing: 1.5,
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.175,
                color: Colors.white,
                child: Image.asset(
                  icon,
                ),
              ),
              onTap: () {
                tapWarningDialog(name, currentGoingWhatsAppNumber);
              },
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(12, 217, 2, 0.075),
              borderRadius: BorderRadius.circular(3.5),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: GestureDetector(
                    // Container is used to expand touch area
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.image_rounded,
                        size: 28,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    ),
                    onTap: () {
                      widget.currentGoingWhatsApp(currentGoingWhatsAppNumber);
                      widget.pageNumberSelector(2);
                      widget.chooseFileType(".jpg");
                    },
                  ),
                ),
                Container(
                  color: Color.fromRGBO(12, 217, 2, 1),
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  height: 28,
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.video_collection_rounded,
                        size: 27,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    ),
                    onTap: () {
                      widget.currentGoingWhatsApp(currentGoingWhatsAppNumber);
                      widget.pageNumberSelector(2);
                      widget.chooseFileType(".mp4");
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("---------------------------------${widget.isAdsAvailable}");
    return WillPopScope(
      onWillPop: () => widget.pageNumberSelector(1),
      child: Column(
        children: [
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 15,
                mainAxisSpacing: 30,
              ),
              padding: EdgeInsets.fromLTRB(15, 30, 15, 5),
              children: [
                // WhatsApp
                myGrid('WhatsApp', 'assets/wa.png', 0),
                // WhatsApp Business
                myGrid('WA Business', 'assets/wab.png', 1),
                // WhatsApp Clone
                myGrid('Dual WA', 'assets/dwa.png', 2),
                // WhatsApp Business Clone
                myGrid('Dual WA-B', 'assets/dwab.png', 3),
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
                return (widget.isAdsAvailable == true)
                    ? AdWidget(
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
      ),
    );
  }
}
