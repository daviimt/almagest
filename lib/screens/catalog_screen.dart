import 'package:almagest/Models/models.dart';
import 'package:almagest/services/product_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:almagest/services/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

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

  List<ProductData> productos = [];
  List<ArticleData> articles = [];

  Future getProducts() async {
    await productService.getProducts();
    setState(() {
      productos = productService.products;
      print(productos);
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

    for (int i = 0; i < productos.length; i++) {
      print(productos[i]);
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
        return Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (BuildContext _) async {
                  await CoolAlert.show(
                    context: context,
                    type: CoolAlertType.warning,
                    title: 'Confirmar',
                    text: '¿Estás seguro de eliminar el producto seleccionado?',
                    showCancelBtn: true,
                    confirmBtnColor: Colors.purple,
                    confirmBtnText: 'Eliminar',
                    onConfirmBtnTap: () {
                      setState(() {
                        productService.deleteProduct(
                            productos[index].articleId.toString());
                        productos.removeAt(index);
                      });
                    },
                    onCancelBtnTap: () => Navigator.pop(context),
                    cancelBtnText: 'Cancelar',
                  );
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Eliminar',
              ),
            ],
          ),
          child: SizedBox(
            height: 250,
            child: Card(
              elevation: 20,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('${productos[index].compamyDescription}',
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
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
