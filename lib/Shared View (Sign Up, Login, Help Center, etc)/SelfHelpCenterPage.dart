import 'package:BIOL/src/models/colortheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/MongoConnect.dart';
var clr = AppColors();
class SelfHelpCenterPage extends StatelessWidget {
  final Teacher teacher;
  final Student student;

  final questionController = TextEditingController();
  String question;

  SelfHelpCenterPage({Key key, @required this.teacher, @required this.student}) : super(key : key);

  Future<List<Map<String, dynamic>>> loadHelp() async {
    var queryList = await MongoDatabase.getDocumentsHelp(teacher.accessCode);
    return queryList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Self Help Center"),
          backgroundColor: clr.color_1,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  //Spacer(flex: 3),
                  //Spacer(flex: 3),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('Mental Health Resources'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MentalHealth(student: student, teacher:teacher)),
                          );
                        },
                      )),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: Text('College Readiness'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CollegeReadiness(student: student, teacher:teacher)),
                          );
                        },
                      )),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('Student Loan Management'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StudentLoanManagement(student: student, teacher:teacher)),
                          );
                        },
                      )),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: Text("Non-Collegiate Career Options"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NonColl(student: student, teacher:teacher)),
                          );
                        },
                      )),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('Popular Career Options'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PopCar(student: student, teacher:teacher)),
                          );
                        },
                      )),
                  //Spacer(flex: 3)
                ])));
  }
}

class MentalHealth extends StatelessWidget {
  final Student student;
  final Teacher teacher;

  MentalHealth({Key key, @required this.student, @required this.teacher}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Mental Health Resources"), backgroundColor: clr.color_1,),
      body: SingleChildScrollView(child: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
              children: <Widget>[
                Image.asset(
                  'images/MentalHealth.jpg', width: 600, height: 240, fit: BoxFit.cover,),
                //Spacer(flex: 3),
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: student!=null?Text('Hello, ' + student.username + '!',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),)
                          :Text('Hello, ' + teacher.username + '!',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),)
                  ),
                ),
                textSection,
                ElevatedButton.icon(
                  icon: Text('Get Help!'),
                  label: Icon(Icons.arrow_forward, size: 16),
                  onPressed: _launchURL,
                ),
              ]))),
      );
  }

  Widget textSection = const Padding(
    padding: EdgeInsets.all(35),
    child: Text(
        'If you find yourself beginning to feel some stress, anxiety and/or feeling slightly overwhelmed, please consult the counseling services available at {Location of services at school}.\n We are committed to '
            'advancing the mental health and well-being of our students. If you or someone you know is '
            'feeling overwhelmed, depressed, and/or in need of mental health support:'
            '\n\nThe following website includes 60 Digital Resources of Mental Health for anyone seeking help:',
        softWrap: true, style: TextStyle(fontSize: 16)
    ),
  );
}

_launchURL() async {
  const url = 'https://socialworklicensemap.com/social-work-resources/mental-health-resources-list/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class CollegeReadiness extends StatelessWidget {
  final Student student;
  final Teacher teacher;

  CollegeReadiness({Key key, @required this.student, @required this.teacher}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("College Readiness"), backgroundColor: clr.color_1),
      body: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
              children: <Widget>[
                Image.asset(
                  'images/college-readiness.jpg', width: 600, height: 240, fit: BoxFit.cover,),
                //Spacer(flex: 3),
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(0, 30, 10, 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: student!=null?Text('Hello, ' + student.username + '!',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),)
                          :Text('Hello, ' + teacher.username + '!',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),)
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                  child: student!=null? Text(
                      "It's never too early to be planning out your future! \n ",
                      softWrap: true, style: TextStyle(fontSize: 16))
                      :Text("The following is the page the student will see: \n ",
                      softWrap: true, style: TextStyle(fontSize: 16)),),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                    child: Text('What is College Readiness? \n ',
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(35, 0, 10, 5),
                    child: Text('College readiness is the set of skills, behaviors, and knowledge a high school student should have before enrollment in their first year of college. \n '
                        'Academically speaking, this refers to the reading, writing and mathematics abilities required to take on freshman-level college courses i.e. the skills that are also tested through the SAT or the ACT.\n\n'
                        'There are a plethora of benefits that come with demonstrating your college readiness through an assessment like the SAT:\n\n'
                        '\u2022 Decreasing your overall college workload\n'
                        '\u2022 Impact on financial aid\n'
                        '\u2022 Graduating on-time or even earlier\n\n'
                        "These are only a few of the benefits as being able to demonstrate college readiness enables you to avoid taking developmental courses. If you believe that college is for you, start looking into college readiness ASAP! You won't regret it!"
                        '\n\n That being said, college is a lot more than just academic success as there are plenty of soft skills that one must develop to succeed:\n\n'
                        '\u2022 Problem-solving\n'
                        '\u2022 Collaboration\n'
                        '\u2022 Critical thinking\n'
                        '\u2022 Time management\n'
                        '\u2022 Networking\n'
                        '\u2022 Communication\n\n'
                        "Just to name a few! This might make college look like a lot of work but it really isn't! You don't have to develop all these skills over night, one can work towards trying to broaden their horizon at any pace they see fit."
                        " All it takes is the will to succeed!",

                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                    child: Text('Best of Luck!\n ',
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                    )
                ),

              ])),
    );
  }
}

class StudentLoanManagement extends StatelessWidget {
  final Student student;
  final Teacher teacher;

  StudentLoanManagement({Key key, @required this.student, @required this.teacher}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Student Loan Management"), backgroundColor: clr.color_1,),
      body: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
              children: <Widget>[
                Image.asset(
                  'images/download.png', width: 500, height: 200, fit: BoxFit.fitWidth,),
                //Spacer(flex: 3),
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(0, 20, 10, 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: student!=null?Text('Hello, ' + student.username + '!',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),)
                          :Text('Hello, ' + teacher.username + '!',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),)
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(0, 20, 10, 5),
                  child: student!=null? Text(
                      "It's never too early to be planning out your future! \n ",
                      softWrap: true, style: TextStyle(fontSize: 16))
                      :Text("The following is the page the student will see: \n ",
                      softWrap: true, style: TextStyle(fontSize: 16)),),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                    child: Text("You're not alone! \n ",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                    child: Text("Does the idea of incurring debt seem scary? It might make you feel better to know that you are not the only one. Student loans in the US total to more than \$1.5 trillion."
                        " Politicians are always discussing means of dealing with this issue but as individuals, we don't the time to simply wait for something to change, \n\n"
                        "Which is why, until then here are some things to remember that could help you manage your loans or planning ahead to do so:\n\n"
                      , softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 10, 5),
                    child: Text("1. The most important one: Don't ignore them!",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text(
                      "This is probably the easiest and least complex rule to follow but is the building block to every other rule that follows."
                          " Ignoring your loans could hurt your credit score and also cause you to succumb to penalties and fees which could financially affect you for years to come."
                          " Please be sure to read into the loans you plan to take and make sure you fully understand the situation you're dealing with.",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text("2. Calculate your total debt and know your terms",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text("The first thing to know is the overall amount you owe. It is only through knowing your total debt can you plan to pay it down."
                        " As you sum up your debt, be sure to know the different interest rates and repayment rules that come with each loan you take. This would also help develop a more efficient payment plan.",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text("3. Know your Grace Period",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text(
                      "All student loans have a grace period i.e. the amount of time you have after graduation before you have to START paying your loans back. Know what it is for your specific loans!",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text("4. Check for student loan-forgiveness programs",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text(
                      "We already know how the government's attempts at federal-forgiveness are going (not the best), so until that's sorted out,"
                          " be on the look out for other entities that provide loan forgiveness programs."
                          " These could be non profits, government entities like education institutions, etc. If you believe you might be eligible for such a program,"
                          " please look into it at the earliest!",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text("5. Consider Consolidation options",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text(
                      "If you believe that you may have to rely on several different school loans, consolidating them into one loan with one payment might help you,"
                          " but before you do look into consolidating or even refinancing your loans, make sure you're familiar with:"
                          " the overall interest rate, consolidation costs, change policies on interest rates, possibility of paying loan off in advance, etc.",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text("6. Choosing the right payment plan",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text(
                      "The right payment plan can make a loan more affordable for you. Some plans extend to 10 years and others to 5. In situations like that, interest rates can really pile on."
                          "Be sure to explore all options! If possible, pay extra principal whenever you can. Look into how you can do so with your plan as the faster you reduce the principal, the less "
                          "interest you pay over your loan.",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text("7. Looking into deferring payments or applying for debt forgiveness",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                    child: Text(
                      "Sometimes, it may be tough to pay off loans on time. In situations like that, know that the above 2 options do exist, and the situation is still salvageable with minimum loss. "
                          "If you are unemployed, you can ask your loan lender to defer payments. In the case of a federal loan, if you qualify for deferment the government may pay your interest during your deferment."
                          " You may also ask your lender for forbearance if you don't qualify for deferment, but there are certain drawbacks to it. Be sure to be familiar with all these terms and all your options before taking a loan!",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(24, 20, 10, 5),
                    child: Text("There is never any loss in gaining knowledge. Use these tips to guide you when exploring your own options and to motivate you to make the best decisions. \n ",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                    )
                ),
                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 5),
                    child: Text('Best of Luck!\n ',
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                    )
                ),



              ])),
    );
  }
}

class NonColl extends StatelessWidget {
  final Student student;
  final Teacher teacher;

  NonColl({Key key, @required this.student, @required this.teacher}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Non-Collegiate Career Options"), backgroundColor: clr.color_1,),
      body: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
              children: <Widget>[
                Image.asset('images/nontraditional-workers.png', width: 600, height: 240, fit: BoxFit.cover,),
                //Spacer(flex: 3),
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(0, 30, 10, 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: student!=null?Text('Hello, ' + student.username + '!',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),)
                          :Text('Hello, ' + teacher.username + '!',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),)
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                  child: student!=null? Text(
                      "It's never too early to be planning out your future! \n ",
                      softWrap: true, style: TextStyle(fontSize: 16))
                      :Text("The following is the page the student will see: \n ",
                      softWrap: true, style: TextStyle(fontSize: 16)),),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                    child: Text('Is College the right option for you? \n ',
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(23, 0, 10, 5),
                    child: Text("You're closing in on the time where you will have to make this very important decision."
                        " College isn't for everyone."
                        " Luckily, it really isn't an absolute necessity to go to college. Less than 40 percent of the population over 25 have a college degree."
                        " Your success is not defined by your degree. It is defined by your dedication and willingness to work towards achieving your goals.\n\n"
                        'That being said, it might be scary to embark on a journey that seems somewhat unorthodox which is why the following are some resources that could help you learn more about '
                        'this path:\n',
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: clr.color_1,
                    minWidth: 415.0,
                    height: 30.0,
                    onPressed: () => _LaunchURL("https://www.uscareerinstitute.edu/blog/80-Jobs-that-pay-over-50k-without-a-degree"),
                    child: new Text("U.S. Career Institute: 80 Jobs that pay over \$50K",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: clr.color_2,
                    minWidth: 415.0,
                    height: 30.0,
                    onPressed: () => _LaunchURL("https://money.usnews.com/money/careers/slideshow/25-best-jobs-that-dont-require-a-college-degree"),
                    child: new Text("US News: 25 Jobs that don't require a college degree",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: clr.color_1,
                    minWidth: 415.0,
                    height: 30.0,
                    onPressed: () => _LaunchURL("https://www.greatschools.org/gk/articles/great-careers-without-college-degree/"),
                    child: new Text("GreatSchools: 42 Non-collegiate career (and 10 to avoid)",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: clr.color_2,
                    minWidth: 415.0,
                    height: 30.0,
                    onPressed: () => _LaunchURL("https://www.usatoday.com/story/money/careers/2019/07/21/highest-paying-jobs-you-can-get-without-a-college-degree/39701321/"),
                    child: new Text("US News: Highest Paying Jobs that don't require a degree",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(23, 30, 10, 0),
                    child: Text("Even if the plethora of options that you can find above aren't the right fit for you, worry not! "
                        "These are only a few of all the options you can explore without a college degree. If you really believe that you might go down this road, begin planning your future at the earliest!\n"
                      ,
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                    child: Text('Best of Luck!\n ',
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                    )
                ),
              ])),
    );
  }
}

_LaunchURL(String URL) async {
  String url = URL;//"https://money.usnews.com/money/careers/slideshow/25-best-jobs-that-dont-require-a-college-degree";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class PopCar extends StatelessWidget {
  final Student student;
  final Teacher teacher;

  PopCar({Key key, @required this.student, @required this.teacher}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text("Popular Career Options"), backgroundColor: clr.color_1,),
      body: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
              children: <Widget>[
                Image.asset('images/stock.png', width: 1000, height: 240,),
                //Spacer(flex: 3),
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(0, 30, 10, 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: student!=null?Text('Hello, ' + student.username + '!',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),)
                          :Text('Hello, ' + teacher.username + '!',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),)
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                  child: student!=null? Text(
                      "It's never too early to be planning out your future! \n ",
                      softWrap: true, style: TextStyle(fontSize: 16))
                      :Text("The following is the page the student will see: \n ",
                      softWrap: true, style: TextStyle(fontSize: 16)),),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                    child: Text('The job market is booming! \n ',
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(23, 0, 10, 5),
                    child: Text("Right around high school is when we need to take time to consider what exactly we want our profession to be."
                        " It does not have to be the last profession we go into."
                        " It’s honestly never too late to start a new endeavor but it is best to have an idea of what we want to pursue at any given point.\n\n"
                        "That being said, we all value being able to have a successful career. "
                        " For that we need to make sure that the space we go into is one with good job prospects and has a growing demand.\n",
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: clr.color_1,
                    minWidth: 415.0,
                    height: 30.0,
                    onPressed: () => _LaunchURL("https://www.livecareer.com/resources/careers/planning/industry-type"),
                    child: new Text("10 Industries that Are Hiring Like Crazy",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: clr.color_2,
                    minWidth: 415.0,
                    height: 30.0,
                    onPressed: () => _LaunchURL("https://mint.intuit.com/blog/early-career/fastest-growing-jobs/"),
                    child: new Text("The 20 Fastest Growing Jobs of the Next Decade",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: clr.color_1,
                    minWidth: 415.0,
                    height: 30.0,
                    onPressed: () => _LaunchURL("https://www.forbes.com/sites/jackkelly/2021/09/16/the-30-fastest-growing-jobs-and-careers-for-the-next-10-years/?sh=38fa9781609f"),
                    child: new Text("Forbes:The 30 Fastest Growing Jobs For The Next Decade",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: clr.color_2,
                    minWidth: 415.0,
                    height: 30.0,
                    onPressed: () => _LaunchURL("https://www.bls.gov/ooh/most-new-jobs.htm"),
                    child: new Text("BLS: Top 20 highest projected change in Employment",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(23, 30, 10, 0),
                    child: Text("Even if the plethora of options that you can find above aren't the right fit for you, worry not! "
                        "These are only a few of all the options you can explore. The possibilities are endless!\n"
                      ,
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),

                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                    child: Text('Best of Luck!\n ',
                      softWrap: true,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                    )
                ),
              ])),
    );
  }
}
