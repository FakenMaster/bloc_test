import 'package:equatable/equatable.dart';

class Trending with EquatableMixin {
  final String id;
  final DateTime dateTime;
  final String title;
  final List<String> tags;

  Trending({this.id, this.dateTime, this.title, this.tags})
      : assert(id != null);
  @override
  List<Object> get props => [id];
}
