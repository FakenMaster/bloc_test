import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:bloc_test/bloc/home/cubit/trending_cubit.dart';
import 'package:bloc_test/ui/home/home.dart';
import 'package:bloc_test/ui/settings/settings.dart';
import 'package:bloc_test/ui/stream_where/stream_where_test.dart';
import 'package:bloc_test/ui/webview/webview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import 'bloc/home/bloc/tab_bloc.dart';
import 'package:time/time.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  StreamConsumer streamConsumer;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TabBloc(),
            ),
            BlocProvider(
              create: (context) => TrendingCubit(),
            ),
          ],
          child: 
          StreamWhereTestApp(),
          //IsolateApp(),
        ));
  }
}

class IsolateApp extends StatefulWidget {
  @override
  _IsolateAppState createState() => _IsolateAppState();
}

class _IsolateAppState extends State<IsolateApp> {
  int count = 0;
  StreamController controller;

  /// subscription处理事件是个耗时操作，比如获取网络数据。这个结果最终被UI接收。所以如果过程中1.需要取消这个操作，2.页面销毁了，
  /// 此时，都需要1.取消耗时操作（或者没有办法取消耗时操作的话，就不管了）2.重要的是，结果不要再发送到UI了
  /// 所以，具体操作就是，在耗时操作之后，再添加一个controller，控制将状态发送到UI。当不需要这个状态时，关闭controller。
  /// 当再次需要将数据与UI连接时，再初始化controller
  StreamSubscription subscription;
  StreamSubscription subscription2;

  StreamController controllerUI;
  StreamSubscription uiSubscription;

  initUISubscription() {
    uiSubscription = controllerUI.stream.listen((event) {
      print('ui数据来临:$event');
    });
  }

  @override
  void initState() {
    super.initState();
    controller = StreamController<int>.broadcast(onListen: () {
      print('有新数据');
    });
    controllerUI = StreamController<int>.broadcast();
    initUISubscription();
    subscription = controller.stream.listen((event) async {
      print('subscription监听到新数据:$event,并停留5s');
      final oldUISubscription = uiSubscription;
      await Future.delayed(5.seconds);
      bool canFire = oldUISubscription == uiSubscription &&
          !controllerUI.isClosed &&
          !uiSubscription.isPaused;
      print('subscription停留5s之后结果：$event,发送给UI,是否可以发射:$canFire');
      if (canFire) {
        controllerUI.add(event);
      }
    });

    subscription2 = controller.stream.listen((event) async {
      print('subscription2监听到新数据:$event');
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    subscription2.cancel();
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Html(
              data: '''
              <a href="https://www.baidu.com">百度一下</a><br/>
              <a>百度一下,非链接</a>
              
              ''',
              // customRender: {
              //   "a": (context, widget, attributes, node) {
              //     return GestureDetector(
              //       onTap: () {
              //         print(attributes.keys
              //             .map((e) => '$e:${attributes[e]}')
              //             .toList()
              //             .join('\n'));
              //         print('${node.innerHtml}');
              //       },
              //       child: widget,
              //     );
              //   }
              // },
              onLinkTap: (url) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Webview(
                    url: url,
                  );
                }));
              },
            ),
            RaisedButton(
              onPressed: () {
                controller.add(Random().nextInt(250));
              },
              child: Text('发送stream事件'),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                if (uiSubscription != null) {
                  uiSubscription.cancel();
                  uiSubscription = null;
                } else {
                  initUISubscription();
                }
                setState(() {});
              },
              child:
                  Text('subscription${uiSubscription != null ? '取消' : '监听'}'),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                // testYank();
                testIsolate2020();
              },
              child: Text('新建耗时任务'),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                print('打印:${count++}');
              },
              child: Text('测试是否会被耗时任务阻塞'),
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTest(),
          ],
        ),
      ),
    );
  }

  testYank() async {
    await Future.delayed(1.seconds);
    print('开始耗时任务');

    for (int i = 0; i < 100000000; i++) {
      if (i % 10000 == 0) {
        print(i);
      }
    }
    print('耗时任务结束');
  }

  testIsolate() async {
    compute(heavyTask2, 'aaa');
    // ReceivePort receivePort = ReceivePort();
    // Isolate isolate = await Isolate.spawn(heavyTask, receivePort.sendPort);
    // receivePort.listen((message) {
    //   print('$message');
    // });
  }
}

void heavyTask2(String message) {
  int hashCode = Isolate.current.hashCode;
  print('$hashCode : 开始耗时任务');

  for (int i = 0; i < 1000000000; i++) {
    if (i % 100000000 == 0) {
      print('$hashCode : $i');
    }
  }
  print('$hashCode : 耗时任务结束');
}

void heavyTask(SendPort sendPort) {
  String hashCode = '${Isolate.current.hashCode}'.padLeft(11);
  sendPort.send('$hashCode : 开始耗时任务');

  for (int i = 0; i < 1000000000; i++) {
    if (i % 100000000 == 0) {
      sendPort.send('$hashCode : $i');
    }
  }
  sendPort.send('$hashCode : 耗时任务结束');
}

class BlocApp extends StatefulWidget {
  @override
  _BlocAppState createState() => _BlocAppState();
}

class _BlocAppState extends State<BlocApp> {
  int selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc'),
      ),
      body: selectIndex == 0 ? HomeScreen() : SettingsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'bloc'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'cubit'),
        ],
        onTap: (value) {
          setState(() {
            selectIndex = value;
          });
        },
      ),
    );
  }
}

void testIsolate2020() async {
  ReceivePort receivePort = ReceivePort();
  Isolate isolate = await Isolate.spawn(handleMsg, receivePort.sendPort);
  receivePort.listen((message) {
    print('新消息来临:$message');
  });
  isolate.controlPort.send('hahah');
}

void handleMsg(SendPort sendPort) {
  sendPort.send('我是谁');
}

class ButtonTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountNotifier()),
      ],
      child: Column(
        children: [
          Button1(),
          SizedBox(
            height: 20,
          ),
          Button2()
        ],
      ),
    );
  }
}

class CountNotifier extends ValueNotifier<int> {
  CountNotifier() : super(0);

  void increment() {
    value = value + 1;
  }

  void decrement() {
    value = value - 1;
  }
}

class Button1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        context.read<CountNotifier>().increment();
      },
      child: Text('数据不改变，只调用方法'),
    );
  }
}

class Button2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {},
      child: Text('数据跟着改变,${context.watch<CountNotifier>().value}'),
    );
  }
}
