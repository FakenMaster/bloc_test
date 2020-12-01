import 'package:bloc/bloc.dart';
import 'package:bloc_test/model/home/trending.dart';
import 'package:bloc_test/repository/trending/src/remote_repository.dart';
import 'package:bloc_test/repository/trending/trending_repository.dart';
import 'package:equatable/equatable.dart';

part 'trending_state.dart';

class TrendingCubit extends Cubit<TrendingState> {
  TrendingCubit({TrendingRepository trendingRepository})
      : trendingRepository = trendingRepository ?? TrendingRemoteRepository(),
        super(TrendingInitial());

  final TrendingRepository trendingRepository;

  void refresh({int pageSize}) async {
    emit(TrendingRefreshingState());
    emit(await _getData(pageNo: 1, pageSize: pageSize));
  }

  void load({int pageNo, int pageSize}) async {
    emit(TrendingLoadingState());
    emit(await _getData(pageNo: pageNo, pageSize: pageSize));
  }

  Future<TrendingState> _getData({int pageNo, int pageSize}) async {
    try {
      List<Trending> trendings = await trendingRepository.getTrendings(
          pageNo: pageNo, pageSize: pageSize);
      return TrendingSuccessState(pageNo, trendings);
    } catch (e) {
      return TrendingFailState(pageNo: pageNo, error: '$e');
    }
  }
}
