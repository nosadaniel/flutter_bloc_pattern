// To parse this JSON data, do
//
//     final newsArticle = newsArticleFromJson(jsonString);

import 'dart:convert';

import 'article.dart';

NewsArticle newsArticleFromJson(String str) =>
    NewsArticle.fromJson(json.decode(str));

String newsArticleToJson(NewsArticle data) => json.encode(data.toJson());

class NewsArticle {
  NewsArticle({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  String status;
  int totalResults;
  List<Article> articles;

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}
