
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopicCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  const TopicCard({Key key, this.imageUrl, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.0,
                  offset: Offset(2, 3),
                  color: Colors.black12,
                  spreadRadius: 2,
                )
              ],
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  image: imageUrl != null
                      ? CachedNetworkImageProvider(imageUrl)
                      : AssetImage("assets/place_holder.jpg"))),
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.black38),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
