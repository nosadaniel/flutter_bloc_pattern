import 'package:bloc_demo/bloc/news_bloc.dart';
import 'package:bloc_demo/model/article.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsArticleView extends StatefulWidget {
  const NewsArticleView({Key? key}) : super(key: key);

  @override
  State<NewsArticleView> createState() => _NewsArticleViewState();
}

class _NewsArticleViewState extends State<NewsArticleView> {
  final NewsBloc _newsBloc = NewsBloc();

  @override
  void initState() {
    _newsBloc.getArticles(NewsAction.fetch);
    super.initState();
  }

  @override
  void dispose() {
    _newsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: StreamBuilder(
        stream: _newsBloc.articleStream,
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Article article = snapshot.data![index];
                String formattedTime =
                    DateFormat('dd MMM - HH:mm').format(article.publishedAt!);

                return Container(
                  height: 100,
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(article.urlToImage!,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) =>
                                  const Center(
                                      child: Text(
                                    "Missing Image",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.red),
                                  ))),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formattedTime),
                          Text(
                            article.title!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(article.description!,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ))
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
