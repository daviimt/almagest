import 'package:almagest/Models/articles.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('data');
  }

  Widget _emptyContainer() {
    return Container(
      child: Center(
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
    List<ArticleData> articles = [];
    Future getArticles() async {
      await articleService.getArticles();
    }

    return FutureBuilder(
      future: articleService.getArticles(),
      builder: (_, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        return Container();
      },
    );
  }
}
