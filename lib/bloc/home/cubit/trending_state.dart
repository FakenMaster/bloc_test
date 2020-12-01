part of 'trending_cubit.dart';

abstract class TrendingState extends Equatable {
  const TrendingState();

  @override
  List<Object> get props => [];
}

class TrendingInitial extends TrendingState {}

class TrendingSuccessState extends TrendingState {
  final int pageNo;
  final List<Trending> trendings;

  TrendingSuccessState(this.pageNo, this.trendings);

  @override
  List<Object> get props => [pageNo];
}

class TrendingFailState extends TrendingState {
  final int pageNo;
  final String error;

  TrendingFailState({this.pageNo, this.error});
}

class TrendingRefreshingState extends TrendingState{
  
}

class TrendingLoadingState extends TrendingState {

}