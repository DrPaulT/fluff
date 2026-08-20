import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'cone_data.dart';
import 'gpu_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _coneData = ConeData();
  Ticker? _ticker;

  @override
  void initState() {
    _ticker = createTicker((_) => setState(() {}))..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: GpuPainter(_coneData));
  }
}
