import 'package:book/util/card/book.dart';
import 'package:book/util/color/hex_code.dart';
import 'package:book/widget/ui/wave_glassy.dart';
import 'package:flutter/material.dart';

class DownloadingTaskCard extends StatelessWidget {
  final String imageUrl;
  final int progress;

  const DownloadingTaskCard({Key key, this.imageUrl, this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getDownloadesTaskCard(context, imageUrl, progress);
  }

  Widget getDownloadesTaskCard(
      BuildContext context, String imageUrl, int progress) {
    return InkWell(
      splashColor: Colors.blueGrey.shade300,
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(5),
        width: 140,
        child: Stack(
          children: <Widget>[
            BookCard(imageUrl: imageUrl),
            Center(
              child: WaveGlassy(
                size: 90,
                borderColor: Colors.black38,
                fillColor: HexColor("#9fdff7"),
                progress: progress.toDouble(),
              ),
            ),
            Center(
                child: Text('$progress%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    )))
          ],
        ),
      ),
    );
  }
}
