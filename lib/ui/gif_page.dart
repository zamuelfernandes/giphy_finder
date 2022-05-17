import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    String title = _gifData["title"];
    var gif = _gifData["images"]["fixed_height"]["url"];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(gif),
      ),
    );
  }
}
