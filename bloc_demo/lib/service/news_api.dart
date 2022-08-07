import 'dart:developer';

import 'package:bloc_demo/constant/api_key.dart';
import 'package:bloc_demo/constant/news_api_url.dart';
import 'package:bloc_demo/model/news_article.dart';
import 'package:http/http.dart' as http;

import '../model/article.dart';

class NewsApi {
  static Future<List<Article>?> getNews() async {
    final http.Client client = http.Client();
    List<Article>? articles;
    try {
      final http.Response response =
          await client.get(Uri.parse(newsApiUrlPath + apiKey));
      if (response.statusCode == 200) {
        String responseBody = response.body;
        NewsArticle newsArticle = newsArticleFromJson(responseBody);
        articles = newsArticle.articles;
      }
      return articles;
    } catch (e, s) {
      log("$e \n $s");
      return null;
    }
  }
}
