import 'package:flutter/material.dart';
import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";
import "dart:core";
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import "comments.dart";

class HTMLPAGE extends StatefulWidget {
  final String text;
  HTMLPAGE({Key key, @required this.text}) : super(key: key);

  @override
  HtmlData createState() => HtmlData(text);
}

class HtmlData extends State<HTMLPAGE> {
  var htmldata;
  var item;
  HtmlData(this.item);
  void initState() {
    super.initState();
    this.getData();
  }

  Future<String> getData() async {
    var response =
        await http.get("https://api.hnpwa.com/v0/item/" + item + ".json");
    setState(() {
      htmldata = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Article"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              this.getData();
            },
          )
        ],
      ),
      body: htmldata==null ? new CircularProgressIndicator(): new Container(
          child: new Column(
        children: <Widget>[
          htmldata != null
              ? Container(
                  padding: EdgeInsets.all(14),
                  child: Text(
                    htmldata["title"],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ))
              : new Container(
                alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 100),
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
          new Expanded(
            child: SingleChildScrollView(
              child: Html(
                data: htmldata != null ? htmldata["content"] : "<p></p>",
                padding: EdgeInsets.all(15),
                defaultTextStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          new Divider()
        ],
      )),
    );
  }
}
