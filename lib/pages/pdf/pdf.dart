import 'package:admob_flutter/admob_flutter.dart';
import 'package:book/hard-data/monitize/admob.dart';
import 'package:book/model/store_book.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';

class PDFPage extends StatefulWidget {
  final StoreBook storedBook;
  PDFPage({this.storedBook});

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  bool _isFullScreen =
      true; //as onpage change call start at begining to set full screen to false

  PDFViewController _controller;
  int _currentPage = 1;
  String filePath;
  double totalPage = 2.0;
  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    filePath = join(
        widget.storedBook.downloadPath, widget.storedBook.downloadFileName);

    interstitialAd = AdmobInterstitial(
      adUnitId: getReadInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.loaded) interstitialAd.show();
        if (event == AdmobAdEvent.closed) {}
        if (event == AdmobAdEvent.failedToLoad) {
          print("Error code: ${args['errorCode']}");
        }
      },
    );

    interstitialAd.load();
    super.initState();
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                _isFullScreen = !_isFullScreen;
              });
            },
            child: Scaffold(
              body: PDFView(
                pageSnap: false,
                pageFling: false,
                autoSpacing: false,
                filePath: filePath,
                gestureRecognizers: [
                  Factory<OneSequenceGestureRecognizer>(() {
                    return VerticalDragGestureRecognizer();
                  }),
                ].toSet(),
                onPageChanged: (page, totalPage) {
                  if (page > 0)
                    setState(() {
                      _currentPage = page;
                    });
                },
                onViewCreated: (pdfViewController) {
                  _controller = pdfViewController;
                },
                onRender: (int totalPages) {
                  _controller.getPageCount().then((total) {
                    setState(() {
                      _isFullScreen = false;
                      totalPage = total.toDouble();
                    });
                  });
                },
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            top: _isFullScreen ? -70 : 35,
            left: 10,
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  )),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          AnimatedPositioned(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 500),
            bottom: _isFullScreen ? -70 : 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: FluidSlider(
                  sliderColor: Colors.black,
                  thumbColor: Colors.white,
                  value: _currentPage.toDouble(),
                  onChanged: (double newValue) {
                    setState(() {
                      _controller.setPage(newValue.toInt());
                      _currentPage = newValue.toInt();
                    });
                  },
                  min: 1,
                  max: totalPage == null ? 1 : totalPage - 1,
                )),
          )
        ],
      ),
    );
  }
}
