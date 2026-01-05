import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailNewsView extends StatefulWidget {
  final String url;
  final String title;

  const DetailNewsView({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<DetailNewsView> createState() => _DetailNewsViewState();
}

class _DetailNewsViewState extends State<DetailNewsView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
