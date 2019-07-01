import 'package:book/scoped-model/download_manager.dart';
import 'package:book/widget/combiner/main/library/downloaded.dart';
import 'package:book/widget/combiner/main/library/downloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  SlidableController slidableController;

  @override
  void initState() {
    slidableController = SlidableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DownloadManagerModel>(
      builder:
          (BuildContext context, Widget child, DownloadManagerModel model) {
        bool isDownloadingPresent =
            model.downloadingBook.length > 0 ? true : false;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Manager",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'sairaSemiCondensed'),
            ),
          ),
          body: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount:
                model.downloadedBooks.length + (isDownloadingPresent ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              if (isDownloadingPresent && index == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 12, bottom: 5),
                      child: Text(
                        "Downloading",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                    DownloadingTasks(),
                  ],
                );
              } else if (isDownloadingPresent) {
                if (index == 1) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 12, bottom: 10),
                        child: Text(
                          "Downloaded",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                      new DownloadedWidget(
                          slidableController: slidableController,
                          context: context,
                          model: model,
                          index: index - 1)
                    ],
                  );
                } else
                  return new DownloadedWidget(
                      slidableController: slidableController,
                      context: context,
                      model: model,
                      index: index - 1);
              } else {
                if (index == 0)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 12, bottom: 10),
                        child: Text(
                          "Downloaded",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                      new DownloadedWidget(
                          slidableController: slidableController,
                          context: context,
                          model: model,
                          index: index)
                    ],
                  );
                else
                  return new DownloadedWidget(
                      slidableController: slidableController,
                      context: context,
                      model: model,
                      index: index);
              }
            },
          ),
        );
      },
    );
  }
}
