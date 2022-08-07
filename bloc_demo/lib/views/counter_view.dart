import 'package:flutter/material.dart';

import '../bloc/counter_bloc.dart';

class CounterView extends StatefulWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterBloc counterBloc = CounterBloc();

  void _increment() {
    counterBloc.inputEventStream(CounterAction.increment);
  }

  void _decrement() {
    counterBloc.inputEventStream(CounterAction.decrement);
  }

  void _reset() {
    counterBloc.inputEventStream(CounterAction.reset);
  }

  @override
  void dispose() {
    counterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<Object>(
                stream: counterBloc.counterStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Opp, something went wrong',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  } else {
                    return Text(
                      'No data available yet',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _decrement,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: _reset,
            tooltip: 'Reset',
            child: const Icon(Icons.restart_alt_sharp),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
