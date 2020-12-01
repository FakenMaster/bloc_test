import 'package:bloc_test/bloc/home/cubit/trending_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Stream<int> intStream;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          onPressed: () {
            print('点击了');
            context.read<TrendingCubit>().load(pageNo: 1, pageSize: 20);
          },
          child: Text('点击加载数据cubit'),
        ),
        Expanded(
          child: BlocBuilder<TrendingCubit, TrendingState>(builder: (context, state) {
            if (state is TrendingLoadingState || state is TrendingRefreshingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TrendingInitial) {
              return SizedBox();
            }
            if (state is! TrendingSuccessState) {
              return Center(
                child: Text('加载失败'),
              );
            }
            final data = (state as TrendingSuccessState).trendings;
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
