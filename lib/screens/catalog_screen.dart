import 'package:flutter/material.dart';
import 'package:almagest/services/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:almagest/Models/models.dart';

List<Data> articles = [];

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articleService = Provider.of<ArticleService>(context, listen: false);
    articles = articleService.articles.cast<Data>();
    List<Data> articlesFinal = [];
    for (int i = 0; i < articles.length; i++) {
      articlesFinal.add(articles[i]);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: Center(
        child:
            builListView(context, buildArticleService(context), articlesFinal),
      ),
    );
  }

  ArticleService buildArticleService(BuildContext context) {
    final articleService = Provider.of<ArticleService>(context);
    return articleService;
  }

  Widget buildArticleListTile(article) => ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(article.id + ' ' + article.name),
        subtitle: Text(article.description),
      );

  Widget builListView(
          BuildContext context, ArticleService articleService, List articles) =>
      ListView.separated(
          itemBuilder: (context, index) {
            final article = articles[index];
            return Slidable(
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.add_box_outlined,
                    label: 'Añadir',
                  )
                ],
              ),
              child: buildArticleListTile(article),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: articles.length);
}
