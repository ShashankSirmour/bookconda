import 'dart:io';
import 'package:book/widget/combiner/main/explorer/news.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

import 'package:book/model/news_paper.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<NewsPaper> newsPapers = [];
  bool onProgress = true;
  @override
  void initState() {
    initiate().then((_) {
      setState(() {
        onProgress = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Explore",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              fontFamily: 'sairaSemiCondensed'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Newspapers",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'sairaSemiCondensed',
                          fontSize: 30,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  onProgress
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : NewsList(
                          newsPapers: newsPapers,
                        ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future initiate() async {
    String endpoint = 'https://blog.iascgl.com/';
    List<Map<String, dynamic>> newsDetails = [
      {
        'title': 'Dainik Jagran',
        'image': 'https://www.jagran.com/assets/images/logo.png',
        'url':
            'https://blog.iascgl.com/p/dainik-jagran-epaper-pdf-download.html',
        'monthPageSelector': '.double',
        'datePageSelector': 'p.double'
      },
      {
        'title': 'Jansatta',
        'image':
            'https://www.jansatta.com/wp-content/themes/vip/jansatta2015/images/logo.png',
        'url': 'https://blog.iascgl.com/p/jansatta-hindi-newspaper.html',
        'monthPageSelector': '.double',
        'datePageSelector': 'p.boxshadow'
      },
      {
        'title': 'Indian Express',
        'image':
            'https://s3-ap-southeast-1.amazonaws.com/marketing-readwhere/IE-New-logo.png',
        'url': 'https://blog.iascgl.com/p/indian-express.html',
        'monthPageSelector': '.double',
        'datePageSelector': 'P.double'
      }
    ];
    print("initiate");
    newsDetails.forEach((newsDetail) async {
      print("for ${newsDetail['title']}");
      var client = Client();
      String monthUrl;
      List<String> downloadUrls = [];
      String id;
      String date;
      dom.Element link;
      Response response = await client.get(newsDetail['url']);

      if (response.statusCode == HttpStatus.ok) {
        print("inside ok");
        var document = parse(response.body);

        try {
          link = document
              .querySelector(newsDetail['monthPageSelector'])
              .firstChild;
          monthUrl = link.attributes['href'];
        } catch (e) {
          print("error in ${newsDetail['url']}");
          return;
        }
        String monthPage = endpoint + monthUrl;
        print(monthPage);
        response = await client.get(monthPage);

        if (response.statusCode == HttpStatus.ok) {
          String paperDetail;
          document = parse(response.body);

          link = document.querySelector(newsDetail['datePageSelector']);
          paperDetail = link.firstChild.text.toString();

          date = paperDetail.trim().replaceAll('-', '');
          id = (date + newsDetail['title']).replaceAll(' ', '');
          List<dom.Element> urls = link.getElementsByTagName('a');
          urls.forEach((url) {
            String downloadUrl = url.attributes['href'].toString();
            downloadUrls.add(downloadUrl);
          });

          print(date);

          setState(() {
            newsPapers.add(NewsPaper(
                date: date,
                id: id,
                downloadUrls: downloadUrls,
                title: newsDetail['title'],
                imageUrl: newsDetail['image']));
          });
        }
      }
    });
  }
}
