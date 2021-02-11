import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' show FrameTiming;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SVG Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = ''}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _renderTimeMs = 0;
  bool _shouldDraw = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      WidgetsBinding.instance!.addTimingsCallback(this._timingCallback);
      setState(() {
        _shouldDraw = true;
      });
    });

    super.initState();
  }

  void _timingCallback(List<FrameTiming> timings) {
    for (final FrameTiming frameTiming in timings) {
      if (frameTiming.totalSpan.inMilliseconds > _renderTimeMs) {
        setState(() {
          _renderTimeMs = frameTiming.totalSpan.inMilliseconds;
        });
      }
    }
    WidgetsBinding.instance!.removeTimingsCallback(this._timingCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _shouldDraw
                ? SvgPicture.asset('assets/rewards.svg')
                : Container(),
            Text('Render time: $_renderTimeMs ms'),
          ],
        ),
      ),
    );
  }
}
