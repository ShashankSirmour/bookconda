import 'package:book/widget/individual/main/explore/topic.dart';
import 'package:flutter/material.dart';

class TopicList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext context, index) {
          return TopicWidget(
            imageUrl: null,
            name: "da da dassa",
            topicId: "45",
          );
        },
      ),
    );
  }
}
