import 'package:book/util/card/topic.dart';
import 'package:flutter/material.dart';

class TopicWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String topicId;

  const TopicWidget(
      {Key key,
      @required this.name,
      @required this.imageUrl,
      @required this.topicId})
      : super(key: key);
  Widget getTopic(
      String title, String imageUrl, String topicId, BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: () {
        Navigator.pushNamed(
            context, '/course/' + topicId); //pass this to search topic
      },
      child: Container(
        padding: EdgeInsets.all(6),
        width: 180,
          child: TopicCard(
            imageUrl: imageUrl,
            title: title,
          ),
        
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getTopic(name, imageUrl, topicId, context);
  }
}
