import 'package:flutter/material.dart';
import "dart:async";
import "dart:io";
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import "package:rflutter_alert/rflutter_alert.dart";
import "dart:core";
import "package:url_launcher/url_launcher.dart";
import "package:fluttertoast/fluttertoast.dart";
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import "about.dart";
import "comments.dart";
import 'package:connectivity/connectivity.dart';

void main() => runApp(StateApp());

class MyInAppBrowser extends InAppBrowser {

  @override
  Future onLoadStart(String url) async {
    print("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(String url) async {
    print("\n\nStopped $url\n\n");
  }

  @override
  void onLoadError(String url, int code, String message) {
    print("\n\nCan't load $url.. Error: $message\n\n");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

}

MyInAppBrowser inAppBrowserFallback = new MyInAppBrowser();

class MyChromeSafariBrowser extends ChromeSafariBrowser {

  MyChromeSafariBrowser(browserFallback) : super(browserFallback);

  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onLoaded() {
    print("ChromeSafari browser loaded");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

MyChromeSafariBrowser chromeSafariBrowser = new MyChromeSafariBrowser(inAppBrowserFallback);



class StateApp extends StatefulWidget{
  @override
  
  MainApp createState()=>new MainApp();
  
}

class MainApp extends State<StateApp>{
  List data;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int internet = 0 ;
    var name="Void News";
  var indexCurrent=0,page=1,next=true,adsshow;
  void initState(){
    super.initState();
    this.madeData();
    this.getData(0);
    
  }
  
  void madeData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
if (connectivityResult == ConnectivityResult.mobile) {
  print(" MOBILE DATA ");
  setState(() {
      internet = 1; 
  });
} else if (connectivityResult == ConnectivityResult.wifi) {
  print(" WIFI ");
  setState(() {
      internet =1 ; 
  });
}
else {
  print("Not Working");
  setState(() {
      internet = 0 ;

  });
  _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Please connect to internet '),
                duration: Duration(seconds: 5),
              ));
}
  }


 Future<String> getData(int indexnow) async {


   this.setState((){
      next=false;
   });
   madeData();
    var response;
    if(indexnow==0){
      setState(() {
                   name="Home";
                  data=null;
      });
   
       response = await http.get("https://api.hnpwa.com/v0/news/"+page.toString()+".json");
        print(response.statusCode);

    }
   else if(indexnow==1){
      setState(() {
                     name="Newest";
data=null;

      });

    response = await http.get("https://api.hnpwa.com/v0/newest/"+page.toString()+".json");
    
    }
  else if(indexnow==3){
       setState(() {
              name="Show";
data=null;

      });

    response = await http.get("https://api.hnpwa.com/v0/show/"+page.toString()+".json");
    
    }
  else  if(indexnow==2){
        setState(() {
              name="Ask";
data=null;
      });

    response = await http.get("https://api.hnpwa.com/v0/ask/"+page.toString()+".json");
    
    }
  else  if(indexnow==4){
  setState(() {
              name="Jobs";
data=null;

      });
    response = await http.get("https://api.hnpwa.com/v0/jobs/"+page.toString()+".json");
  
    }
          print(response.body.length);

    if(response.body.length<=2){

      setState(() {
        page--;
      });
      Fluttertoast.showToast(
        msg:"Next page not available ",
        backgroundColor: Colors.white,
         textColor: Colors.black 
      );
      getData(indexCurrent);
    }
    else{
    setState(() {
      data= json.decode(response.body); 
    });
    }
    this.setState((){
      next=true;
   });
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build (BuildContext context){
   

    return new MaterialApp(
     debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Staatliches',
      brightness: Brightness.dark,
      primaryColor: Colors.orange[900],
    ),
    
     home: new Scaffold(
       backgroundColor: Colors.black,
       key: _scaffoldKey,
        appBar: new AppBar(

          leading: IconButton(icon: Icon(Icons.menu),onPressed: (){
            print("CLICKED FOR ALERT ");
          
         _scaffoldkey.currentState.openDrawer();   }),
          title: Text(name),
          actions: <Widget>[
     IconButton(icon: Icon(Icons.refresh),color: Colors.white,onPressed: (){
       getData(indexCurrent);
     }
), 
          ],
          
        ),
        drawer:
        Builder(
          
          builder:(context)=> Drawer(

          child :Container(
            color: Colors.black,
            child:ListView(
            
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail: Text("Based on hackernews api"),
                decoration: new BoxDecoration(
                  
                  image:new DecorationImage(
                    fit: BoxFit.cover,
                    image:AssetImage('assets/hackernew.jpg'),
                  )
                ),
              ),

               ListTile(
                onTap: () async { 
                 // await launch("https://github.com/ShivamRawat0l/Voidnews",forceWebView: false); 
                   await  chromeSafariBrowser.open("https://github.com/ShivamRawat0l/Voidnews", options: {
                  "addShareButton": true,
                  "toolbarBackgroundColor": "#000000",
                  "dismissButtonStyle": 1,
                  "preferredBarTintColor": "#000000",
                },
              optionsFallback: {
                "toolbarTopBackgroundColor": "#000000",
                "closeButtonCaption": "Close"
              });
              
                  },
                title: Text("Contribute"),
                trailing: Icon(Icons.code),
              ),
               ListTile(
                onTap: () async { await Fluttertoast.showToast(
                  msg:"It is open source. Visit Github to raise an issue.",
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                ); },
                title: Text("Report a bug"),
                trailing: Icon(Icons.bug_report),
              ),
                             new Divider(),

               ListTile(
                onTap: (){                //    Navigator.of(context).pushNamed("/about_section");
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>AboutSec(),
                ));
 },         
                title: Text("About"),
                trailing: Icon(Icons.info_outline),
              ),
  
            ],
          )
          ),
        ),
        ),
      body: Column(
          children: <Widget>[
           data==null ? internet==1  ? Padding(
             padding: EdgeInsets.only(top:40),
             child:CircularProgressIndicator()
           ) :new Text(""):Text(""),
            new Expanded(
              
              child: ListView.builder(
                
        itemCount: data==null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return  new GestureDetector(
            onTap: () async {
              if(data[index]["url"].toString().contains("http")){

              //await launch(data[index]["url"],forceWebView: false);
                  await  chromeSafariBrowser.open(data[index]["url"], options: {
                  "addShareButton": true,
                  "toolbarBackgroundColor": "#000000",
                  "dismissButtonStyle": 1,
                  "preferredBarTintColor": "#000000",
                },
              optionsFallback: {
                "toolbarTopBackgroundColor": "#000000",
                "closeButtonCaption": "Close"
              });
              }
              else{
                print(data[index]["url"]);
                  Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>HTMLPAGE(text: data[index]["url"].split("=")[1]),
                ));                
              }
              
            },
           child: Card(
             
            color: Colors.grey[900],    
                  child:  Column(
                  children: <Widget>[
                   // data[index]["image"]=="" ? Container() :Image.network(data[index]["image"],fit: BoxFit.cover,height: 200,width: MediaQuery.of(context).size.width,),
                    new Row(
                    children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left:10,top:10,bottom:10,right:0),
                      width: MediaQuery.of(context).size.width-70,
                      child: Text(
         data[index]["title"].replaceAll("â","'").replaceAll("â","-").replaceAll("â","`").replaceAll("â",'"').replaceAll("â",'"'),
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "Merriweather"),
                            )
                    ,),
                    PopupMenuButton (
                      padding: EdgeInsets.only(left:10),
                      tooltip: "More",
                      itemBuilder: (BuildContext context){
                        return <PopupMenuEntry>[
                        data[index]["domain"]!=null ?  PopupMenuItem(
                          child: GestureDetector(
                            onTap: () async {
                             // await launch(data[index]["url"],forceWebView: false);
                              await  chromeSafariBrowser.open("https://www."+data[index]["domain"], options: {
                  "addShareButton": true,
                  "toolbarBackgroundColor": "#000000",
                  "dismissButtonStyle": 1,
                  "preferredBarTintColor": "#000000",
                },
              optionsFallback: {
                "toolbarTopBackgroundColor": "#000000",
                "closeButtonCaption": "Close"
              });
                             
                            },
                            child: Text(data[index]['domain']),
                            )
                            
                          ) :  PopupMenuItem(
                          child: GestureDetector(
                            onTap: () async {
                             
                            },
                            child: Text("Origin N/a"),
                            )
                            
                          ) ,
                            PopupMenuItem(
                                    child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommentPage(
                                              text:
                                                  data[index]["id"].toString()),
                                        ));
                                  },
                                  child: Text("Read Comments "),
                                )),
                        ];
                        
                      },

                    )
                   ]
                    ),
                  
                  new Row(
                    children: <Widget>[
                    data[index]["points"]!=null ? new Container (
                      padding: EdgeInsets.all(10),
                         child: Row(     
                          mainAxisAlignment: MainAxisAlignment.start ,
                           children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child:    Text(data[index]["points"].toString()),
                         ) ,

                           Icon(Icons.trending_up),
                          ]
                      ),
                    ):Text(""),
                     data[index]["comments_count"] != null
                                ? new Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(data[index]
                                                    ["comments_count"]
                                                .toString()),
                                                
                                               
                                          ),
                                          
                                          Icon(Icons.comment),
                                        ]),
                                  )
                                : Text(""),
                    ],
                  ),
                  new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            data[index]["time_ago"] == null
                                ? new Container()
                                : new Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      data[index]["time_ago"],
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey,
                                          ),
                                    ),
                                  ),
                            data[index]["user"] == null
                                ? new Container()
                                : new Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "By " + data[index]["user"],
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )
                          ],
                        )
                  ]
                )
              ),
        );
        },
      ),
            ),
        new Container(
          alignment: Alignment.center,
          
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    IconButton(icon: Icon(Icons.skip_previous),tooltip: "Press to load previous page",onPressed:!next ? null:  () async {
                      if(page==1){
                        Fluttertoast.showToast(
                          msg: "This is the first page",
                          textColor: Colors.white,
                          backgroundColor: Colors.black,
                          fontSize: 15,
                        );
                      }
                      else{
                        setState(() {
                        page--;
                        });
                         await getData(indexCurrent); 
                      }
                    },),
                   new Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(6),
            child:new Text("Page "+page.toString(),style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold))
            ),
      IconButton(
                icon:Icon(Icons.skip_next),tooltip: "Press to load next page",onPressed: !next ? null: () async{
           setState(() {
  page++;
  });   
   await getData(indexCurrent+1);   
 
   
   },
              ),
              ],
              )
        ),
      ],
  ),
      bottomNavigationBar: BottomNavigationBar(
        
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("Home"),backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.new_releases),title: Text("Newest"),backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer),title: Text("Ask"),backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.sort),title: Text("Show"),backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes),title: Text("Jobs"),backgroundColor: Colors.black),
        ],
        
        currentIndex: indexCurrent,
        onTap:(int index) async {
           await  setState(() {
                 indexCurrent=index;
                 page= 1 ;
            });
                    await   getData(index);

           
      },
      
        fixedColor: Colors.deepOrange,
      ),
      )
    );
  }
}





class HTMLPAGE extends StatefulWidget {
  final String text;
  HTMLPAGE({Key key, @required this.text}): super(key:key);

  @override
  HtmlData createState() => HtmlData(text);
}



class HtmlData extends State<HTMLPAGE> {
  var htmldata; 
  var item;
  HtmlData(this.item);
  void initState(){
    super.initState();
    this.getData();
  }
  Future<String> getData() async {
    var response =await http.get("https://api.hnpwa.com/v0/item/"+item+".json");
    setState(() {
      htmldata=json.decode(response.body);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Article"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),onPressed: (){this.getData();},)
        ],
      ),
      body: new Container(
        child :new Column(
          children: <Widget>[
            htmldata!=null ? Container (
              padding:EdgeInsets.all(14),
              child :Text(htmldata["title"],style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily: "GentiumBookBasic"),)
              ) : new Container(
                padding: EdgeInsets.only(top: 100),
                child :Center(
                    child: CircularProgressIndicator(),
                )
              ),
            new Expanded(
              child:  SingleChildScrollView(
                child: Html(
                  backgroundColor: Color(0xFF111111),
                  data: htmldata!=null ?  htmldata["content"] : "<p></p>",
                  padding: EdgeInsets.all(15),
                  defaultTextStyle:  TextStyle(
                    fontSize: 18,
                    fontFamily: "Literata",
            ),

                ),
              ),
             
            ),
            new FlatButton(
              child: Text("Read Comments"),
              onPressed: () async {
                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommentPage(
                                              text:item.toString()),
                                        ));
                 
              } ,
            )
            
          ],
        )
      ),
    );
  }
}


