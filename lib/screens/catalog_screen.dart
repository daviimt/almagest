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
      ),
      body: builListView(context, productos),
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
                        onPressed: () async {
                          await CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            title: 'Confirmar',
                            text:
                                '¿Estás seguro de eliminar el producto seleccionado? Tras eliminar el seleccionado pulsar fuera de la alerta.',
                            confirmBtnColor: Colors.purple,
                            confirmBtnText: 'Eliminar',
                            onConfirmBtnTap: () {
                              productService.deleteProduct(
                                  productos[index].id.toString());
                              setState(() {
                                productos.removeAt(index);
                              });
                            },
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
