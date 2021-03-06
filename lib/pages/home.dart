import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/pages/search.dart';
import 'package:fluttershare/pages/timeline.dart';
import 'package:fluttershare/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isAuth = true  ;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState(){
    super.initState();
    pageController = PageController();

    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err){
      print('Error signing in : $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false)
      .then((account){
        handleSignIn(account);
    });

  }

  handleSignIn(GoogleSignInAccount account){
    if(account != null) {
      print('User signed in!: $account');
      setState(() {
        isAuth = true;
      });
    }
    else{
      isAuth = false;
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login(){
    googleSignIn.signIn();
  }

  logout(){
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
    );
  }
  Scaffold buildAuthScreen(){
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex :pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.whatshot),),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active),),
            BottomNavigationBarItem(icon: Icon(Icons.photo_camera),),
            BottomNavigationBarItem(icon: Icon(Icons.search),),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle),),
          ],

      ),
    );
  }

  Scaffold buildUnAuthScreen(){
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
//              Theme.of(context).accentColor.withOpacity(0.8),
              Theme.of(context).primaryColor,
//              Theme.of(context).primaryColorDark,

//              Colors.teal,
//              Colors.purple,
            ]
          ),
        ) ,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('FlutterShare',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login() ,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
