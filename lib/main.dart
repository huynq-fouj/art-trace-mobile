import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _requestPermissions();

  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.camera,
    Permission.microphone,
    Permission.storage,
    Permission.photos,
  ].request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web View App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InAppWebViewPage(),
    );
  }
}

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({super.key});

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController? webViewController;

  final InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: true, // Cho phép debug web trên Android Studio/Safari
      mediaPlaybackRequiresUserGesture: false, // Tự động phát video không cần chạm
      allowsInlineMediaPlayback: true, // Cho phép phát video inline
      iframeAllow: "camera; microphone", // Cho phép iframe dùng camera
      iframeAllowFullscreen: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea giúp nội dung không bị che bởi tai thỏ (notch)
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri("https://art-trace-web.vercel.app/"),
          ),
          initialSettings: settings,

          onWebViewCreated: (controller) {
            webViewController = controller;
          },

          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT);
          },

          onConsoleMessage: (controller, consoleMessage) {
            debugPrint("WEB LOG: ${consoleMessage.message}");
          },
        ),
      ),
    );
  }
}
