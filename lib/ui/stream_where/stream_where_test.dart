import 'dart:async';
import 'dart:math';
import 'package:time/time.dart';
import 'package:flutter/material.dart';

class StreamWhereTestApp extends StatefulWidget {
  @override
  _StreamWhereTestAppState createState() => _StreamWhereTestAppState();
}

class _StreamWhereTestAppState extends State<StreamWhereTestApp> {
  StreamController<int> _controller;

  StreamSubscription<int> _originStreamSubscription;
  StreamSubscription<int> _oddStreamSubscription;

  int _originValue;
  int _oddValue;
  @override
  void initState() {
    super.initState();
    _controller = StreamController.broadcast();
    _originStreamSubscription = _controller.stream.listen((event) {
      setState(() {
        _originValue = event;
      });
    });
    _oddStreamSubscription =
        _controller.stream.where((event) => event.isOdd).listen((event) async {
          /// 1. 已经开始执行，controller.pause无法阻止这次运行
          /// 2. controller.resume,如果上次有新值，那么开始执行这个方法
      Future.delayed(2.seconds, () {
        setState(() {
          _oddValue = event;
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.close();
    _originStreamSubscription.cancel();
    _oddStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Where'),
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () {
              _controller.add(Random().nextInt(1000));
            },
            child: Text('生成新值'),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text('原始值:$_originValue'),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text('奇数:$_oddValue'),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () {
              bool isPaused = _oddStreamSubscription.isPaused;
              if (isPaused) {
                _oddStreamSubscription.resume();
              } else {
                _oddStreamSubscription.pause();
                _oddStreamSubscription.pause();
              }
              setState(() {});
            },
            child: Text('${_oddStreamSubscription.isPaused ? '恢复' : '暂停两次'}'),
          ),
        ],
      ),
    );
  }
}
