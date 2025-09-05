import 'package:flutter/material.dart';

import 'API Course/E Commerce App/ECommerceApp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:EcommerceApp(), // The home screen is set to Buttons
    );
  }
}
