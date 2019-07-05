import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Views/video_cell.dart';

void main() => runApp(RealWorldApp());

class RealWorldApp extends StatefulWidget {
  
  
  @override
  State<StatefulWidget> createState() {
    return RealWorldState();
  }
}

class RealWorldState extends State {
  var _isLoading = true;
  var videos;
  @override
  void initState() { 
    super.initState();
    _fetchData();
  }
  _fetchData() async {
    print("attempting to fetch data");
    final url = "https://api.letsbuildthatapp.com/youtube/home_feed";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final videosJson = map["videos"];

      setState(() {
        _isLoading = false;
        this.videos = videosJson;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Real World App"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              onPressed: () {
                // print('Pressed!');
                setState(() {
                  _isLoading = true;
                });
                _fetchData();
              },
            ),
          ],
        ),
        body: new Center(
          child: _isLoading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                  itemCount: videos.length != null ? videos.length : 0,
                  itemBuilder: (context, i) {
                    final video = this.videos[i];
                    return new FlatButton(
                      padding: EdgeInsets.all(0.0),
                      child: new VideoCell(video),
                      onPressed: (){
                       String id = video["id"].toString();
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => new VideoCellDetail(id),
                        ));
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class VideoCellDetail extends StatefulWidget{
    final String id;
    VideoCellDetail(this.id);
  @override
  State<StatefulWidget> createState() {
    return VideoDetailState(this.id);
  }
  }

  class Lesson {
    final String name;
    final String imageUrl;
    final String duration;
    final int number;
    Lesson(this.name,this.imageUrl,this.duration, this.number);
  }

class VideoDetailState extends State<VideoCellDetail>{
   final String id;
   VideoDetailState(this.id);     
   final lessons = new List<Lesson>();
   var _isLoading = true;

  @override
  void initState() { 
    super.initState();
    _fetchLessons();
  }

  _fetchLessons() async{
      final url = 'https://api.letsbuildthatapp.com/youtube/course_detail?id=' + this.id;
      print("fetching!");       
      final response = await http.get(url);
      final lessonJson = json.decode(response.body);
      lessonJson.forEach((lessonJson){
          final lesson = new Lesson(lessonJson["name"], lessonJson["imageUrl"], lessonJson["duration"]
          , lessonJson["number"]);
          lessons.add(lesson);
      });
      setState(() {
         _isLoading = false; 
      });
   }

  
    @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text("Detail"),
          ),
          body: new Center(
              child: _isLoading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                 itemCount: lessons.length,
                 itemBuilder: (context,i){
                   final lesson = lessons[i];
                   return new Column(
                     children: <Widget>[
                        new Container(
                          padding: new EdgeInsets.all(12.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                               new Image.network(
                                 lesson.imageUrl, width: 150.0,
                               ),
                               new Container(width: 12.0,),
                               new Flexible(
                                 child: new Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                      new Text(lesson.name,
                                      style: new TextStyle(fontSize: 16.0),),
                                      new Container(height: 4.0,),
                                      new Text(lesson.duration,
                                      style: new TextStyle(fontStyle: FontStyle.italic)),
                                      new Container(height: 4.0,),
                                      new Text("Episode #"+ lesson.number.toString(), 
                                      style: new TextStyle(fontWeight: FontWeight.bold),),
                                   ],
                                 ),
                               )
                            ],
                          ),
                        ),
                        new Divider(),
                     ], 
                   );
                 },
              ),
          ),
        ),
      );
 
  }


}