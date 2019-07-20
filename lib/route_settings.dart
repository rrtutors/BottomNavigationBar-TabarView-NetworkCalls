 import 'package:flutter/material.dart';
import 'package:flutter_firestroe/posts/create_post.dart';
import 'package:flutter_firestroe/posts/details_post.dart';
import 'package:flutter_firestroe/signup_login/SignupPage.dart';
import 'package:flutter_firestroe/splashpage.dart';


import 'home/home.dart';
import 'signup_login/LoginPage.dart';


class RouteSettngsPage extends RouteSettings{

  static var LOGIN="/login";
  static var SIGNUP="/signup";
  static var HOME="/home";
  static var CREATE_POST="/createpost";
  static Route<dynamic>generateRoute(RouteSettings settings)
  {

    String args=settings.arguments;
    switch(settings.name)
    {
      case "/":
            return MaterialPageRoute(builder: (_)=>SplashPage());
        break;

        case "/login":
        return MaterialPageRoute(builder: (_)=>LoginPage());
        break;
      case "/signup":
        return MaterialPageRoute(builder: (_)=>SignupPage());
        break;
      case "/home":
        return MaterialPageRoute(builder: (_)=>Homepage());
        break;
      case "/createpost":
        return MaterialPageRoute(builder: (_)=>CreatePost());
      case "/detailspost":
        return MaterialPageRoute(builder: (_)=>DetailsPost(args));
        break;

    }
  }
}