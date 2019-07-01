
import 'package:book/util/color/hex_code.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SearchBookDetailCard extends StatelessWidget {
  final String title;
  final String author;

  final String year;
  const SearchBookDetailCard({Key key, this.title, this.author, this.year})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String authorText =
        "by : " + (author != null && author.trim() != '' ? author : "Unknown");
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 5),
            decoration: BoxDecoration(
              color: HexColor("f8f8ff"),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.0,
                  offset: Offset(1, 5),
                  color: Colors.black12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(year),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 2,
                            ),
                            child: AutoSizeText(
                              title != null
                                  ? title
                                  : "Need To Update Please Be Calm",
                              presetFontSizes: [20.0, 18.0, 16.0],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            authorText,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
