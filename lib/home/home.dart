import 'package:flutter/material.dart';
import 'package:flutter_firestroe/databases/UserDatabase.dart';
import 'package:flutter_firestroe/home/allposts.dart';
import 'package:flutter_firestroe/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../route_settings.dart';

class Homepage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return HomeState();
  }

}

class HomeState extends State<Homepage> with SingleTickerProviderStateMixin{
  Size size;
  User user;
  Firestore fireStore=Firestore.instance;
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  TabController _tabController;

  var _currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex=0;
    _tabController=TabController(length: 2, vsync: this);
  /*  UserDatabase.instance.getUserData().then((result){
      setState(() {
        user=result;
      });

    });*/
  }
  @override
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size;
    return Scaffold(
    backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text("Posts"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(1),
                  topLeft: Radius.circular(1),
                )
              ),
              backgroundColor: Colors.deepPurple,
            ),
            backgroundColor: Colors.white,
            bottomNavigationBar: BottomNavigationBar(items:
            [
               BottomNavigationBarItem(
                icon: Image.asset("flutter.png",width: 32,height: 32,),
                title: Text('Flutter',style: TextStyle(color: Colors.white),),
              ),
               BottomNavigationBarItem(
                 icon: Image.asset("android.png",width: 32,height: 32,),
                 title: Text('Android',style: TextStyle(color: Colors.white),),
               ),
            ],
              backgroundColor: Colors.deepPurple,
              onTap: (_current){
              setState(() {
                _currentIndex=_current;
                _tabController.animateTo(_currentIndex);
              });

              },
              currentIndex: _currentIndex,

            ),

            body: TabBarView(children:
            [
             AllPosts("flutter"),
             AllPosts("android"),


            ],
                controller: _tabController,


            )
          ),
        ],

      )
    );
  }

}

/*
Center(
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: <Widget>[

Column(

mainAxisAlignment: MainAxisAlignment.center,

children: <Widget>[
Center(
child: (user==null)?null:Text("Welcome User "+user.name,
style:TextStyle(
color: Colors.white,
fontSize: 22,
) ,),
),
Padding(
padding: const EdgeInsets.all(12.0),
child: RaisedButton(
onPressed: (){
UserDatabase.instance.deleteUser(user.email).then((res){
if(res==1)
{
Navigator.pushReplacementNamed(context, "/login");
}

});

},
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(15),

),
color:Colors.pink,
child: Text("Logout", style: TextStyle(color: Colors.white
),)
),
)
],
),

],
),
),*/
