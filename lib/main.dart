import 'package:flutter/material.dart';
import 'MongoConnect.dart';
import 'Shared View (Sign Up, Login, Help Center, etc)/LoginScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: 70),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text("Welcome to",
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
            ),
            Center(
              //heightFactor: 10,
              child: Image.asset('images/BIOL_LOGO.png',
                  width:300,
                  height:250,
                  scale:1.0
              ),
            ),
            SizedBox(height: 50),
            Container(
                height: 70,
                width: 400,
                padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: MaterialButton(
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                  color: clr.color_1,
                  child: Text('Click to Login',
                      style: TextStyle(fontSize: 25)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}





