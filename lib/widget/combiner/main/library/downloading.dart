import 'package:book/scoped-model/download_manager.dart';
import 'package:book/widget/individual/main/library/downloading.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';



class DownloadingTasks extends StatelessWidget {
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DownloadManagerModel>(
      builder:
          (BuildContext context, Widget child, DownloadManagerModel model) {
        return Container(
          height: 200,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 10, top: 20),

            scrollDirection: Axis.horizontal,
            itemCount:
                model.downloadingBook.length, // model.downloadedBook.length,
            itemBuilder: (BuildContext context, index) {
              return DownloadingTaskCard(
                imageUrl: model.downloadingBook[index].book.imageUrl,
                progress: model.downloadingBook[index].progress,
              );
            },
          ),
        );
      },
    );
  }
}
