
import 'package:book/model/store_book.dart';
import 'package:book/util/card/book.dart';
import 'package:book/util/card/search_book_detail.dart';
import 'package:flutter/material.dart';

class DownloadedCard extends StatelessWidget {
  final StoreBook book;

  const DownloadedCard({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getDownloadedCard(context, book.title, book.author, book.imagePath,
        book?.yearPublised?.trim(), book.id.toString());
  }

  Widget getDownloadedCard(BuildContext context, String title, String author,
      String imageUrl, String year, String id) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5, right: 5),
      child: Stack(
        children: <Widget>[
          SearchBookDetailCard(
            title: title,
            author: author,
            year: year ?? 'latest',
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: IntrinsicWidth(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: 120,
                        child: Hero(
                          tag: id,
                          child: BookCard(
                            imageUrl: imageUrl,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
