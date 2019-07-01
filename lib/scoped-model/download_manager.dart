import 'dart:io' as io;

import 'dart:async';
import 'package:book/database/db_helper.dart';
import 'package:book/downloder/download_link_scraper.dart';
import 'package:book/model/book.dart';
import 'package:book/model/downloaing_book.dart';
import 'package:book/model/store_book.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';

class DownloadManagerModel extends Model {
  List<DownloadingBook> _downloadingBooks = [];
  List<StoreBook> _downloadedBooks = [];

  List<DownloadingBook> get downloadingBook {
    return List.from(_downloadingBooks);
  }

  List<StoreBook> get downloadedBooks {
    return List.from(_downloadedBooks);
  }

//------------------------------------------retrive data---------------------------------
  Future initModel() async {
    DBHealper _dbHealper = DBHealper();
    List<StoreBook> storedDownloadingBooks = [];

    _downloadedBooks = await _dbHealper.getALLDownloadedBooks();
    storedDownloadingBooks = await _dbHealper.getALLDownloadingBooks();

    storedDownloadingBooks.forEach((StoreBook s) async {
      final tasks = await FlutterDownloader.loadTasksWithRawQuery(
          query: "SELECT * FROM task WHERE task_id='${s.taskId}'");

      if (tasks.length == 0) {
        print("del one database item as without task");
        _dbHealper.delete(s.id);
      } else {
        if (tasks[0].status == DownloadTaskStatus.complete) {
          StoreBook storeBook = StoreBook(
            id: s.id,
            bookId: s.bookId,
            type: s.type,
            downloadPath: tasks[0].savedDir,
            downloadFileName: tasks[0].filename,
            imagePath: s.imagePath,
            title: s.title,
            author: s.author,
            extention: s.edition,
            size: s.size,
            isbns: s.isbns,
            page: s.page,
            language: s.language,
            edition: s.edition,
            yearPublised: s.yearPublised,
            publication: s.publication,
            downloaded: 1,
            taskId: null,
          );

          _dbHealper.update(storeBook);

          _downloadedBooks.add(storeBook);

          FlutterDownloader.remove(
              taskId: tasks[0].taskId, shouldDeleteContent: false);

          return;
        }

        if (tasks[0].status == DownloadTaskStatus.canceled ||
            tasks[0].status == DownloadTaskStatus.failed) {
          _dbHealper.delete(s.id);
          FlutterDownloader.remove(
              taskId: tasks[0].taskId, shouldDeleteContent: true);
          return;
        }

        _downloadingBooks.add(
          DownloadingBook(
              id: s.id,
              book: Book(
                id: s.bookId.toString(),
                type: s.type,
                downloadUrl: tasks[0].url,
                imageUrl: s.imagePath,
                title: s.title,
                author: s.author,
                extention: s.extention,
                size: s.size,
                isbns: s.isbns,
                page: s.page,
                language: s.language,
                edition: s.edition,
                yearPublised: s.yearPublised,
                publication: s.publication,
              ),
              progress: tasks[0].progress,
              taskId: tasks[0].taskId),
        );
      }
    }); //for each end
    notifyListeners();
  } //initdb end

//-------------------------------------------create download

  Future download(Book book) async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String bookDownloadPath = documentDirectory.path;
    StoreBook storeBook;
    DBHealper _dbHealper = DBHealper();

    _downloadingBooks.add(DownloadingBook(book: book, progress: 0));

    notifyListeners();

    String url;

    if (book.type == 1) {
      Scrapper scrapper = Scrapper();
      url = await scrapper.downloadUrlGenrator(book.downloadUrl);
    } else if (book.type == 2) {
      url = book.downloadUrl;
    } else if (book.type == 3) {
      url = book.downloadUrl;
    }
    if (url == null) return;

    String taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: bookDownloadPath,
      showNotification: true,
      openFileFromNotification: false,
    );
    storeBook = StoreBook(
      bookId: book.id.trim(),
      type: book.type,
      downloadPath: null,
      imagePath: book.imageUrl,
      title: book.title,
      author: book.author,
      extention: book.extention,
      size: book.size,
      isbns: book.isbns,
      page: book.page,
      language: book.language,
      edition: book.edition,
      yearPublised: book.yearPublised,
      publication: book.publication,
      downloaded: 0, //0 if not downloded
      taskId: taskId,
    );

    StoreBook s = await _dbHealper.save(storeBook);

    _downloadingBooks.firstWhere(
        (d) => (d.book.id == storeBook.bookId && d.book.type == storeBook.type))
      ..taskId = storeBook.taskId
      ..id = s.id;
  }

//------------------------------------------------delete----------

  Future delete(StoreBook book) async {
    DBHealper _dbHealper = DBHealper();
    _downloadedBooks.removeWhere((StoreBook s) => s.id == book.id);

    io.File file = io.File(join(book.downloadPath, book.downloadFileName));
    await _dbHealper.delete(book.id);
    await file.delete();
    notifyListeners();
  }

//---------------------------------------------listner
  Future updateDownloadingListner() async {
    DBHealper _dbHealper = DBHealper();
    FlutterDownloader.registerCallback(
        (String id, DownloadTaskStatus status, int progress) async {
      if (progress < -1) progress = 1;
      _downloadingBooks.firstWhere((b) => b.taskId == id).progress = progress;

      if (status == DownloadTaskStatus.complete) {
        int index = _downloadingBooks.indexWhere((b) => b.taskId == id);
        String bookId = _downloadingBooks[index].book.id.trim();
        final tasks = await FlutterDownloader.loadTasksWithRawQuery(
            query: "SELECT * FROM task WHERE task_id='$id'");

        StoreBook storeBook = StoreBook(
          id: _downloadingBooks[index].id,
          bookId: bookId,
          type: _downloadingBooks[index].book.type,
          downloadPath: tasks[0].savedDir,
          downloadFileName: tasks[0].filename,
          imagePath: _downloadingBooks[index].book.imageUrl,
          title: _downloadingBooks[index].book.title,
          author: _downloadingBooks[index].book.author,
          extention: _downloadingBooks[index].book.extention,
          size: _downloadingBooks[index].book.size,
          isbns: _downloadingBooks[index].book.isbns,
          page: _downloadingBooks[index].book.page,
          language: _downloadingBooks[index].book.language,
          edition: _downloadingBooks[index].book.edition,
          yearPublised: _downloadingBooks[index].book.yearPublised,
          publication: _downloadingBooks[index].book.publication,
          downloaded: 1,
          taskId: null,
        );

        FlutterDownloader.remove(taskId: tasks[0].taskId);
        _downloadedBooks.add(storeBook);
        _dbHealper.update(storeBook);
        _downloadingBooks.removeAt(index);
      }
      notifyListeners();
    });
  }
}
