import 'dart:convert';
import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:book/database/db_helper.dart';
import 'package:book/hard-data/monitize/admob.dart';
import 'package:book/model/book.dart';
import 'package:book/model/store_book.dart';
import 'package:book/scoped-model/download_manager.dart';
import 'package:book/util/card/book.dart';
import 'package:book/util/color/hex_code.dart';
import 'package:book/util/scroll/noglow.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:scoped_model/scoped_model.dart';

class BookPage extends StatefulWidget {
  final Book book;
  final String heroTag;

  const BookPage({Key key, this.book, @required this.heroTag})
      : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String id;
  int type;
  String downloadUrl;
  String imageUrl;
  String title;
  String author; //later author urls add var
  String series; //later series url add var
  String extention;
  String size;
  String isbns;
  String page;
  String language;
  String edition;
  String yearPublised;
  String publication;
  String endpoint;
  String desc = '';
  int optionsStatus = 0; // 0 unknown //1 read now // 2 manager  //3 download
  // DFPInterstitialAd _interstitialAd;
  AdmobInterstitial interstitialAd;
  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.loaded) interstitialAd.show();
        if (event == AdmobAdEvent.closed) {}
        if (event == AdmobAdEvent.failedToLoad) {
          print("Error code: ${args['errorCode']}");
        }
      },
    );

    interstitialAd.load();

    id = widget.book.id;
    type = widget.book.type;
    downloadUrl = widget.book.downloadUrl;
    imageUrl = widget.book.imageUrl;
    title = widget.book.title;
    author = widget.book.author;
    series = widget.book.series;
    extention = widget.book.extention;
    size = widget.book.size;
    isbns = widget.book.isbns;
    page = widget.book.page;
    language = widget.book.language;
    edition = widget.book.edition;
    yearPublised = widget.book.yearPublised;
    publication = widget.book.publication;
    endpoint = widget.book.endpoint;

    if (type == 1) fetchDesc(endpoint, id);

    checkIfDownloaded();
    super.initState();
  }

  Future checkIfDownloaded() async {
    DBHealper dbHealper = DBHealper();

    dbHealper.getBook(id.trim(), type).then((StoreBook book) {
      if (book != null) {
        // 1 downloaded and in db 2 in progress mean downloading
        if (book.downloaded == 0) {
          setState(() {
            optionsStatus = 2;
          });
        } else {
          setState(() {
            optionsStatus = 1;
          });
        }
      } else {
        setState(() {
          optionsStatus = 3; //download not present
          print(optionsStatus);
        });
      }
    });
  }

  @override
  void setState(f) {
    if (mounted) {
      super.setState(f);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    interstitialAd.dispose();
    // _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DownloadManagerModel>(
      builder:
          (BuildContext context, Widget child, DownloadManagerModel model) {
        return Scaffold(
          extendBody: true,
          bottomNavigationBar: buildBottomBar(model),
          body: Stack(
            children: <Widget>[
              buildBackground(),
              buildBookPage(context),
              buildBackButton(context),
            ],
          ),
        );
      },
    );
  }

  Container buildBottomBar(DownloadManagerModel model) {
    return Container(
      height: 80,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    print(optionsStatus);
                    if (optionsStatus == 1) {
                      //dowloded and in db
                      //give read now Navigation

                      Navigator.pushNamed(context, '/library/');
                    }
                    if (optionsStatus == 2) {
                      // in progress to download
                      // give manage Navigation

                      Navigator.pushNamed(context, '/library/');
                    }

                    if (optionsStatus == 3) {
                      print("Download pressed");
                      model.download(widget.book); //dend to manage page
                      setState(() {
                        optionsStatus = 2;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(10))),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: double.infinity,
                    child: Text(
                      optionsStatus == 0
                          ? "UNKNOWN"
                          : optionsStatus == 1
                              ? "READ NOW"
                              : optionsStatus == 2 ? "MANAGE" : "DOWNLOAD",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
            ),
          )
        ],
      ),
      color: Colors.transparent,
    );
  }

  ScrollConfiguration buildBookPage(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlow(),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  width: 150,
                  height: 220,
                  child: Hero(
                    tag: widget.heroTag,
                    child: BookCard(imageUrl: imageUrl),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 200,
                  padding: const EdgeInsets.all(5),
                  child: AutoSizeText(
                    title ?? "Need To Update ",
                    presetFontSizes: [20.0, 18.0],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ClipPath(
              clipper: CornerRadiusClipper(200),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  height: 45,
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5),
                  ),
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    unselectedLabelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    controller: tabController,
                    tabs: <Widget>[Text("Summary"), Text("Detail")],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.white.withOpacity(0.5)),
            height: MediaQuery.of(context).size.height * 0.5,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            padding: EdgeInsets.all(5),
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: HtmlWidget(desc),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text('AUTHOR : $author'),
                      Text('SERIES : $series'),
                      Text('EXTENTION : $extention'),
                      Text('SIZE : $size'),
                      Text('ISBNS : $isbns'),
                      Text('PAGE : $page'),
                      Text('LANGUAGE : $language'),
                      Text('EDITION : $edition'),
                      Text('YEARPUBLISED : $yearPublised'),
                      Text('PUBLICATION : $publication'),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Positioned buildBackButton(BuildContext context) {
    return Positioned(
        top: 25,
        left: 6,
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  Stack buildBackground() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: imageUrl != null
                    ? CachedNetworkImageProvider(imageUrl)
                    : AssetImage("assets/place_holder.jpg"),
                fit: BoxFit.cover,
                alignment: Alignment.center),
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.1),
              end: FractionalOffset(0.7, 0.6),
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.8],
              colors: [
                HexColor("#ff0a6c").withOpacity(0.7),
                HexColor("#4a3cdb").withOpacity(0.7)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future fetchDesc(String endpoint, String id) async {
    String url = endpoint + "json.php?ids=" + id.trim() + "&fields=descr";
    String des;
    http.Response response = await http.get(url);

    try {
      des = json.decode(response.body)[0]['descr'].toString();
    } catch (e) {
      des = '';
    }

    setState(() {
      desc = des;
    });

    // await _interstitialAd.load();
  }
}

class CornerRadiusClipper extends CustomClipper<Path> {
  final double radius;

  CornerRadiusClipper(this.radius);

  @override
  getClip(Size size) {
    final path = Path();
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
