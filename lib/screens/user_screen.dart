import 'package:almagest/Models/models.dart';
import 'package:almagest/screens/catalog_screen.dart';
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
  Future getArticles() async {
    await articleService.getArticles();
    setState(() {
      articles = articleService.articles;
    });
  }

  @override
  void initState() {
    super.initState();
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, 'user');
      } else {
        Navigator.pushReplacementNamed(context, 'catalog');
      }
    }

    // final articleService = Provider.of<ArticleService>(context, listen: false);
    // articles = articleService.articles.cast<ArticleData>();
    for (int i = 0; i < articles.length; i++) {
      if (articles[i].deleted == 1) {
        print(articles[i]);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: builListView(context),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Articles'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Catalog'),
        ],
        currentIndex: 0, //New
        onTap: _onItemTapped,
      ),
    );
  }

  Widget builListView(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(50),
      itemCount: articles.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 150,
          color: Colors.blueGrey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '${articles[index].name}',
              style: TextStyle(fontSize: 30),
            ),
            const Divider(color: Colors.black),
            Text('${articles[index].description}'),
            const Divider(color: Colors.black),
            Text('${articles[index].priceMin}'),
          ]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
