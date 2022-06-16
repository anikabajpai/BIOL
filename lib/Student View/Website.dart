import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:BIOL/src/models/colortheme.dart';

var clr = AppColors();

class Website extends StatefulWidget {
  Website(this.press, this.iUrl, this.webTitle);
  final String iUrl;
  final String webTitle;
  final Function press;

  @override
  _WebsiteState createState() => _WebsiteState(this.press, this.iUrl, this.webTitle);
}

class _WebsiteState extends State<Website> {

  final Function press;
  final String iUrl;
  final String webTitle;
  WebViewController controller;

  _WebsiteState(this.press, this.iUrl, this.webTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(webTitle),
      backgroundColor: clr.color_1,),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: iUrl,
            javascriptMode: JavascriptMode.unrestricted,

            navigationDelegate: (NavigationRequest request) {
              if (iUrl.contains("https://www.proprofs.com/")) {
                if (!request.url.contains("https://www.proprofs.com/")) {
                  return NavigationDecision.prevent;
                }
              } else {
                if (!request.url.contains(iUrl)) {
                  return NavigationDecision.prevent;
                }
              }
              return NavigationDecision.navigate;
            },

            onWebViewCreated: (WebViewController webViewController) {
              //get reference to webView controller to access it globally
              controller = webViewController;
            },

            javascriptChannels: <JavascriptChannel>[
              //set Javascript Channel to WebView
              extractData(context),
            ].toSet(),

            onPageStarted: (String url) {
              //print('Page started loading: $url');
            },

            onPageFinished: (String url) {
              //print('Page finished loading: $url');

              if (url.contains('https://highschooltestprep.com/ap/biology/unit')) {
                readHSTP();
              } else if (url.contains("https://www.proprofs.com/quiz-school/topic/biology")) {
                readPP();
              } else if (url.contains("https://www.varsitytutors.com/high_school_biology-flashcards")) {
                readVT(url);
              }
            },

            gestureRecognizers: Set()
              ..add(
                  Factory<TapGestureRecognizer>(() => TapGestureRecognizer()
                    ..onTapDown = (tap) {
                        print("tapping????");
                        print(iUrl);
                      if (iUrl.contains('https://highschooltestprep.com/ap/biology/')) {
                        print("Hello?");
                        readHSTP();
                      } else if (iUrl.contains("https://www.proprofs.com/quiz-school/topic/biology")) {
                        print(iUrl);
                        readPP();
                      } else if (iUrl.contains("https://www.varsitytutors.com/high_school_biology-flashcards")) {
                        readVT(iUrl);
                      }
                    })),

          ),
          /*
          GestureDetector(
            onTap: () {
              print("Tapping");
            },
          ),*/
        ]
      )
    );
  }

  void readHSTP() async {
    print("I'm in readHSTP");
    String html = await controller.evaluateJavascript("window.document.getElementsByClassName(\"entry-title\")[0].outerHTML");
    String x = await controller.evaluateJavascript("window.document.getElementsByClassName(\"mtq_quiz_status\")[0].outerHTML");
    int idx1 = html.indexOf("A");
    int idx2 = html.lastIndexOf("\\u003C");
    String title = html.substring(idx1, idx2);
    if (x != null && x != "" && x.contains("%.")) {
      int idx4 = x.lastIndexOf("\\u003C/div>\"");
      String score = x.substring(idx4 - 5, idx4 - 1);
      press(title, score, '(High School Test Prep)');
    }
  }

  void readPP() async {
    print("I'm in readPP");
    String html = await controller.evaluateJavascript("window.document.getElementsByClassName(\"breadcrumb_top\")[0].outerHTML");
    String x = await controller.evaluateJavascript("window.document.getElementsByClassName(\"your_score_only\")[0].outerHTML");
    //get title
    if (html == null || x == null) return;
    int idx = html.lastIndexOf("title=");
    String title = html.substring(idx + 8);
    idx = title.indexOf("\\\">");
    title = title.substring(0, idx);
    //get score
    idx = x.indexOf("only\\");
    String score = x.substring(idx + 7);
    print(score);
    idx = score.indexOf("/100");
    score = score.substring(0, idx);
    print(title);
    print(score);
    press(title, score, "(Pro Profs Quiz)");
  }

  void readVT(String iUrl) async {
    int VTscore;
    String html = await controller.evaluateJavascript("window.document.getElementsByClassName(\"flashcard_header\")[0].outerHTML");
    int idx1 = html.lastIndexOf("u003C/span> ");
    int idx2 = html.lastIndexOf("\\u003C/h3>");
    String title = html.substring(idx1 + 12, idx2);
    print(title);
    String opened = await controller.evaluateJavascript("window.document.getElementsByClassName(\"flashcard_answer_content\")[0].outerHTML");

    print('opened');
    print(opened);

    if (opened.contains("display: block;")) {
      print("I was wrong");
    }
    else {
      if (opened.contains("question_row")) {
        print("Reading question...");
        return;
      }
      VTscore++;
      print("I was correct");
    }
    print(VTscore);
    press(title, VTscore.toString(), 'vt');

  }


  JavascriptChannel extractData(BuildContext context) {
    return JavascriptChannel(
        name: "Biology",
        onMessageReceived: (JavascriptMessage message) {
          String pageBody = message.message;
          print("Now I'm here");
          print('page body: $pageBody');
        }
    );
  }
}
