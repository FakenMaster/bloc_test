part of 'tab_bloc.dart';

abstract class TabState extends Equatable {
  const TabState();

  @override
  List<Object> get props => [];
}

class TabInitial extends TabState {}

class TabSuccessState extends TabState {
  final int pageNo;
  final List<Trending> trendings;

  TabSuccessState(this.pageNo, this.trendings);

  @override
  List<Object> get props => [pageNo];
}

class TabFailState extends TabState {
  final int pageNo;
  final String error;

  TabFailState({this.pageNo, this.error});
}

class TabRefreshingState extends TabState {}

class TabLoadingState extends TabState {}
