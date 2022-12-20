import 'package:almagest/Models/articles.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('data');
  }

  Widget _emptyContainer() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black,
          size: 130,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    } else {}

    final articleService = ArticleService();

    return FutureBuilder(
      future: articleService.getArticles(),
      builder: (_, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final articles = snapshot.data;

        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (_, int index) => _ArticleItem(articles[index]),
        );
      },
    );
  }
}

class _ArticleItem extends StatelessWidget {
  final ArticleData article;

  const _ArticleItem(this.article);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(article.name!),
    );
  }
}
