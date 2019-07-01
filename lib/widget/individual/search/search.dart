import 'package:book/model/book.dart';
import 'package:book/pages/book/book.dart';
import 'package:book/util/card/book.dart';
import 'package:book/util/card/search_book_detail.dart';
import 'package:flutter/material.dart';

class BookPreviewCard extends StatelessWidget {
  final Book book;
  final int index;
  const BookPreviewCard({Key key, this.book,@required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return BookPage(book: book, heroTag: index.toString());
            },
          ),
        );
      },
      child: getBookPreviewCard(context),
    );
  }

  Widget getBookPreviewCard(BuildContext context) {
    return Container(
      height: 220,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            SearchBookDetailCard(
              title: book.title,
              author: book.author,
              year: book.yearPublised,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: IntrinsicWidth(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: 130,
                          child: Hero(
                            tag: index,
                            child: BookCard(
                              imageUrl: book.imageUrl,
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
      ),
    );
  }
}
