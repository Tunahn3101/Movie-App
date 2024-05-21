import 'package:flutter/material.dart';
import 'package:movieapp/provider/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UIWebView extends StatefulWidget {
  const UIWebView({super.key});

  @override
  State<UIWebView> createState() => _UIWebViewState();
}

class _UIWebViewState extends State<UIWebView> {
  late AuthenticationProvider authenticationProvider;
  late WebViewController controller;
  late String requestToken;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          // Kiểm tra URL để xác định khi xác thực hoàn tất
          if (url.contains(
              'https://www.themoviedb.org/authenticate/$requestToken/allow')) {
            // URL có thể là https://www.themoviedb.org/authenticate/<request_token>/allow
            _handleTokenAuthorization();
          }
        },
      ));

    authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    _loadRequestToken();
  }

  Future<void> _loadRequestToken() async {
    try {
      requestToken = await authenticationProvider.getRequestToken();
      controller.loadRequest(
          Uri.parse('https://www.themoviedb.org/authenticate/$requestToken'));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _handleTokenAuthorization() async {
    try {
      // Gọi API tạo session ID
      await authenticationProvider.createSessionId(requestToken);
      // Xử lý sau khi tạo session ID thành công, ví dụ: thông báo thành công hoặc chuyển hướng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create session.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication TMDB'),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
