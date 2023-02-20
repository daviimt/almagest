import 'package:almagest/Models/family.dart';
import 'package:almagest/Models/models.dart';
import 'package:almagest/services/product_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:almagest/services/services.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final productService = ProductService();

  List<ProductData> productos = [];
  List<FamilyData> families = [];

  Future getProducts() async {
    await productService.getProducts();
    setState(() {
      productos = productService.products;
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
            icon: const Icon(Icons.markunread_mailbox_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed('orders');
            },
          ),
          IconButton(
            icon: const Icon(Icons.graphic_eq),
            onPressed: () {
              Navigator.of(context).pushNamed('graphs');
            },
          ),
        ],
      ),
      body: builListView(context, productos),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Articles'),
        ],
        currentIndex: 0, //New
        onTap: _onItemTapped,
      ),
    );
  }

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
                  Text('${productos[index].compamyDescription}',
                      style: const TextStyle(fontSize: 20)),
                  const Divider(color: Colors.black),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Price : ${productos[index].price}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Divider(color: Colors.black),
                      GFIconButton(
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete Product'),
                              content: const Text('Are you sure?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    productService.deleteProduct(
                                        productos[index].id.toString());
                                    setState(() {
                                      productos.removeWhere((element) =>
                                          (element == productos[index]));
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outlined,
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
