import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  String tabName;

  WebViewContainer(this.url, this.tabName);

  @override
  createState() => _WebViewContainerState(this.url);
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(backgroundColor: Colors.lightBlue);
  }
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: kContrastDarkColor),
          centerTitle: true,
          elevation: 0,
          backgroundColor: kBackground,
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              widget.tabName,
              style: TextStyle(color: kContrastDarkColor),
            ),
          ),
        ),
        body: WebView(
          key: _key,
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: _url,
        ));
  }
}
