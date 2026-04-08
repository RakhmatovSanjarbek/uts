import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PolicyWebView extends StatefulWidget {
  final String url;
  final String title;

  const PolicyWebView({super.key, required this.url, required this.title});

  @override
  State<PolicyWebView> createState() => _PolicyWebViewState();
}

class _PolicyWebViewState extends State<PolicyWebView> {
  double _progress = 0;
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFF8F8F8), // iOS style light grey
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF024837)), // UTS Cargo rangida
          onPressed: () => Navigator.pop(context),
        ),
        bottom: _progress < 1.0
            ? PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.white,
            color: const Color(0xFF024837),
          ),
        )
            : null,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialSettings: InAppWebViewSettings(
          allowsBackForwardNavigationGestures: true, // iOS'dagi orqaga surish (swipe)
          transparentBackground: true,
          supportZoom: false,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onProgressChanged: (controller, progress) {
          setState(() {
            _progress = progress / 100;
          });
        },
      ),
    );
  }
}