import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;

  const BookCard({Key key,@required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
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
              : AssetImage("assets/place_holder.jpg"),
        ),
      ),
    );
  }
}
