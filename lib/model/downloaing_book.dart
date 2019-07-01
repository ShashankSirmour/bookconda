import 'package:book/model/book.dart';


class DownloadingBook {
  final Book book;
  int progress;
  String taskId;
  int id;

  DownloadingBook({this.book, this.progress, this.taskId,this.id});
}
