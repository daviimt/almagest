import 'dart:ffi';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import 'screens.dart';

class GraphsScreen extends StatefulWidget {
  const GraphsScreen({key});

  @override
  State<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  List<CatalogData> products = [];
  List<DataGraphs> listaSinSentido = [];
  List listaPedidos = [];
  String? company_id = "";
  List<DateTime> listaFechas = [];
  int cont = 0;
  bool primeraVez = false;

  getList() async {
    company_id = await userAlone().readCompany_id();
    products.clear();
    listaSinSentido.clear();
    final productsService =
        Provider.of<CatalogService2>(context, listen: false);
    final graphsService = Provider.of<GraphService>(context, listen: false);

    await productsService.getCatalog(company_id);
    await graphsService.getGraphs();
    setState(() {
      products = productsService.aux;
      listaSinSentido = graphsService.listaSinSentido;
    });
  }

  getDataGraph(int id) {
    cont = 0;
    listaPedidos = [0, 0, 0, 0, 0, 0];
    if (!primeraVez) {
      DateTime now = new DateTime.now();
      DateTime hace1Mes = DateTime(now.year, now.month - 1, now.day);
      DateTime hace2Mes = DateTime(now.year, now.month - 2, now.day);
      DateTime hace3Mes = DateTime(now.year, now.month - 3, now.day);
      DateTime hace4Mes = DateTime(now.year, now.month - 4, now.day);
      DateTime hace5Mes = DateTime(now.year, now.month - 5, now.day);
      DateTime hace6Mes = DateTime(now.year, now.month - 6, now.day);
      listaFechas.add(hace1Mes);
      listaFechas.add(hace2Mes);
      listaFechas.add(hace3Mes);
      listaFechas.add(hace4Mes);
      listaFechas.add(hace5Mes);
      listaFechas.add(hace6Mes);
      primeraVez = true;
    }
    for (var z in listaFechas) {
      for (var i in listaSinSentido) {
        if (DateTime.parse(i.issueDate.toString()).month == z.month) {
          for (var x in i.orderLines!) {
            for (var j in x.articlesLine!) {
              if (j.articleId as int == id) {
                setState(() {
                  listaPedidos[cont] += 1;
                });
              }
            }
          }
        }
      }
      cont++;
      print("PATATA " + cont.toString());
      print(listaPedidos);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    final producForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphs'),
      ),
      body: SizedBox(
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  DropdownButtonFormField(
                    hint: const Text('Select a Product'),
                    items: products.map((e) {
                      return DropdownMenuItem(
                        value: e.articleId,
                        child: Text(e.compamyName.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      producForm.id = int.parse(value.toString());
                    },
                    validator: (value) {
                      return (value != null && value != 0)
                          ? null
                          : 'select a Product';
                    },
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 0,
                    color: Colors.blueGrey[600],
                    onPressed: () {
                      if (producForm.id != null) {
                        getDataGraph(producForm.id);
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      child: Text(
                        'Add Product',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!listaPedidos.isEmpty)
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Past 6 month analisis'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                        dataSource: <_SalesData>[
                          _SalesData(
                              listaFechas[0].month, listaPedidos[0].toString()),
                          _SalesData(
                              listaFechas[1].month, listaPedidos[1].toString()),
                          _SalesData(
                              listaFechas[2].month, listaPedidos[2].toString()),
                          _SalesData(
                              listaFechas[3].month, listaPedidos[3].toString()),
                          _SalesData(
                              listaFechas[4].month, listaPedidos[4].toString()),
                          _SalesData(
                              listaFechas[5].month, listaPedidos[5].toString())
                        ],
                        xValueMapper: (_SalesData sales, _) =>
                            sales.year.toString(),
                        yValueMapper: (_SalesData sales, _) =>
                            int.parse(sales.sales),
                        name: 'Orders',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ]),
          ],
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);
  final int year;
  final String sales;
}
