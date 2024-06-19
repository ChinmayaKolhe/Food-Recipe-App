import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Recipeview extends StatefulWidget {
  final String url;
  Recipeview(this.url);

  @override
  _RecipeviewState createState() => _RecipeviewState();
}

class _RecipeviewState extends State<Recipeview> {
  late final String finalurl;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (widget.url.contains("http://")) {
      finalurl = widget.url.replaceAll("http://", "https://");
    } else {
      finalurl = widget.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Recipe App"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        child: WebView(
          initialUrl: finalurl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            setState(() {
              _controller.complete(webViewController);
            });
          },
        ),
      ),
    );
  }
}