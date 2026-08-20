import 'package:flutter/material.dart';

import 'home_page.dart';

class ConesApp extends StatelessWidget {
  const ConesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter GPU Example', home: HomePage());
  }
}
