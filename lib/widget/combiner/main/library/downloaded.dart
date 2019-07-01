import 'package:book/model/store_book.dart';
import 'package:book/pages/pdf/pdf.dart';
import 'package:book/scoped-model/download_manager.dart';
import 'package:book/util/card/news.dart';
import 'package:book/widget/individual/main/library/downloaded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';

class DownloadedWidget extends StatelessWidget {
  const DownloadedWidget({
    Key key,
    @required this.slidableController,
    @required this.context,
    @required this.model,
    @required this.index,
  }) : super(key: key);

  final SlidableController slidableController;
  final BuildContext context;
  final DownloadManagerModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    StoreBook book = model.downloadedBooks[index];

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return PDFPage(storedBook: book);
          }));
        },
        child: createDownloadedCard(book),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
            color: Colors.black,
            icon: Icons.share,
            onTap: () {
              String type = book.type == 2 ? "NewsPaper" : "Book";
              Share.share(
                  "Read The Great $type '${book.title}' with BOOKCONDA \nhttps://bookconda.github.io/");
            }),
        IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Are You Sure?",
                        style: TextStyle(fontFamily: 'sairaSemiCondended'),
                      ),
                      content: Text(
                          "Once you delete you must to download it again if you want to read again."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            model.delete(model.downloadedBooks[index]);
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("Cancle"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }),
      ],
    );
  }

  Widget createDownloadedCard(StoreBook book) {
    if (book.type == 1 || book.type==3)
      return DownloadedCard(book: book);
    else
      return Container(
        margin: EdgeInsets.all(10),
        height: 165,
        child: NewsCard(
          imageUrl: book.imagePath,
          title: book.title,
          date: book.yearPublised,
        ),
      );
  }
}
