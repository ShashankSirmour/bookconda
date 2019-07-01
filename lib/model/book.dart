import 'package:flutter/material.dart';

class Book {
  final String id;
  final int type;
  final String downloadUrl;
  final String imageUrl;
  final String title;
  final String author; //later author urls add var
  final String series; //later series url add var
  final String extention;
  final String size;
  final String isbns;
  final String page;
  final String language;
  final String edition;
  final String yearPublised;
  final String publication;
  final String periodical;
  final String endpoint;

  Book({
    this.id,
    @required this.type,
    this.downloadUrl,
    this.imageUrl,
    this.title,
    this.author,
    this.series,
    this.extention,
    this.size,
    this.isbns,
    this.page,
    this.language,
    this.edition,
    this.yearPublised,
    this.publication,
    this.periodical,
    this.endpoint
  });
}
