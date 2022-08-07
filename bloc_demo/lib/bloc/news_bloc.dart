import 'dart:async';
import 'dart:developer';

import 'package:bloc_demo/model/article.dart';
import 'package:bloc_demo/service/news_api.dart';

enum NewsAction { fetch }

class NewsBloc {
  final StreamController<List<Article>> _statesStreamController =
      StreamController<List<Article>>();
  StreamSink<List<Article>> get _articleSink => _statesStreamController.sink;
  Stream<List<Article>> get articleStream => _statesStreamController.stream;

  final StreamController<NewsAction> _eventStreamController =
      StreamController<NewsAction>();

  StreamSink<NewsAction> get _eventSink => _eventStreamController.sink;

  Stream<NewsAction> get _eventStream => _eventStreamController.stream;

  void getArticles(NewsAction event) {
    _eventSink.add(event);
  }

  void dispose() {
    _statesStreamController.close();
    _eventStreamController.close();
  }

  NewsBloc() {
    List<Article>? articles;
    _eventStream.listen((event) async {
      if (event == NewsAction.fetch) {
        try {
          articles = await NewsApi.getNews();
          if (articles != null) {
            _articleSink.add(articles!);
          } else {
            _articleSink.addError('Something went wrong');
          }
        } on Exception catch (e) {
          log("Something went wrong => $e");
          _articleSink.addError('Something went wrong');
        }
      }
    });
  }
}
