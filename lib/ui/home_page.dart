import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search;

  int _offSet = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=Mb70uBXWs9AW6x1wr8k1sIX45TkSUCxE&limit=20&rating=g"));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=Mb70uBXWs9AW6x1wr8k1sIX45TkSUCxE&q=$_search&limit=19&offset=$_offSet&rating=g&lang=en"));
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Pesquise Aqui:",
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  //borderSide: BorderSide(width: 3.0, style: BorderStyle.solid),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offSet = 0;
                });
              },
              onChanged: (text) {
                if (text.isEmpty) {
                  setState(() {
                    _search = null;
                    _offSet = 0;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createGifTable(
      BuildContext context, AsyncSnapshot<Object?> snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount((snapshot.data! as Map<String, dynamic>)['data']),
      itemBuilder: (context, index) {
        // Se eu não estiver pesquisando || Esse não é meu último item
        if (_search == null ||
            index < (snapshot.data! as Map<String, dynamic>)['data'].length) {
          return GestureDetector(
            //child: Container(color: Colors.blue),
            child: Image.network(
              (snapshot.data! as Map<String, dynamic>)['data'][index]['images']
                  ['fixed_height']['url'],
              height: 300.0,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 70.0,
                ),
                Text(
                  "Carregar mais...",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                  ),
                )
              ],
            ),
            onTap: () {
              setState(() {
                _offSet += 19;
              });
            },
          );
        }
      },
    );
  }

  int? _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }
}

// (snapshot.data! as Map<String, dynamic>)['data'].length