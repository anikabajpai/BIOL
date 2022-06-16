import 'package:BIOL/Collection%20Classes/Student.dart';
import 'package:BIOL/src/models/studentUser.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'StudentDashboard.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:BIOL/MongoConnect.dart';
import 'dart:math';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();


// padding values for individual pages
const double afterButtonPadding = 20.0;
const double afterImagePadding = 20.0;

// text sizes
const double titleSize = 32.0;
const double bodySize = 20.0;

// container heights for fixed sizing
const double titleHeight = 120.0;
const double bodyHeight = 200.0;

// button width
const double buttonWidth = 200.0;

// profile image size (both width and height)
const double profileImgSize = 75.0;

// potential noun list - derived from a list of animals
const List<String> nouns = ['Aardvark', 'Aidi', 'Akita', 'Albatross', 'Alligator',
  'Alpaca', 'Anchovy', 'Anteater', 'Antelope', 'Avocet', 'Axolotl', 'Baboon',
  'Badger', 'Bald Eagle', 'Bandicoot', 'Barbet', 'Barracuda', 'Bat', 'Beagle',
  'Bear', 'Bearded Dragon', 'Bobcat', 'Buffalo', 'Bulldog', 'Camel', 'Caribou',
  'Caterpillar', 'Catfish', 'Chameleon', 'Cheetah', 'Chickadee', 'Chipmunk',
  'Coyote', 'Cricket', 'Dachshund', 'Dingo', 'Dragonfly', 'Echidna', 'Emu',
  'Falcon', 'Ferret', 'Flamingo', 'Gazelle', 'Gecko', 'Gibbon', 'Gopher',
  'Hamster', 'Heron', 'Horse', 'Husky', 'Hyena', 'Iguana', 'Jellyfish',
  'Kangaroo', 'Kiwi', 'Koala', 'Ladybug', 'Lemur', 'Leopard', 'Llama', 'Macaw',
  'Mallard', 'Manatee', 'Manta Ray', 'Marmot', 'Mongoose', 'Narwhal', 'Newt',
  'Ocelot', 'Octopus', 'Otter', 'Panther', 'Parakeet', 'Pelican', 'Penguin',
  'Platypus', 'Polar Bear', 'Porcupine', 'Quail', 'Rabbit', 'Raccoon',
  'Reindeer', 'Rhinoceros', 'Scorpion', 'Seahorse', 'Shark', 'Sheep', 'Sloth',
  'Snow Leopard', 'Sparrow', 'Sturgeon', 'Tiger', 'Tortoise', 'Uguisu',
  'Vaquita', 'Walrus', 'Warthog', 'Water Buffalo', 'Wildebeest', 'Wolverine',
  'Wombat', 'Xoloitzcuintli', 'Yak', 'Zebra', 'Zebu'];

// potential adjective list
const List<String> adjectives = ['Adorable', 'Adventurous', 'Agreeable',
  'Alert', 'Amused', 'Anxious', 'Bewildered', 'Blue-Eyed', 'Brainy', 'Brave',
  'Bright', 'Busy', 'Calm', 'Careful', 'Cautious', 'Charming', 'Cheerful',
  'Clever', 'Clumsy', 'Comfortable', 'Concerned', 'Cooperative', 'Courageous',
  'Crazy', 'Curious', 'Delightful', 'Determined', 'Distinct', 'Dizzy', 'Eager',
  'Elated', 'Elegant', 'Encouraging', 'Energetic', 'Enthusiastic', 'Excited',
  'Exuberant', 'Famous', 'Fancy', 'Fantastic', 'Frantic', 'Friendly', 'Funny',
  'Gentle', 'Gifted', 'Gleaming', 'Graceful', 'Grumpy', 'Happy', 'Helpful',
  'Inquisitive', 'Jolly', 'Joyous', 'Kind', 'Lively', 'Lovely', 'Lucky',
  'Motionless', 'Mysterious', 'Nervous', 'Obedient', 'Outstanding', 'Pleasant',
  'Poised', 'Proud', 'Shiny', 'Shy', 'Smiling', 'Sparkling', 'Splendid',
  'Successful', 'Talented', 'Thankful', 'Thoughtful', 'Unusual', 'Vivacious',
  'Witty', 'Zany', 'Zealous'];

// different introduction strings
const List<String> naming =
    ['I dub thee:', 'You will now be known as:',
     'On that day, they were reborn as:', "Who is that? It's:",
     'Welcome to the party:', 'Good to see you:', 'Hello there:', "What's new:",
     "A new user approaches...it's:", "Oh? It's:"];

// other variables needed across pages
List<String> takenUsernames = [];
final List<Map<String, List<int>>> gradeInitializer = [];
String accessCode = "";
String currName = getRandomUsername();
//String profilePic = 'images/profile/white.png';
String passsword = "";

int _focusedIndex = 0;
List<int> data = [
  11,10,9,8,7,6,5,4,3,2,1
];
String profilePic = "images/profile/${data[_focusedIndex]}.jpg";

class Welcome extends StatelessWidget {
  final Student student;
  final String password;
  Welcome({Key key, @required this.student, this.password}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    passsword = password;
    return MaterialApp(
      title: "Welcome!",
      home: Scaffold(
        appBar: AppBar(title: Text(""), backgroundColor: clr.color_1,),
        body: WelcomePage1(student: student),
      ),
    );
  }
}

class WelcomePage1 extends StatelessWidget {
  final Student student;
  const WelcomePage1({Key key, @required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
          children: [
            new Container(
                height: titleHeight,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text("Welcome to BIOL,\n" + student.username + "!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: titleSize),
                )
              ),

            new Image.asset(
              'images/BIOL_LOGO.png', width: 256, height: 124, fit: BoxFit.cover,),

            new Padding(padding: EdgeInsets.all(afterImagePadding)),

            new Container(
                height: bodyHeight,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text("We're so excited you're here! Before you dive into the app, let's get you set up...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: bodySize),
                )
            ),

            new Container(
              width: buttonWidth,
              child: MaterialButton(
                textColor: Colors.white,
                color: clr.color_1,
                onPressed: () {
                  Navigator.of(context).push(pageRouter(student, 2));
                },
                child: const Text('Sounds good!'),
              ),
            ),

            new Padding(padding: EdgeInsets.all(afterButtonPadding)),

            getProgressBar(0.0, context)
          ],
        ),
    );
  }
}

class WelcomeAccess extends StatelessWidget {
  final Student student;
  final TextEditingController textBox = TextEditingController();
  WelcomeAccess({Key key, @required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: clr.color_1,),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Column(
        children: [
          new Container(
              height: titleHeight,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("Please enter your teacher's access code...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: titleSize),
              )
          ),

          //new Padding(padding: EdgeInsets.all(afterImagePadding)),

          new Container(
              height: bodyHeight - 50.0,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("Your teacher should have provided you with a six-digit access code. Please enter it below...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: bodySize),
              )
          ),

          Container(
            //padding: EdgeInsets.all(10),
            child: TextField(
              controller: textBox,
              maxLength: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Access Code Here',
              ),
            ),
          ),

          new Padding(padding: EdgeInsets.all(67.0)),

          new Container(
            width: buttonWidth,
            child: MaterialButton(
              textColor: Colors.white,
              color: clr.color_1,
              onPressed: () {
                  accessCode = textBox.text.toString();
                  if(accessCode == "") {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Access code not found. Please double-check this is the correct access code."),
                      ),
                    );
                  }
                  else {
                    MongoDatabase.checkAccessCode(accessCode).then((varTF) {
                      if (student != null && varTF) {
                        Navigator.of(context).push(pageRouter(student, 3));
                      }
                      else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("Access code not found. Please double-check this is the correct access code."),
                          ),
                        );
                      }
                    });
                  }
                  },
              child: const Text('Code entered!'),
            ),
          ),

          new Padding(padding: EdgeInsets.all(afterButtonPadding)),

          getProgressBar(0.25, context)
        ],
      ),
    )
    );
  }
}

class WelcomePage2 extends StatelessWidget {
  final Student student;

  const WelcomePage2({Key key, @required this.student}) : super(key: key);

  @override

  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoApp(student),
      theme: ThemeData(
        brightness: Brightness.light,
      )

    );
  }
}

class DemoApp extends StatefulWidget {

  final Student student;
  DemoApp(this.student);
  @override

  _DemoAppState createState() => _DemoAppState(this.student);
}

class _DemoAppState extends State<DemoApp> {

  final Student student;
  _DemoAppState(this.student);

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
      profilePic = "images/profile/${data[_focusedIndex]}.jpg";
    });
  }

  Widget _buildItemList(BuildContext context, int index){
    if(index == data.length)
      return Center(
        child: CircularProgressIndicator(),
      );
    return Container(
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],

              image: DecorationImage(
                image: AssetImage("images/profile/${data[index]}.jpg"),
                fit: BoxFit.cover,

              ),
            ),
            width: 200,
            height: 200,


            child: Center(
              child: null
            ),
          ),
        ],
      ),
    );

  }

  @override


  Widget build(BuildContext context) {
    var appBar = AppBar(backgroundColor: clr.color_1,);
    return Scaffold(
      appBar: AppBar(backgroundColor: clr.color_1,),
      body:

      Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          //color: Color(0xfff5ee9e),
        ),

        child: Column(
          children: [
            SizedBox(height: 0.0,),
            ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  child:
                      Container(
                        margin: const EdgeInsets.only(top: 50.0),
                        child:
                          Text(
                            'Pick an avatar!',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle( color: Colors.white, fontSize: 40),
                          ),
                      ),
                  height: 170,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff142129),
                )
            ),

            Expanded(
                child: ScrollSnapList(
                  onItemFocus: _onItemFocus,
                  updateOnScroll: true,
                  focusOnItemTap: true,
                  //curve: Curves.elasticIn,
                  itemBuilder: _buildItemList,
                  itemSize: 150,
                  dynamicItemSize: true,
                  itemCount: data.length,
                ),
              ),

        Stack(
          children: <Widget>[
            SizedBox(height: 0.0,),
            ClipPath(
              clipper: WaveClipperTwo(reverse: true),
              child: Container(
                  height: 240,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff142129),
                  child: null
              ),
            ),

            Stack(
              children: <Widget> [
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(top: 110.0),
                  child:
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 60),
                      textStyle: TextStyle(fontSize: 22),
                      primary: Colors.white70,
                      onPrimary: Colors.black,
                      shape: StadiumBorder(
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(pageRouter(student, 4));
                    },
                    child: const Text('Select this picture'),
                  ),
                ),
              ],
            )
          ],
        ),
          ],
        ),
      ));
  }
}

class W3 extends StatefulWidget {
  final Student student;

  W3({Key key, @required this.student}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WelcomePage3(student: student);
  }
}

class WelcomePage3 extends State<W3> {
  final Student student;
  WelcomePage3({Key key, @required this.student});

  @override
  Widget build(BuildContext context) {
    final studList = MongoDatabase.getStudents(accessCode);
    studList.then((students) {
      for(int i = 0; i < students.length; i++) {
        if(!takenUsernames.contains(students[i]['alias'])) {
          takenUsernames.add(students[i]['alias']);
        }
      }
    }
    );
    currName = getRandomUsername();

    return Scaffold(
      appBar: AppBar(backgroundColor: clr.color_1,),
      body:
      Container(
      child:
      Stack(

        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment(0,-1),
            child:
            ClipPath(
                clipper: WaveClipperOne(),

                child: Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff142129),
                )

            ),
          ),
          Align(
            alignment: Alignment(0,-1),
            child:
              Container(
                  height: titleHeight,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

                  child: Text("Nice! Now choose your leaderboard alias...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 31),
                  )
          ),
          ),
          Align(
            alignment: Alignment(0,-.6),
            child:
          Container(
              height: 100.0,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(getRandomNaming(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: bodySize),
              )
          ),
          ),

          Align(
            alignment: Alignment(0,-.35),
            child:
          Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.black),
              shape: BoxShape.circle,

              image: DecorationImage(
                image: AssetImage(profilePic),
                fit: BoxFit.cover,

              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  spreadRadius: .001,
                  blurRadius: 25,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            width: 180,
            height: 180,
          ),
          ),



          SizedBox(height: 0.0,),
          Align(
            alignment: Alignment(0,1),
            child:
            ClipPath(
                clipper: OvalTopBorderClipper(),

                child: Container(
                  height: 305,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff00587A),
                )

            ),
          ),
          Align(
            alignment: Alignment(0, .33),
            child:
            Container(
                height: 75.0,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(currName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25),
                )
            ),
          ),
          Align(
            alignment: Alignment(0,1),
            child:
          ClipPath(
              clipper: WaveClipperTwo(reverse: true),

              child: Container(
                height: 225,
                width: MediaQuery.of(context).size.width,
                color: Color(0xff142129),
              )

          ),
          ),

          Align(
            alignment: Alignment(0,.63),
            child:
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currName = getRandomUsername();
                });
              },
              child: Text("Rename me...", style: const TextStyle( color: Colors.black)),

              style: ElevatedButton.styleFrom(
                primary: Color(0xff9FC2CC),
                shape: StadiumBorder(
                  side: BorderSide(color: Colors.black, width: 2),
                ),
              )
            ),
          ),
          ),

          Align(
            alignment: Alignment(0,0.76),
            child:
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(pageRouter(student, 5));
              },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff9FC2CC),
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              child: Text("I'm happy with this name!",style: const TextStyle( color: Colors.black)),
            ),
          ),

          ),
          Padding(padding: EdgeInsets.all(afterButtonPadding)),
          Align(
            alignment: Alignment(0,.9),
            child:
          getProgressBar(0.75, context)
          ),
        ],
      ),
      ),
    );
  }
}





class WelcomePage4 extends StatelessWidget {
  final Student student;
  const WelcomePage4({Key key, @required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: clr.color_1,),
      body: new Column(
        children: [
          new Container(
              height: titleHeight,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("Great, you're all set!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: titleSize),
              )
          ),

          new Image.asset(
            'images/BIOL_LOGO.png', width: 256, height: 124, fit: BoxFit.cover,),

          new Padding(padding: EdgeInsets.all(afterImagePadding)),

          new Container(
              height: bodyHeight,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("Press the button below to enter the BIOL app. Happy learning!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: bodySize),
              )
          ),

          new Container(
            width: buttonWidth,
            child: MaterialButton(
              textColor: Colors.white,
              color: clr.color_1,
              onPressed: () {
                // time to push everything to the database
                insertUser(student.username, student.emailId,
                    passsword, accessCode, gradeInitializer);
                MongoDatabase.updateAlias(student.emailId, currName);
                MongoDatabase.updateImage(student.emailId, profilePic);
                student.alias = currName;
                student.image = profilePic;
                student.grade = gradeInitializer;
                student.accessCode = accessCode;
                student.password = passsword;

                // pop until we get to the main page...then push to dashboard
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      StudentDashboard(student: student, ql: [], recentquestion: "", recentanswer: "")),
                );
              },
              child: const Text("Let's go!"),
            ),
          ),

          new Padding(padding: EdgeInsets.all(afterButtonPadding)),

          getProgressBar(1.0, context)
        ],
      ),
    );
  }
}

Route pageRouter(Student student, int destination) {
  // Enables right to left animation - like turning a page
  // Destination is the next page (e.g. if destination is 2, the page to be
  // loaded is WelomePage2
  if(destination == 2) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => WelcomeAccess(student: student),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  else if(destination == 3) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DemoApp(student),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  else if(destination == 4) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => W3(student: student),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  else {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => WelcomePage4(student: student),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

LinearPercentIndicator getProgressBar(double percent, BuildContext context) {
  return LinearPercentIndicator(
    alignment: MainAxisAlignment.center,
    width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 30,
    center: Text((percent * 100).round().toString() + "%",style: const TextStyle( color: Colors.white70)),
    lineHeight: 25.0,
    percent: percent,
    //linearStrokeCap: LinearStrokeCap.roundAll,
    linearStrokeCap: LinearStrokeCap.roundAll,
    backgroundColor: Color(0xff9FC2CC),
    barRadius: const Radius.circular(16),
    progressColor: Color(0xff00587A),
    animation: true,
    animationDuration: 2000,

  );
}

String getRandomUsername() {
  // code to generate a new Leaderboard username - note does not check if name
  // is not already taken by a classmate (will need to implement later)
  Random rand = new Random();
  bool unique = true;
  String username = "";

  while(unique) {
    int randNounInd = rand.nextInt(nouns.length);
    int randAdjInd = rand.nextInt(adjectives.length);
    username = adjectives[randAdjInd] + " " + nouns[randNounInd];

    if(!takenUsernames.contains(username)) {
      unique = false;
    }
  }

  return username;
}

String getRandomNaming() {
  // code to select a random naming phrase from the list 'naming'
  Random rand = new Random();
  int randNamingInd = rand.nextInt(naming.length);
  return naming[randNamingInd];
}

InkWell inkWellBuilder(String image) {
  // factory to build inkwells for profile pictures
  return InkWell(
      onTap: () {
        profilePic = image;
      },
      splashColor: Colors.black,
      child: Ink.image(
        fit: BoxFit.cover,
        width: profileImgSize,
        height: profileImgSize,
        image: AssetImage(image),
      )
  );
}

insertUser(String nameA, String emailA, String passwordA, String accessCodeA, List<Map<String, List<int>>> gradeA) async {
  final user = StudentUser(
    id: M.ObjectId(),
    name: nameA,
    email: emailA,
    password: passwordA,
    accessCode: accessCodeA,
    grade: gradeA,
  );
  await MongoDatabase.insertStudent(user);
}
