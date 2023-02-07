import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:almagest/Models/catalog.dart';
import 'package:almagest/services/catalog_service.dart';
import 'package:almagest/services/catalog_service2.dart';
import 'package:almagest/services/cicle_service.dart';
import 'package:almagest/services/new_order_service.dart';
import 'package:almagest/services/product_service.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import '../models/cicles.dart';
import 'package:almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../providers/register_form_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class FormOrderScreen extends StatelessWidget {
  const FormOrderScreen({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Form(
          child: Column(children: [
            ChangeNotifierProvider(
              create: (_) => RegisterFormProvider(),
              child: const _RegisterForm(),
            ),
          ]),
        )),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({key});

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  bool buttonState = false;
  List<CatalogData> products = [];
  List<bool> isChecked = [];
  Map<String, String> pedido = {};
  String? company_id = "";
  final userservice = UserService();

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  Future getCompanyId() async {
    String compania = await userservice.readCompany_id();
    setState(() {
      company_id = compania;
    });
  }

  @override
  void initState() {
    print('INICIO DE INIT');
    super.initState();
    getCompanyId();
  }

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    final ciclesService = Provider.of<CiclesService>(context);
    final productsService = Provider.of<CatalogService2>(context);
    List<Data> ciclos = ciclesService.ciclos;
    List<Data> aux = [];

    Data miEmpresa = Data();
    double precioTotal = 0;
    getPrecio(int cant, double precio) {
      double preci = cant * precio;
      precioTotal += preci;
      return preci;
    }

    for (var i in ciclos) {
      if (i.id.toString() != company_id) {
        aux.add(i);
      }
      print(i.id.toString() + ' ' + company_id.toString());
    }
    for (var i in ciclos) {
      if (i.id.toString() == company_id) {
        miEmpresa = i;
      }
    }

    DateTime now = new DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String fechaFormat = formatter.format(date);
    Future<String> getlocalPath() async {
      final directory = await getApplicationDocumentsDirectory();

      return directory.path;
    }

    getList() async {
      products.clear();
      await productsService.getCatalog(registerForm.cicleid);
      setState(() {
        products = productsService.aux;
        isChecked = List<bool>.filled(products.length, false);
      });
    }

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          width: 300.0,
          child: DropdownButtonFormField(
            icon: Icon(Icons.keyboard_double_arrow_down_rounded),
            hint: const Text('Select a company'),
            iconSize: 40,
            items: aux.map((e) {
              return DropdownMenuItem(
                value: e.id,
                child: Text(e.name.toString()),
              );
            }).toList(),
            onChanged: (value) {
              registerForm.cicleid = value! as int;
            },
            validator: (value) {
              return (value != null && value != 0) ? null : 'Select a Company';
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledColor: Colors.black,
          elevation: 0,
          color: Colors.blue[900],
          onPressed: () {
            buttonState = true;
            getList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: const Text(
              'List Products',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * (products.length / 11.5),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            itemBuilder: (BuildContext ctxt, int index) {
              double valorPrueba = 0;
              return Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        checkColor: Colors.black,
                        value: isChecked[index],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[index] = value!;
                            if (!isChecked[index]) {
                              pedido
                                  .remove(products[index].articleId.toString());
                            }
                          });
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          products[index].compamyDescription.toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Visibility(
                            visible: isChecked[index],
                            child: SpinBox(
                                min: 1,
                                max: 40,
                                step: 1,
                                readOnly: true,
                                decimals: 0,
                                value: valorPrueba,
                                onChanged: (value) {
                                  valorPrueba = value;
                                  print(pedido);
                                  pedido[products[index].articleId.toString()] =
                                      value.toInt().toString();
                                }),
                          ),
                        ),
                      ),
                    ],
                  ));
            },
          ),
        ),
        if (buttonState == true && ciclesService.isLoading == false)
          Container(
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.white,
              color: Colors.blue[900],
              onPressed: () async {
                if (pedido.isEmpty) {
                  customToast('Debes seleccionar un producto', context);
                } else {
                  final newOrderService =
                      Provider.of<NewOrderService>(context, listen: false);
                  int num = 1 + Random().nextInt((99999 + 1) - 1);
                  newOrderService.getNewOrder(num.toString(), pedido, date,
                      company_id!, registerForm.cicleid.toString());
                  final pdf = pw.Document();
                  Data targetCompany = Data();
                  for (var i in ciclos) {
                    if (i.id.toString() == registerForm.cicleid.toString()) {
                      targetCompany = i;
                    }
                  }
                  pdf.addPage(pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (pw.Context context) {
                        return pw.Column(children: [
                          pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Table(
                                    border: pw.TableBorder.all(),
                                    children: [
                                      pw.TableRow(children: [
                                        pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.SizedBox(height: 10),
                                              pw.Text(targetCompany.name
                                                  .toString()),
                                              pw.Text(targetCompany.address
                                                  .toString()),
                                              pw.Text(targetCompany.city
                                                  .toString()),
                                              pw.Text(
                                                  targetCompany.cif.toString()),
                                              pw.Text(targetCompany.email
                                                  .toString()),
                                              pw.SizedBox(height: 10),
                                            ]),
                                      ]),
                                    ]),
                                pw.Table(
                                    border: pw.TableBorder.all(),
                                    children: [
                                      pw.TableRow(children: [
                                        pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.SizedBox(height: 10),
                                              pw.Row(children: [
                                                pw.Text('PEDIDO Nº: ',
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.bold)),
                                                pw.Text(num.toString())
                                              ]),
                                              pw.SizedBox(height: 20),
                                              pw.Row(children: [
                                                pw.Text('FECHA: ',
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.bold)),
                                                pw.Text(fechaFormat)
                                              ]),
                                              pw.SizedBox(height: 10),
                                            ]),
                                      ]),
                                    ]),
                              ]),
                          pw.SizedBox(height: 25),
                          pw.Row(children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(children: [
                                    pw.Text("DIRECCIÓN DE ENVÍO: ",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text(miEmpresa.address.toString())
                                  ]),
                                  pw.Row(children: [
                                    pw.Text("TRANSPORTE: ",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text("A NUESTRO CARGO")
                                  ]),
                                ])
                          ]),
                          pw.SizedBox(height: 20),
                          pw.Table(border: pw.TableBorder.all(), children: [
                            pw.TableRow(children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("REF. COD",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                  ]),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("DESCRIPCIÓN",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                  ]),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("CANTIDAD",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                  ]),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("PRECIO",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                  ]),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("IMPORTE",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                  ]),
                            ]),
                            for (var producto in products)
                              for (var entry in pedido.entries)
                                if (producto.articleId.toString() == entry.key)
                                  pw.TableRow(children: [
                                    pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        children: [
                                          pw.Text(
                                              producto.articleId.toString()),
                                        ]),
                                    pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        children: [
                                          pw.Text(producto.compamyDescription
                                              .toString()),
                                        ]),
                                    pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        children: [
                                          pw.Text(pedido[producto.articleId
                                                  .toString()] ??
                                              'Google'),
                                        ]),
                                    pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        children: [
                                          pw.Text(producto.price.toString()),
                                        ]),
                                    pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        children: [
                                          pw.Text(getPrecio(
                                                  int.parse(pedido[producto
                                                          .articleId
                                                          .toString()] ??
                                                      "1"),
                                                  double.parse(producto.price!))
                                              .toStringAsFixed(2)),
                                        ]),
                                  ]),
                            pw.TableRow(children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("TOTAL: ",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                  ]),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: []),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: []),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: []),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(precioTotal.toStringAsFixed(2)),
                                  ])
                            ])
                          ])
                        ]);
                      }));

                  final file = File(
                      "${"/storage/emulated/0/Download/" + "pedido" + num.toString()}.pdf");
                  await file.writeAsBytes(await pdf.save());

                  final Email email = Email(
                    body: 'Resguardo Pedido',
                    subject: 'Pedido',
                    recipients: ['naframu00@gmail.com'],
                    isHTML: false,
                  );
                  String emailResponse;

                  try {
                    print('trying');
                    await FlutterEmailSender.send(email);
                    emailResponse = 'success';
                  } catch (error) {
                    print('error');
                    emailResponse = error.toString();
                  }

                  print('aaaaa' + emailResponse);
                  customToast('Pedido realizado', context);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: const Text(
                  'Realizar pedido',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
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
