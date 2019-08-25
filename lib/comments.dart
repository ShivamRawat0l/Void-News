import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class Comments extends StatefulWidget {
  final String textNow;
   final int paddingData; 
  Comments({Key key, @required this.textNow,@required this.paddingData}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState(textNow,paddingData);
}

class _CommentsState extends State<Comments> {
  var htmldata;
  List<bool> loadThis  ; 
  var item;
  int paddingD; 
  @override
  _CommentsState(this.item,this.paddingD);

  void initState()  {
    super.initState();
      this.getDataComments();
  }

  getDataComments() async {
    print("***********************************************************" +
        item +
        "******************************88"+paddingD.toString());
    var response = await http.get("https://api.hnpwa.com/v0/item/" + item.toString() + ".json");
    setState(() {
      htmldata = json.decode(response.body)["comments"];
      loadThis = new List(htmldata.length);
       for(var i=0; i< htmldata.length ; i++ ){
        loadThis[i] = false ;
      }
    }); 
  }

  @override
  Widget build(BuildContext context) {
      ScrollController _controller = ScrollController();

    return Container(
      
      child: ListView.builder(
      shrinkWrap: true ,
      controller: _controller,
      
      itemCount: htmldata == null ? 0 : htmldata.length,
      itemBuilder: (BuildContext context, int index) {
        return  Container(
            
             decoration: new BoxDecoration(
               color: Color(0xFF111111),
       
    border: Border(top: BorderSide(color: Colors.white,width: 2,),left: BorderSide(color: Colors.orange[900],width: 4)
    ),
      
    ),
             margin: EdgeInsets.only(left:paddingD.toDouble()),
            child: new Column(
              
              children: <Widget>[
               
              Html(
                customTextStyle: (dom.Node node, TextStyle baseStyle) {
                  return baseStyle.merge(TextStyle(fontFamily:"Literata", fontSize: 14));
                  },
                data: htmldata[index]["content"].replaceAll("â", "'")
                                  .replaceAll("â", "-")
                                  .replaceAll("â", "`")
                                  .replaceAll("â", '"')
                                  .replaceAll("â", '"')
                                  .replaceAll("â", '"')
                                  .replaceAll("Â", '-'),
                padding: EdgeInsets.all(10),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("By "  + htmldata[index]["user"],style: TextStyle(),),
                             Text("Uploaded "  + htmldata[index]["time_ago"]),
              ],
                             ),
              new Container(
                child: new Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    htmldata[index]["comments_count"]!=0 ? 
                      IconButton(
                          icon:new Icon( Icons.reply_all,size:18),
                          onPressed:   () {
                        setState(() {
                        loadThis[index]=!loadThis[index] ; 
                        });
                      } ,
                          //color: Colors.grey,
                        ) 
                        : Text(""),            
                      
                  ],
                ) 
              ),
              loadThis[index] ?  Comments(textNow: htmldata[index]['id'].toString(),paddingData :
               (paddingD+(20-paddingD)/2).round()) :htmldata[index]["comments_count"] == 0 ? 
               Text("No Replies",style: TextStyle(color: Colors.orange[900]),): 
               Text(" . . . ",style:  new TextStyle(
      fontSize: 20.0,
    ),),
                  
            ],
          )
        );
                
          
      }));
      
     // return 

     
     
      }
         
      
            
      }
 
    
      
    


class CommentPage extends StatelessWidget {
  var text;
  CommentPage({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: new Comments(textNow: text,paddingData:0),
    );
  }
}
