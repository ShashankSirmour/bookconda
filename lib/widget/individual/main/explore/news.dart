import 'package:book/database/db_helper.dart';
import 'package:book/model/book.dart';
import 'package:book/model/store_book.dart';
import 'package:book/scoped-model/download_manager.dart';
import 'package:book/util/card/news.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class NewsWidget extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String newsId;
  final String date;
  final String downloadUrl;
  const NewsWidget(
      {Key key,
      @required this.title,
      @required this.imageUrl,
      @required this.newsId,
      this.date,
      this.downloadUrl})
      : super(key: key);

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  int optionsStatus;
  bool progress = true;

  @override
  void initState() {
    checkIfDownloaded().then((_) {
      setState(() {
        progress = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return progress
        ? Center(child: CircularProgressIndicator())
        : getNews(context);
  }

  Widget getNews(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Want to read?",
                  style: TextStyle(fontFamily: 'sairaSemiCondended'),
                ),
                content: Text(
                    "If you want To read ${widget.title} of ${widget.date} please download and access it form manager."),
                actions: <Widget>[
                  downloadButton(),
                  FlatButton(
                    child: Text(
                      "Cancle",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Container(
        padding: EdgeInsets.all(6),
        width: 180,
        child: NewsCard(
          imageUrl: widget.imageUrl,
          title: widget.title,
          date: widget.date,
        ),
      ),
    );
  }

  Widget downloadButton() {
    return ScopedModelDescendant<DownloadManagerModel>(
      builder:
          (BuildContext context, Widget child, DownloadManagerModel model) {
        return FlatButton(
          child: Text("Download"),
          onPressed: () {
            onDownloadPress(model, context);
          },
        );
      },
    );
  }

  void onDownloadPress(DownloadManagerModel model, BuildContext context) {
    if (optionsStatus == 3) {
      model.download(
        Book(
            type: 2,
            id: widget.newsId,
            imageUrl: widget.imageUrl,
            title: widget.title,
            yearPublised: widget.date,
            downloadUrl: widget.downloadUrl),
      );

      setState(() {
        optionsStatus = 2;
      });

      Navigator.pop(context);
    } else if (optionsStatus == 2) {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "In Progress",
                style: TextStyle(fontFamily: 'sairaSemiCondended'),
              ),
              content: Text(
                  "your request ${widget.title} of ${widget.date} is alredy in progress please go to manager."),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "OK",
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else if (optionsStatus == 1) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Alredy Downloaded",
                style: TextStyle(fontFamily: 'sairaSemiCondended'),
              ),
              content: Text(
                  "your request ${widget.title} of ${widget.date} is alredy downloaded please go to manager."),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "OK",
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future checkIfDownloaded() async {
    DBHealper dbHealper = DBHealper();

    StoreBook book = await dbHealper.getBook(widget.newsId, 2);

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
  }
}
