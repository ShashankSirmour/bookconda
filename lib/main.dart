import 'package:admob_flutter/admob_flutter.dart';
import 'package:book/pages/main/screen/library.dart';
import 'package:book/scoped-model/download_manager.dart';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'hard-data/monitize/admob.dart';
import 'pages/main/main.dart';
import 'pages/search/search.dart';

void main() {
  Admob.initialize(getAppId());
  runApp(BookConda());
}

class BookConda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DownloadManagerModel model = DownloadManagerModel();
    model.initModel();
    model.updateDownloadingListner();
    return ScopedModel<DownloadManagerModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.white, fontFamily: 'robotoSlab'),
        routes: {
          '/': (BuildContext context) => MainPage(),
        },
        onGenerateRoute: (RouteSettings setting) {
          final List<String> pathElement = setting.name.split('/');

          if (pathElement[0] != '') {
            return null;
          }

          //------------------------routes---------------------------

          if (pathElement[1] == 'search') {
            return MaterialPageRoute(builder: (BuildContext context) {
              return SearchPage(searchText: pathElement[2].trim());
            });
          }

          if (pathElement[1] == 'library') {
            return MaterialPageRoute(builder: (BuildContext context) {
              return LibraryScreen();
            });
          }

          return null; //deffault
        },
      ),
    );
  }
}
