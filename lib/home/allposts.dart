import 'package:flutter/material.dart';
import 'package:flutter_firestroe/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' ;

import '../route_settings.dart';

class AllPosts extends StatefulWidget{

String _language;
AllPosts(this._language);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllPostState(_language);
  }

}

class AllPostState extends State<AllPosts>{
  List<Post>_listPosts;
  int _last_page;
  int _current_page;
  ScrollController _scrollController;
  bool _isLoading;
  String _language;
  AllPostState(this._language);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listPosts=List();
    _isLoading=true;
    _last_page=0;
    _current_page=0;
    _scrollController=ScrollController();
    _scrollController.addListener((){
      double _maxScroll=_scrollController.position.maxScrollExtent;
      double _currentScroll=_scrollController.position.pixels;
      double _delta=MediaQuery.of(context).size.height*.25;

      if(_maxScroll-_currentScroll<_delta)
        {
          if(_current_page<_last_page)
          fetchPost();
        }
    });


    fetchPost();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.black38,
      child: (_isLoading)?Center(child:CircularProgressIndicator()):ListView.builder(itemBuilder:_buildItems,

        itemCount: _listPosts.length,
        controller: _scrollController,


      ),
    );
  }

  Widget _buildItems(BuildContext context,int index)
  {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, "/detailspost",arguments: _listPosts[index].ans_description);
          },
          child: Container(

              child: Padding(

                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_listPosts[index].qtn_title,
                      style: TextStyle(fontSize: 18,color: Colors.deepPurple),
                      textAlign: TextAlign.start,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                        alignment:Alignment.bottomRight,
                        child: Text( (_listPosts[index].created_on),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 12,color: Colors.deepOrange),)
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }

  Future<List<Post>> fetchPost() async {
    final response =
    await http.get(
        'http://rrtutors.com/languagepost/'+_language);
    print(("resposne code " + response.statusCode.toString()));
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      print(json.decode(response.body)['lang_individual']);
      List<dynamic>list=json.decode(response.body)['lang_individual'];
      setState(() {
        _isLoading=false;
        if(list.length>0)
        {
          _listPosts.addAll(
              list.map((e) => e == null ? null : Post.fromJson(e)).toList());
          print(_listPosts);

        }
      });
      return _listPosts;
      /*if (json.decode(response.body)['success'] == 1) {
        Map<String, dynamic>news = json.decode(response.body)['news'];

       // _last_page = news['last_page'];
       // _current_page = news['current_page'];
        _current_page=_current_page+1;
        List<dynamic>list=news['data'];

        setState(() {
          _isLoading=false;
          if(list.length>0)
          {
            _listPosts.addAll(
                list.map((e) => e == null ? null : Post.fromJson(e)).toList());
            print(_listPosts);

          }
        });



        return _listPosts;
      }*/
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}


