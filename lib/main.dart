import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main () => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super (key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CIVA 앱'),
        actions: <Widget>[
          NavigationControls(_controller.future)
        ],
      ),
      body: WebView(
        //initialUrl: "https://www.google.com",
        initialUrl: "https://cyivacom.firebaseapp.com/",
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      )
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture);
  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady = snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_left),
              iconSize: 40.0,
              onPressed: !webViewReady ? null: () async {
                if(await controller.canGoBack()) {
                  controller.goBack();
                }
                else {
                  Scaffold.of(context).showSnackBar(const SnackBar(content: Text("더이상 뒤로 갈 수 없습니다."),));
                }
              }
            ),
            IconButton(
                icon: const Icon(Icons.arrow_right),
                iconSize: 40.0,
                onPressed: !webViewReady ? null: () async {
                  if(await controller.canGoForward()) {
                    controller.goForward();
                  }
                  else {
                    Scaffold.of(context).showSnackBar(const SnackBar(content: Text("더이상 앞으로 갈 수 없습니다."),));
                  }
                }
            ),
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: !webViewReady ? null: () async {
                  controller.reload();
                }
            ),
          ],
        );
      }
    );
  }
}