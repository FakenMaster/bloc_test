import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time/time.dart';
import 'package:rxdart/rxdart.dart';
part 'search_stream_state.dart';

class SearchStreamCubit extends Cubit<SearchStreamState> {
  SearchStreamCubit() : super(SearchStreamInitial()) {
    keywordController = StreamController<String>.broadcast();
    keywordController.stream.throttle((event) => null);
  }

  StreamController<String> keywordController;
  StreamSubscription<String> streamSubscription;

  void search(String keyword) {}

  Future<List<String>> _getFakeData() async {
    await Future.delayed(5.seconds);
    return List.generate(10, (index) => '$index');
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    keywordController.close();
    return super.close();
  }
}
