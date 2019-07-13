import 'package:admob_flutter/admob_flutter.dart';
import 'package:book/hard-data/monitize/admob.dart';
import 'package:book/model/book.dart';
import 'package:book/util/color/hex_code.dart';
import 'package:book/widget/individual/search/search.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

//http://libgen.io/search.php?req=django&res=25&view=detailed&column=def

class SearchPage extends StatefulWidget {
  final String searchText;
  const SearchPage({this.searchText});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController _scrollController;
  String urlFilter = "&res=25&view=detailed&column=def&sort=year&sortmode=DESC";
  List<String> endpintSearch = [
    // "https://libgen.is/",
    "http://gen.lib.rus.ec/",
    // "http://libgen.io/",
  ];

  int currentServer = 0;
  String req = '';
  String searchUrl;
  List<Book> books = [];
  bool lastPage;
  int page = 0;
  bool fetching;

  void fetch() {
    if (fetching == true) return;
    setState(() {
      fetching = true;
    });

    page++;
    initiateScraping(searchUrl, page).then((_) {
      setState(() {
        fetching = false;
      });
    });
  }

  @override
  void initState() {
    lastPage = false;

    List<String> texts = widget.searchText.trim().split(" ");
    for (int i = 0; i < texts.length; i++) {
      if (i != 0) req = req + "+";
      req = req + texts[i].trim();
    }
    req = "search.php?req=" + req;

    searchUrl = endpintSearch[currentServer] + req + urlFilter;

    fetching = false;
    page = 0;

    fetch();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetch();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("F5F5F5"),
        ),
        body: Stack(
          children: <Widget>[
            ListView.builder(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20),
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: books.length,
              itemBuilder: (BuildContext context, int index) {
                if (index % 3 == 0 && index != 0)
                  return Column(
                    children: <Widget>[
                      BookPreviewCard(book: books[index], index: index),
                      AdmobBanner(
                        adUnitId: getBannerAdUnitId(),
                        adSize: AdmobBannerSize.BANNER,
                      )
                    ],
                  );
                return BookPreviewCard(book: books[index], index: index);
              },
            ),
            fetching == true && lastPage != true ? buildLoading() : Container()
          ],
        ));
  }

  Align buildLoading() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RefreshProgressIndicator(
              backgroundColor: Colors.black,
            ),
            Text(
              "LOADING",
              style: TextStyle(
                  fontFamily: 'orbitron', fontWeight: FontWeight.w900),
            )
          ],
        ));
  }

//-------------------------------------------------libgen-----------------
  Future initiateScraping(String url, int page) async {
    var client = Client();

    Response response = await client.get(url + '&page=$page');

    if (!(200 <= response.statusCode && response.statusCode <= 299)) return;

    var document = parse(response.body);

    List<dom.Element> allBookElement =
        document.querySelectorAll("table[rules='cols']").where((t) {
      return t.parent == document.body;
    }).toList();

    if (allBookElement.length == 0 &&
        page == 1 &&
        endpintSearch.length > currentServer) {
      currentServer++;
      searchUrl = endpintSearch[currentServer] + req + urlFilter;

      initiateScraping(searchUrl, page);
      return;
    }

    if (allBookElement.length == 0) {
      lastPage = true;
    }
    allBookElement.forEach(
      (bookElement) async {
        String bookDownloadUrl,
            bookImageUrl,
            bookTitle,
            bookAuthor,
            bookSeries,
            bookPeriodical,
            bookPublication,
            bookYear,
            bookEdition,
            bookLanguage,
            bookPage,
            bookIsbn,
            bookId,
            bookSize,
            bookExtention;

        List<dom.Element> data =
            bookElement.querySelectorAll("tr[valign='top']"); //getting all data

        List<dom.Element> children = data[1].children;

        dom.Element imageUrl = children[0].querySelector('img');
        bookImageUrl = imageUrl.attributes['src'].toString(); // book image url

        dom.Element title = children[2].querySelector('a');

        bookTitle = title.text.toString(); // book title

        bookDownloadUrl = title.attributes['href']
            .toString(); //book download url  sometimes not work so

        dom.Element author = data[2].querySelector('a');
        bookAuthor = author.text.toString(); //book Author

        children = data[3].children;

        bookSeries = children[1].text.toString(); // series
        bookPeriodical = children[3].text.toString(); //Periodical

        children = data[4].children;

        bookPublication = children[1].text.toString(); //publication

        children = data[5].children;

        bookYear = children[1].text.toString(); // year published
        bookEdition = children[3].text.toString(); //edition

        children = data[6].children;

        bookLanguage = children[1].text.toString(); // language
        bookPage = children[3].text.toString(); //page

        children = data[7].children;

        bookIsbn = children[1].text.toString(); // isbn sepreted by ,
        bookId = children[3].text.toString(); //id

        children = data[9].children;

        bookSize = children[1].text.toString(); // size
        bookExtention = children[3].text.toString(); // extention
//------------------------------

        //   Response res = await client.get(url + '&page=$page');

        //  if(!(200<=response.statusCode&&response.statusCode<=299))
        //     return;

        //   var document = parse(response.body);

//-----------------------------------
        setState(() {
          books.add(Book(
            type: 1, // as libgen
            downloadUrl: endpintSearch[currentServer] + bookDownloadUrl,
            imageUrl: endpintSearch[currentServer] + bookImageUrl,
            title: bookTitle.trim(),
            author: bookAuthor.trim(),
            series: bookSeries.trim(),
            size: bookSize.trim(),
            isbns: bookIsbn.trim(),
            id: bookId.trim(),
            language: bookLanguage.trim(),
            publication: bookPublication.trim(),
            yearPublised: bookYear.trim(),
            extention: bookEdition.trim(),
            edition: bookExtention.trim(),
            periodical: bookPeriodical.trim(),
            page: bookPage.trim(),
            endpoint: endpintSearch[currentServer],
          ));
        });
      },
    );
  }
}

// class MyTestDevices extends TestDevices {
//   static MyTestDevices _instance;

//   factory MyTestDevices() {
//     if (_instance == null) _instance = new MyTestDevices._internal();
//     return _instance;
//   }

//   MyTestDevices._internal();

//   @override
//   List<String> get values => List()..add("XXXXXXXX"); // Set here.
// }
