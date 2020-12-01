import 'package:bloc_test/bloc/home/cubit/trending_cubit.dart';
import 'package:bloc_test/ui/home/home.dart';
import 'package:bloc_test/ui/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home/bloc/tab_bloc.dart';

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
          child: BlocApp(),
        ));
  }
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
