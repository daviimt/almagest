import 'package:almagest/Models/models.dart';
import 'package:almagest/services/product_service.dart';
import 'package:almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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
  List<ProductData> products = [];
  List<ArticleData> articles = [];
  List<ArticleData> articlesBuscar = [];
  String user = "";
  int cont = 0;
  bool desactivate = true;

  Future getArticles() async {
    await articleService.getArticles();
    await productService.getProducts();
    setState(() {
      articles = articleService.articles;
      products = productService.products;
      cont = products.length;
      if (cont >= 5) {
        desactivate = false;
      }

      articlesBuscar = articles;
      for (int i = 0; i < products.length; i++) {
        articlesBuscar
            .removeWhere((element) => (element.id == products[i].articleId));
      }
    });
  }

  Future getUser() async {
    await userService.getUser();
    String companie = await userService.getUser() as String;
    setState(() {
      user = companie;
    });
  }

  @override
  void initState() {
    super.initState();
    // ignore: avoid_print
    print('iniciando');
    getArticles();
    getUser();
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
        actions: [Text('$cont/5')],
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
                      Container(
                          margin: EdgeInsets.all(10),
                          width: 150,
                          height: 50,
                          child: SpinBox(
                              min: min,
                              max: max,
                              step: 0.1,
                              readOnly: true,
                              decimals: 2,
                              value: mid,
                              onChanged: (value) {
                                mid = value;
                              })),
                      const Divider(color: Colors.black),
                      GFIconButton(
                        onPressed: () {
                          if (cont < 5) {
                            productService.addProduct(
                              articlesBuscar[index].id.toString(),
                              mid.toString(),
                              articlesBuscar[index].familyId.toString(),
                            );
                            cont++;
                            setState(() {
                              // articles.removeWhere((element) =>
                              //     (element == articlesBuscar[index]));
                              articlesBuscar.removeWhere((element) =>
                                  (element == articlesBuscar[index]));
                            });
                          } else {
                            customToast('Elements limit reached', context);
                          }
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

  void customToast(String s, BuildContext context) {
    showToast(
      s,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}
