import 'package:almagest/Models/models.dart';
import 'package:almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final articleService = ArticleService();
  List<ArticleData> articles = [];

  Future getArticle() async {
    await articleService.getArticles();
    setState(() {
      articles = articleService.articles;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('User'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ),
        body: articleService.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Center(
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: true,
                    child: SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Center(
                        child: Text('Catalog',
                            style: Theme.of(context).textTheme.headline2),
                      ),
                    ),
                  ),
                ]),
              )));
  }
}
