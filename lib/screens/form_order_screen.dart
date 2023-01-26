import 'package:almagest/Models/models.dart';
import 'package:almagest/screens/screens.dart';
import 'package:almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';

class FormOrderScreen extends StatelessWidget {
  const FormOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrdersService>(context);
    List<OrdersData> orders = ordersService.orders;
    final ciclesProvider = Provider.of<GetCompanies>(context);
    List<Companies> ciclos = ciclesProvider.getAllCompanies;
    List<Companies> options = [];
    if (ciclos.isNotEmpty) {
      for (var i = 0; i < ciclos.length; i++) {
        options.add(ciclos[i]);
      }
    }

    // ignore: no_leading_underscores_for_local_identifiers

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(children: [
          Text(
            'Form Order',
          ),
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
        centerTitle: true,
      ),
      body: ordersService.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : DropdownButtonFormField<Companies>(
              decoration: InputDecorations.authInputDecoration(
                  prefixIcon: Icons.view_week_outlined,
                  hintText: '',
                  labelText: 'Company'),
              // value: selectedItem,
              items: options
                  .map(
                    (courseName) => DropdownMenuItem(
                      value: courseName,
                      child: Text(courseName.nameCompanie),
                    ),
                  )
                  .toList(),
              onChanged: (value) {},
              validator: (cicle) {},
            ),
    );
  }
}
