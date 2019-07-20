import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firestroe/databases/UserDatabase.dart';
import 'package:flutter_firestroe/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }

}
class LoginState extends State<LoginPage>
{
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailEditController=TextEditingController();
  final _passwordController=TextEditingController();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  FirebaseAuth _auth=FirebaseAuth.instance;
  Firestore _firestore=Firestore.instance;

  String email_pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Stack(
        children:<Widget>[
          Container(
            height: size.height,

            decoration:BoxDecoration(

                gradient: LinearGradient(
                  colors: [Colors.deepOrange,Colors.orange/*,const Color(0XFF388e3c)*/,],

                ),
                borderRadius: BorderRadius.only(

                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )
            ) ,
          ),
          Container(
          height: size.height,

           decoration:BoxDecoration(

             gradient: LinearGradient(
                 colors: [const Color(0XFF424242),const Color(0XFF303030),const Color(0XFF212121),],

             ),
             borderRadius: BorderRadius.only(
                 bottomLeft: Radius.circular(480),
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
             )
           ) ,
          ),

          Padding(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: Form(
                key: _formKey,
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.filter_drama,size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20,),

                    TextFormField(
                      controller: _emailEditController,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        RegExp regex =RegExp(email_pattern);
                        if (!regex.hasMatch(value))
                          return 'Enter Valid Email';
                        else
                          return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: getTextStyle(),
                      decoration: customInputDecoration("Enter email id"),),
                    SizedBox(height: 20,),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _passwordController,
                      keyboardType: TextInputType.text,

                      obscureText: true,
                      focusNode: _passwordFocus,
                      validator: (value){
                        if(value.isEmpty)
                        {
                          return "Enter Password";
                        }
                        return null;
                      },
                      style: getTextStyle(),
                      decoration: customInputDecoration("Enter password"),
                    ),
                    SizedBox(height: 20,),
                    RaisedButton(onPressed: (){

                      if(_formKey.currentState.validate())
                      {
                        showDialog(context:
                        context,
                            barrierDismissible: false,
                            builder: (_)=>Material(
                              color: Colors.transparent,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    Text("Connecting..."),
                                  ],
                                ),
                              ),
                            )


                        );

                        _auth.signInWithEmailAndPassword(email: _emailEditController.text, password: _passwordController.text)
                        .then((res){
                          print(res.uid);
                          _firestore.collection("users").document(res.uid).get().then(
                              (_snapshot){

                                UserDatabase.instance.insertUser(  User.fromMap(_snapshot.data)).then((res){

                                  Navigator.pop(context);
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Succesfully LogIn"+res.toString())));
                                  Navigator.pushReplacementNamed(context, "/home");
                                });

                              }
                          ).catchError((err){
                            Navigator.pop(context);
                            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(err.message)));
                          });

                        }).catchError((err){
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(err.message)));
                        });
                      }

                    }, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                      color: Colors.orange,
                      child: Text("Login", style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),

                    FlatButton(
                      child: Text("Don't have account, Signup?",style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, "/signup");
                      },
                    )
                  ],
                )
            ),
          )
        ] ,
      ),
    );
  }
  TextStyle getTextStyle(){
    return TextStyle(
        fontSize: 18,
        color: Colors.white
    );
  }

  InputDecoration customInputDecoration(String hint)
  {

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: Colors.white70
      ),
      contentPadding: EdgeInsets.all(10),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.white
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Colors.white
          )
      ),

    );
  }
  /*[const Color(0XF46326),const Color(0XF57b28),]*/
}