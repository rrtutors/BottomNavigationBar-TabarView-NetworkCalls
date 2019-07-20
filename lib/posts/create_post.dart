import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreatePostState();
  }

}

class CreatePostState extends State<CreatePost>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(child:Icon(Icons.arrow_back),
          onTap:() {
            Navigator.pop(context);
          },)
        ),
        body: Column(
          children: <Widget>[
            TextField(style: TextStyle(),
              decoration: InputDecoration(
                hintText: "Post Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Colors.black
                  )
                )
              ),
            ),
            TextField(style: TextStyle(),
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                  hintText: "Post Description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(
                          color: Colors.black
                      )
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

}