import 'package:bloc_test/bloc/home/bloc/tab_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          onPressed: () {
            print('点击了');
            context.read<TabBloc>().add(TabLoadEvent(pageNo: 1, pageSize: 20));
          },
          child: Text('点击加载数据bloc'),
        ),
        Expanded(
          child: BlocBuilder<TabBloc, TabState>(builder: (context, state) {
            if (state is TabLoadingState || state is TabRefreshingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TabInitial) {
              return SizedBox();
            }
            if (state is! TabSuccessState) {
              return Center(
                child: Text('加载失败'),
              );
            }
            final data = (state as TabSuccessState).trendings;
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].title),
                  subtitle: Text(data[index].dateTime.toString()),
                );
              },
              itemCount: data.length,
            );
          }),
        ),
      ],
    );
  }
}
