import 'package:almagest/Models/models.dart';
import 'package:almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrdersService>(context);
    List<OrdersData> orders = ordersService.orders;
    // ignore: no_leading_underscores_for_local_identifiers

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(children: [
          Text(
            'Orders',
          ),
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
        centerTitle: true,
      ),
      body: ordersService.isLoading
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
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(30),
                      itemCount: orders.length,
                      itemBuilder: (BuildContext context, index) {
                        return SizedBox(
                          height: 250,
                          child: Card(
                            elevation: 20,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('${orders[index].num}',
                                            style:
                                                const TextStyle(fontSize: 20)),
                                        Text('${orders[index].issueDate}',
                                            style:
                                                const TextStyle(fontSize: 20))
                                      ]),
                                  const Divider(color: Colors.black),
                                  Text('${orders[index].targetCompanyName}',
                                      style: const TextStyle(fontSize: 35),
                                      textAlign: TextAlign.center),
                                  Text('${orders[index].createdAt}',
                                      style: const TextStyle(fontSize: 35),
                                      textAlign: TextAlign.center),
                                  const Divider(color: Colors.black),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Divider(color: Colors.black),
                                      if (orders[index].deliveryNotes == 1)
                                        Icon(
                                          Icons.delivery_dining,
                                          color: Colors.greenAccent,
                                        )
                                      else
                                        Icon(
                                          Icons.delivery_dining,
                                          color: Colors.red,
                                        ),
                                      if (orders[index].invoices == 1)
                                        Icon(
                                          Icons.library_books_outlined,
                                          color: Colors.greenAccent,
                                        )
                                      else
                                        Icon(
                                          Icons.library_books_outlined,
                                          color: Colors.red,
                                        )
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                    SizedBox(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
