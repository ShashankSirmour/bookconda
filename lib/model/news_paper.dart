import 'package:flutter/material.dart';

class NewsPaper {
  final String imageUrl;
  final String title;
  final String id;
  final List<String> downloadUrls;
  final String date;

  NewsPaper(
      {@required this.imageUrl,
      @required this.downloadUrls,
      @required this.title,
      @required this.id,
      @required this.date});
}
