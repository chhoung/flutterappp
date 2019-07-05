import 'package:flutter/material.dart';

class VideoCell extends StatelessWidget {
  final video;
  VideoCell(this.video);
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Image.network(video["imageUrl"]),
              new Container(
                height: 6.0,
              ),
              new Text(
                video["name"],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
