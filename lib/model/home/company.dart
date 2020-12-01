import 'package:equatable/equatable.dart';

class Company with EquatableMixin {
  final String id;
  final String name;
  final String image;
  final String title;
  final DateTime dateTime;
  Company(this.id, this.name, this.image, this.title, this.dateTime);

  @override
  List<Object> get props => [id];
}
