import 'package:bloc_test/bloc/search_stream/search_stream_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchStreamApp extends StatefulWidget {
  @override
  _SearchStreamAppState createState() => _SearchStreamAppState();
}

class _SearchStreamAppState extends State<SearchStreamApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchStreamCubit>(
          create: (context) => SearchStreamCubit(),
        ),
      ],
      child: MaterialApp(
        home: SearchStreamPage(),
      ),
    );
  }
}

class SearchStreamPage extends StatefulWidget {
  @override
  _SearchStreamPageState createState() => _SearchStreamPageState();
}

class _SearchStreamPageState extends State<SearchStreamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索流'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {},
            ),
          ),
          Expanded(child: BlocBuilder(
            builder: (context, state) {
              return ListView();
            },
          )),
        ],
      ),
    );
  }
}
