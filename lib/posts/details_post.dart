import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class DetailsPost extends StatefulWidget{
  String data;
  DetailsPost(this.data);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailsPostState(data);
  }

}

class DetailsPostState extends State<DetailsPost>
{
  String data;
  DetailsPostState(this.data);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Details"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(1),
              topLeft: Radius.circular(1),

            )
        ),
        leading: InkWell(
          child: Icon(Icons.arrow_back,color: Colors.white,),
            onTap: (){
            Navigator.pop(context);
            },
      ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: Colors.purple,width: 2,
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: WebView(

                initialUrl: Uri.dataFromString(data,mimeType: 'text/html').toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}