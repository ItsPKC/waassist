import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StickerHome extends StatefulWidget {
  final Function pageNumberSelector, currentGoingStickerFolder;
  final isAdsAvailable;
  final _banner;
  StickerHome(this.pageNumberSelector, this.currentGoingStickerFolder,
      this.isAdsAvailable, this._banner);

  @override
  _StickerHomeState createState() => _StickerHomeState();
}

class _StickerHomeState extends State<StickerHome> {
  myGrid(name, currentGoingStickerFolderNumber) {
    return GestureDetector(
      child: Container(
        height: (MediaQuery.of(context).size.width - 20) * 0.3 + 36,
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
              color: Colors.black,
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Container(
              height: 36,
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.75),
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
            Expanded(
              child: Row(
                children: [
                  // Expanded(
                  //   child: Container(
                  //     margin: EdgeInsets.all(4),
                  //     child: Image.asset('assets/fileImage.png'),
                  //   ),
                  // ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(4),
                      child: Image.asset('assets/cat1.webp'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(4),
                      child: Image.asset('assets/cat2.webp'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(4),
                      child: Image.asset('assets/cat3.webp'),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.navigate_next_rounded,
                        // Icons.next_week_rounded,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // print(widget.currentGoingWhatsApp);
        // print(widget.pageNumberSelector);
        widget.currentGoingStickerFolder(currentGoingStickerFolderNumber);
        widget.pageNumberSelector(4);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget.pageNumberSelector(1),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
              children: [
                // WhatsApp
                myGrid('Cat Expression Cartoon', 0),
                // WhatsApp Bussiness
                // myGrid('WA Bussiness', 1),
              ],
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height <= 400)
                ? 32
                : ((MediaQuery.of(context).size.height > 720) ? 90 : 50),
            alignment: Alignment.center,
            color: Color.fromRGBO(235, 235, 235, 1),
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
