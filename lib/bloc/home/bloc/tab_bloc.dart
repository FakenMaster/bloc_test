import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/model/home/trending.dart';
import 'package:bloc_test/repository/trending/src/remote_repository.dart';
import 'package:bloc_test/repository/trending/trending_repository.dart';
import 'package:equatable/equatable.dart';

part 'tab_event.dart';
part 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  final TrendingRepository trendingRepository;
  TabBloc({TrendingRepository trendingRepository})
      : trendingRepository = trendingRepository ?? TrendingRemoteRepository(),
        super(TabInitial());

  @override
  Stream<TabState> mapEventToState(
    TabEvent event,
  ) async* {
    if (event is TabRefreshEvent) {
      yield TabRefreshingState();
      yield await _getData(pageNo: 1, pageSize: event.pageSize);
    } else if (event is TabLoadEvent) {
      yield TabLoadingState();
      yield await _getData(pageNo: event.pageNo, pageSize: event.pageSize);
    }
  }

  Future<TabState> _getData({int pageNo, int pageSize}) async {
    try {
      List<Trending> trendings = await trendingRepository.getTrendings(
          pageNo: pageNo, pageSize: pageSize);
      return TabSuccessState(pageNo, trendings);
    } catch (e) {
      return TabFailState(pageNo: pageNo, error: '$e');
    }
  }
}
