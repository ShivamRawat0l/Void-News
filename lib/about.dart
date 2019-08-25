import "package:flutter/material.dart";
import "package:share/share.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:url_launcher/url_launcher.dart";

class AboutSec  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
  
      appBar: AppBar(
        title: Text("About"),

      ),
      body:new SingleChildScrollView(
        child: new Column(
          
          children: <Widget>[
           
            new Container(
            padding:EdgeInsets.symmetric(horizontal: 2,vertical: 10),
                          alignment: Alignment.centerLeft,

            child :new Container(
                          padding:EdgeInsets.symmetric(horizontal: 10,vertical: 10),

child:new Text("HackerNews ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,fontFamily: "ZCOOLKuaiLe")),
            )
            ),
            new Container(
            padding:EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child :new Text("Hacker News is a social news website focusing on computer science and entrepreneurship. It is run by Paul Graham's investment fund and startup incubator.",
                      style: TextStyle(fontSize: 18)),
            ),
             new Container(
            padding:EdgeInsets.symmetric(horizontal: 2,vertical: 10),
                          alignment: Alignment.centerLeft,

            child :new Container(
                          padding:EdgeInsets.symmetric(horizontal: 10,vertical: 10),

child:new Text("Void News ",style: TextStyle(fontFamily: "ZCOOLKuaiLe",fontWeight: FontWeight.bold,fontSize: 40)),
            )
            ),
            new Container(
            padding:EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child :new Text("VoidNews is basically a app that is driven by the hackernews api. It is build on flutter and is just made to create a interface to be able to read the data. Void News is open source and looking for people to contribute in the project.",style: TextStyle(fontSize: 18)),
            ),
             new Divider(),
             new GestureDetector(
             onTap: () async { await launch("https://www.youtube.com/channel/UCa6vctWpWjyY-_vNWEZ7Qjw",statusBarBrightness: Brightness.dark,forceWebView: false); },
               child: new Card(
                 child:  new Row(
               children: <Widget>[
              IconButton(icon: Icon(FontAwesomeIcons.youtubeSquare),color:Colors.red,tooltip: "Subscribe to our channel",onPressed: (){},),
            Text("Watch our youtube video "),
               ],
              ),
               ),
             ),
            new GestureDetector(
              onTap: () async { await launch("https://www.github.com/ShivamRawat0l",forceWebView: false); },
               child: new Card(
                 child:  new Row(
               children: <Widget>[
              IconButton(icon: Icon(FontAwesomeIcons.githubSquare),color: Colors.purple,tooltip: "See my projects",onPressed: (){},),
            Text("See my github projects "),
               ],
              ),
               ),
             ),
               new GestureDetector(
               onTap: () async { await launch("https://www.twitter.com/Shivamr88547643",forceWebView: false); },
               child: new Card(
                 child:  new Row(
               children: <Widget>[
              IconButton(icon: Icon(FontAwesomeIcons.twitterSquare),color: Colors.blue,tooltip: "Follow me on twitter",onPressed: (){},),
            Text("Follow me on twitter "),
               ],
              ),
               ),
             ),
              new Divider(),
            new Divider(),
            Text("   version 1.0"),
            new Divider(),

          ],
        )
      )
    );
  }
}