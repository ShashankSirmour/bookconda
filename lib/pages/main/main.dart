import 'package:book/pages/main/screen/explore.dart';
import 'package:book/pages/main/screen/home.dart';
import 'package:book/pages/main/screen/library.dart';
import 'package:book/pages/main/screen/search.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_version/get_version.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key key,
  }) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String projectCode = '1';
  bool needToUpdate = false;

  Color iconcolor = Colors.black54;
  int currentIndex;
  Widget homeScreen;
  Widget exploreScreen;
  Widget searchScreen;
  Widget libraryScreen;
  Widget currentScreen;
  @override
  void initState() {
    homeScreen = HomeScreen();
    exploreScreen = ExploreScreen();
    searchScreen = SearchScreen();
    libraryScreen = LibraryScreen();
    currentScreen = HomeScreen();
    super.initState();
    currentIndex = 0;
    checkVersion();
  }

  Future checkVersion() async {
    try {
      projectCode = await GetVersion.projectCode;
      Firestore.instance
          .collection('version')
          .document('version')
          .get()
          .then((DocumentSnapshot ds) {
        if (ds['version'] != projectCode) {
          setState(() {
            needToUpdate = true;
          });
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('version').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return mainPageBuilder();
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return mainPageBuilder();
          default:
            if (projectCode != snapshot.data.documents[0]['version']) {
              needToUpdate = true;
            } else
              needToUpdate = false;

            return mainPageBuilder();
        }
      },
    );
  }

  Widget mainPageBuilder() {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            setState(() {
              currentIndex = index;
              currentScreen = homeScreen;
            });
          } else if (index == 1) {
            setState(() {
              currentIndex = index;
              currentScreen = exploreScreen;
            });
          } else if (index == 2) {
            setState(() {
              currentIndex = index;
              currentScreen = searchScreen;
            });
          } else if (index == 3) {
            setState(() {
              currentIndex = index;
              currentScreen = libraryScreen;
              checkVersion();
            });
          }
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        elevation: 8,
        hasInk: true,
        inkColor: Colors.black12,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.home,
                color: iconcolor,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.explore,
                color: iconcolor,
              ),
              activeIcon: Icon(
                Icons.explore,
                color: Colors.deepPurple,
              ),
              title: Text("Explore")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.search,
                color: iconcolor,
              ),
              activeIcon: Icon(
                Icons.search,
                color: Colors.indigo,
              ),
              title: Text("Search")),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.folder,
                color: iconcolor,
              ),
              activeIcon: Icon(
                Icons.folder,
                color: Colors.red,
              ),
              title: Text("Library"))
        ],
      ),
      body: needToUpdate
          ? Container(
              child: Center(
                child: Text("Need To Update"),
              ),
            )
          : currentScreen,
    );
  }
}
