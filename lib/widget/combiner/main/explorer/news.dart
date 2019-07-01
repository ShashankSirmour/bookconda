import 'package:flutter/material.dart';

import 'package:book/model/news_paper.dart';
import 'package:book/widget/individual/main/explore/news.dart';

class NewsList extends StatelessWidget {
  final List<NewsPaper> newsPapers;

  const NewsList({Key key, @required this.newsPapers}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: newsPapers.length,
        itemBuilder: (BuildContext context, index) {
          return NewsWidget(
            imageUrl: newsPapers[index].imageUrl,
            title: newsPapers[index].title,
            newsId: newsPapers[index].id,
            date: newsPapers[index].date,
            downloadUrl: newsPapers[index].downloadUrls[0],
          );
        },
      ),
    );
  }
}
