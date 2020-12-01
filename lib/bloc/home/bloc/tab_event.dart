part of 'tab_bloc.dart';

abstract class TabEvent extends Equatable {
  const TabEvent();

  @override
  List<Object> get props => [];
}

class TabRefreshEvent extends TabEvent {
  final int pageSize;

  TabRefreshEvent({this.pageSize});
  @override
  List<Object> get props => [];
}

class TabLoadEvent extends TabEvent {
  final int pageNo;
  final int pageSize;
  TabLoadEvent({this.pageNo, this.pageSize = 15}) : assert(pageNo != null);

  @override
  List<Object> get props => [pageNo];
}
