import 'package:book/model/sub_topic.dart';
import 'package:flutter/material.dart';

class Topic {
  final String topic;
  final String topicId;
  final List<SubTopic> subtopic;

  Topic(
      {@required this.topic, @required this.topicId, @required this.subtopic});
}
