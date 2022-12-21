import 'dart:io';

import 'package:almagest/Models/models.dart';
import 'package:almagest/Models/user_alone.dart';
import 'package:almagest/services/product_service.dart';
import 'package:almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final articleService = ArticleService();
  final productService = ProductService();
  final userService = UserService();
  List<ArticleData> articles = [];
  List<ArticleData> articlesBuscar = [];
  String user = "";

  Future getArticles() async {
    await articleService.getArticles();
    setState(() {
      articles = articleService.articles;
      articlesBuscar = articles;
    });
  }

  Future getUser(String id) async {
    await userService.getUser();
    String companite = await userService.getUser() as String;
    setState(() {
      user = companite;
    });
  }

  @override
  void initState() {
    super.initState();
    getArticles();
    getUser(517.toString());
  }

  void _runFilter(String enteredKeyword) {
    List<ArticleData> results = [];
    if (enteredKeyword.isEmpty) {
      results = articles;
    } else {
      results = articles
          .where((x) => x.description!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      articlesBuscar = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, 'user');
      } else {
        Navigator.pushReplacementNamed(context, 'catalog');
      }
    }

    // final articleService = Provider.of<ArticleService>(context, listen: false);
    // articles = articleService.articles.cast<ArticleData>();
    // for (int i = 0; i < articles.length; i++) {
    //   if (articles[i].deleted == 1) {
    //     print(articles[i]);
    //   }
    // }
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
      body: articleService.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.blueGrey, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextField(
                          onChanged: (value) => _runFilter(value),
                          decoration: const InputDecoration(
                            labelText: '    Search',
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        child: builListView(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(30),
      itemCount: articlesBuscar.length,
      itemBuilder: (BuildContext context, index) {
        double min = double.parse('${articlesBuscar[index].priceMin}');
        double max = double.parse('${articlesBuscar[index].priceMax}');
        double mid = ((min + max) / 2);
        double _counter;
        return SizedBox(
          height: 250,
          child: Card(
            elevation: 20,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${articlesBuscar[index].name}',
                      style: const TextStyle(fontSize: 20)),
                  const Divider(color: Colors.black),
                  Text('${articlesBuscar[index].description}',
                      style: const TextStyle(fontSize: 35),
                      textAlign: TextAlign.center),
                  const Divider(color: Colors.black),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Price : $mid',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Divider(color: Colors.black),
                      GFIconButton(
                        onPressed: () {
                          print(user);
                          productService.addProduct(
                            articlesBuscar[index].id.toString(),
                            mid.toString(),
                            articlesBuscar[index].familyId.toString(),
                          );
                          setState(() {
                            articles.removeWhere((element) =>
                                (element == articlesBuscar[index]));
                            articlesBuscar.removeWhere((element) =>
                                (element == articlesBuscar[index]));
                          });
                        },
                        icon: const Icon(
                          Icons.add_shopping_cart_sharp,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
