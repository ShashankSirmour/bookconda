import 'package:flutter/material.dart';

class StoreBook {
  int id;
  int type; // 1 libgen   2 news     3 uploaded by
  String bookId;
  String downloadPath;
  String downloadFileName;
  String imagePath;
  String title;
  String author; //later author urls add var
  String extention;
  String size;
  String isbns;
  String page;
  String language;
  String edition;
  String yearPublised;
  String publication;
  int downloaded; //0 if not downloded
  String taskId;

  StoreBook({
    this.id,
    @required this.bookId,
    @required this.type,
    this.downloadPath,
    this.downloadFileName,
    this.imagePath,
    this.title,
    this.author,
    this.extention,
    this.size,
    this.isbns,
    this.page,
    this.language,
    this.edition,
    this.yearPublised,
    this.publication,
    this.downloaded, //0 if not downloded
    this.taskId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "type": type,
      "bookId": bookId,
      "downloadPath": downloadPath,
      "downloadFileName": downloadFileName,
      "imagePath": imagePath,
      "title": title,
      "author": author,
      "extention": extention,
      "size": size,
      "isbns": isbns,
      "page": page,
      "language": language,
      "edition": edition,
      "yearPublised": yearPublised,
      "publication": publication,
      "downloaded": downloaded, //0 if not downloded
      "taskId": taskId
    };

    return map;
  }

  StoreBook.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    type = map['type'];
    bookId = map['bookId'];
    downloadPath = map['downloadPath'];
    downloadFileName = map['downloadFileName'];
    imagePath = map['imagePath'];
    title = map['title'];
    author = map['author'];
    extention = map['extention'];
    size = map['size'];
    isbns = map['isbns'];
    page = map['page'];
    language = map['language'];
    edition = map['edition'];
    yearPublised = map['yearPublised'];
    publication = map['publication'];
    downloaded = map['downloaded'];
    taskId = map['taskId'];
  }
}
