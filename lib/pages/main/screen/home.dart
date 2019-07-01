import 'dart:ui';

import 'package:book/model/book.dart';
import 'package:book/pages/book/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "BOOKCONDA",
          style: TextStyle(
              fontFamily: 'orbitron',
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Card(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('books').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          return FireBaseBooks(
                              data: snapshot.data.documents.toList());
                      }
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Books Of The Day",
                      style: TextStyle(
                          fontFamily: 'sairaSemiCondensed',
                          fontSize: 30,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FireBaseBooks extends StatefulWidget {
  final List<DocumentSnapshot> data;

  const FireBaseBooks({Key key, this.data}) : super(key: key);

  @override
  _FireBaseBooksState createState() => _FireBaseBooksState();
}

class _FireBaseBooksState extends State<FireBaseBooks> {
  PageController pageController = PageController(viewportFraction: 0.8);

  int currentPage = 0;

  Book book;

  @override
  void initState() {
    pageController.addListener(() {
      int next = pageController.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int index) {
        bool active = index == currentPage;
        bool left = index <= currentPage;
        DocumentSnapshot snap = widget.data[index];
        Book book = Book(
            type: 3, //other
            imageUrl: snap['imageUrl'],
            title: snap['title'],
            downloadUrl: snap['downloadUrl'],
            id: snap['id'],
            author: snap['author'],
            endpoint: snap['endpoint'],
            yearPublised: snap['year']);

        return buildBook(context, active, left, book, index);
      },
    );
  }
}

Widget buildBook(
    BuildContext context, bool active, bool left, Book b, int index) {
  BoxShadow shadow = BoxShadow(
    blurRadius: 30.0,
    offset: Offset(30, 20),
    color: Colors.black38,
    spreadRadius: 4,
  );

  return Container(
    height: 500,
    margin: EdgeInsets.only(right: 40, bottom: 50),
    child: AnimatedAlign(
      alignment: active
          ? Alignment.center
          : left ? Alignment.topCenter : Alignment.bottomCenter,
      duration: Duration(milliseconds: 300),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return BookPage(
              book: b,
              heroTag: index.toString(),
            );
          }));
        },
        child: AnimatedContainer(
          width: active ? 250 : 100,
          height: active ? 400 : 100,
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            boxShadow: [active ? shadow : BoxShadow()],
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              image: b.imageUrl != null
                  ? CachedNetworkImageProvider(b.imageUrl)
                  : AssetImage("assets/place_holder.jpg"),
            ),
          ),
          alignment: Alignment.bottomLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(5)),
            child: Hero(
              tag: index.toString(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.3),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      b.title != null ? b.title : "Need To Update",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
