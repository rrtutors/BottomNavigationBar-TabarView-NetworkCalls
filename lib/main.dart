import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firestroe/route_settings.dart';

import 'firestoreconnection.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      //home: FirestoreConnection(),
      onGenerateRoute: RouteSettngsPage.generateRoute,
    );
  }
}




