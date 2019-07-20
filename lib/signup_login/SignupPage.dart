import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpState();
  }

}

class SignUpState extends State<SignupPage>{
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final _nameEditController=TextEditingController();
  final _emailEditController=TextEditingController();
  final _mobileEditController=TextEditingController();
  final _passwordEditController=TextEditingController();
   String email_pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
   String password_pattern = r'^[a-zA-Z0-9]{6,}$';
   String mobile_pattern = r'^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$';
Size size;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size;
    return new Scaffold(
      key: _scafoldKey,
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

      Center(
        child: SingleChildScrollView(
          child: Padding(
             padding: EdgeInsets.only(left: 20,right: 20),
            child: Form(
                key: _formKey,
                child:
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Container(
                      decoration: new BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.deepOrange,Colors.orange/*,const Color(0XFF388e3c)*/,],

                          ),
                          borderRadius: BorderRadius.all(

                          Radius.circular(20),
                          )

                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Registration Form",style: TextStyle(color: Colors.white,
                          fontSize: 22
                        ),),
                      ),
                    ),
                    SizedBox(height: 40,),
                  //--------------Name FormFiled------------------------------------------
                    TextFormField(
                      controller: _nameEditController,
                      textInputAction: TextInputAction.next,

                      validator: (value){
                        if(value.isEmpty)
                        {
                          return "Enter Name";
                        }
                        return null;
                      },
                      style: getTextStyle(),
                      decoration: customInputDecoration("Enter Name"),
                    ),
                    SizedBox(height: 20,),
                    //--------------Email FormFiled------------------------------------------
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
                      decoration: customInputDecoration("Enter email id"),
                    ),
                    SizedBox(height: 20,),

                    //--------------Mobile FormFiled------------------------------------------
                    TextFormField(
                      controller: _mobileEditController,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        RegExp regex =RegExp(mobile_pattern);
                        if (!regex.hasMatch(value))
                          return 'Enter valid mobile number';
                        else
                          return null;
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      style: getTextStyle(),
                      decoration: customInputDecoration("Enter mobile number"),
                    ),
                    SizedBox(height: 20,),
                    //--------------Password FormFiled------------------------------------------
                    TextFormField(
                      controller: _passwordEditController,
                      textInputAction: TextInputAction.done,
                      validator: (value){
                        RegExp regex =RegExp(password_pattern);
                        if (!regex.hasMatch(value))
                          return 'Password should be in alphanumaric with 6 characters';
                        else
                          return null;
                      },
                      obscureText: true,
                      style: getTextStyle(),
                      decoration: customInputDecoration("Enter password"),
                    ),

                    SizedBox(height: 20,),
                    RaisedButton(onPressed: () async {

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

                        _firebaseAuth.createUserWithEmailAndPassword(email: _emailEditController.text, password: _passwordEditController.text)
                            .then((currentuser){

                          _firebaseAuth.currentUser().then((user){
                            user.uid;
                            _firestore.collection("users").document(user.uid).setData(
                                {
                                  "uid": user.uid,
                                  "name": _nameEditController.text,
                                  "mobile": _mobileEditController.text,
                                  "email": _emailEditController.text,
                                }
                            ).then((result){

                              Navigator.pop(context);
                              _scafoldKey.currentState.showSnackBar(SnackBar(content: Text("User registered succesfully "+user.uid)));
                              Navigator.pushReplacementNamed(context, "/login");

                            }).catchError((err){

                              Navigator.pop(context);
                              _scafoldKey.currentState.showSnackBar(SnackBar(content: Text(err.message)));
                            });

                          });

                        })
                            .catchError((err){
                          Navigator.pop(context);
                          _scafoldKey.currentState.showSnackBar(SnackBar(content: Text(err.message)));


                        });
                    /* FirebaseUser user=await   _firebaseAuth.createUserWithEmailAndPassword(email: _emailEditController.text, password: _passwordEditController.text);
                         print(user);
                          print("User Registration "+user.toString());*/

                      }

                    }, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                      color: Colors.orange,
                      child: Text("Signup", style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),

                    FlatButton(
                      child: Text("Already have account, Sign In?",style: TextStyle(color: Colors.white70),),
                      onPressed: (){

                        Navigator.pushReplacementNamed(context, "/login");
                      },
                    )
                  ],
                )
            ),
          ),
        ),
      )
      ],
      ),
    );;
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
              color: Colors.white70
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
              color: Colors.white
          )
      ),

    );
  }

}