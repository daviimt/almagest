import 'package:almagest/Models/models.dart';
import 'package:almagest/services/product_service.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:almagest/services/services.dart';
import 'package:provider/provider.dart';
import '../Search/search_delegate.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final productService = ProductService();
  final userService = UserService();
  final authService = AuthService();
  final articleService = ArticleService();

  List<ProductData> products = [];
  List<ArticleData> articles = [];

  Future getProducts() async {
    await productService.getProducts();
    setState(() {
      products = productService.products;
      print(products);
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
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

    for (int i = 0; i < products.length; i++) {
      print(products[i]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search_outlined),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()))
        ],
      ),
      body: builListView(context, products),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_box_outlined),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Articles'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Catalog'),
        ],
        currentIndex: 1, //New
        onTap: _onItemTapped,
      ),
    );
  }

  int _counterValue = 0;
  Widget builListView(BuildContext context, List articles) {
    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: articles.length,
      itemBuilder: (BuildContext context, index) {
        return SizedBox(
          height: 250,
          child: Card(
            elevation: 20,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${articles[index].name}',
                      style: const TextStyle(fontSize: 30)),
                  const Divider(color: Colors.black),
                  Text('${articles[index].description}',
                      style: const TextStyle(fontSize: 20)),
                  const Divider(color: Colors.black),
                  CounterButton(
                    loading: false,
                    onChange: (min) {
                      setState(() {
                        _counterValue = min;
                      });
                    },
                    count: _counterValue,
                    countColor: Colors.purple,
                    buttonColor: Colors.purpleAccent,
                    progressColor: Colors.purpleAccent,
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
