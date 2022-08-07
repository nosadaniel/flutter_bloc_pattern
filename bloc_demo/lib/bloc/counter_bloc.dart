import 'dart:async';

enum CounterAction { increment, decrement, reset }

class CounterBloc {
  final StreamController<int> _statesStreamController = StreamController<int>();

  //accept stream
  StreamSink<int> get _counterSink {
    return _statesStreamController.sink;
  }

  //output stream to ui via streamBuilder
  Stream<int> get counterStream {
    return _statesStreamController.stream;
  }

  final StreamController<CounterAction> _eventStreamController =
      StreamController<CounterAction>();

  StreamSink<CounterAction> get _eventSink {
    return _eventStreamController.sink;
  }

  Stream<CounterAction> get _eventStream {
    return _eventStreamController.stream;
  }

  CounterBloc() {
    int counter = 0;

    //listen to event that entered eventStream via eventSink
    _eventStream.listen((event) {
      if (event == CounterAction.increment) {
        counter++;
      }
      if (event == CounterAction.decrement) {
        if (counter > 0) {
          counter--;
        }
      }
      if (event == CounterAction.reset) {
        counter = 0;
      }
      //add count to counterState using _counterSink
      _counterSink.add(counter);
    });
  }

  void inputEventStream(CounterAction counterAction) {
    _eventSink.add(counterAction);
  }

  void dispose() {
    _statesStreamController.close();
    _eventStreamController.close();
  }
}
