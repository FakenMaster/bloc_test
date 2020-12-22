import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    addError(Exception('increment error!'), StackTrace.current);
    emit(state + 1);
  }

  @override
  void onChange(Change<int> change) {
    print(change);
    super.onChange(change);
  }
}

class MyStream extends Stream<int> {
  @override
  StreamSubscription<int> listen(void Function(int event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
        
  }
}
