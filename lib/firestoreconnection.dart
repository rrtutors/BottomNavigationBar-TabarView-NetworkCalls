import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreConnection extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FirestoreState();
  }

}
class FirestoreState extends State<FirestoreConnection>
{
  final CollectionReference postRef = Firestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: (){
          postRef.document().setData(
            {
              "name":"Ruthvik",
             "email":"r@r.com"
            }
          );

      }),
      body: StreamBuilder(
      stream: postRef.snapshots(),
        builder: (context,snapshot){
        switch(snapshot.connectionState)
        {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );



          default:
           return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                return updateList(snapshot.data.documents[index]);

              },
            );

        }

        },
      ),

    );
  }

 /* ListView.builder(
  itemCount: snapshot.data.documents.length,
  itemBuilder: (context,index){
  return Text(snapshot.data.documents[index]["name"]);
  },
  );*/

 Widget updateList(DocumentSnapshot snapshot)
 {
   return ListTile(
     title: Text(snapshot["name"]),
     trailing: InkWell(
       child: Icon(Icons.delete),
       onTap: (){
         snapshot.reference.delete();
       },

     ),

   );
 }
}