import 'package:flutter/material.dart';
import 'package:productos_app/Models/ciclos.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/services/services.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

import 'package:http/http.dart' as http;

// class getCicles extends ChangeNotifier {
//   String _baseUrl = 'http://salesin.allsites.es/public/api/cicles';

//   CiclesProvider() {
//     print('Inicializando');
//   }

//   getCiclesName() async {
//     var url = Uri.https(_baseUrl);

//     final response = await http.get(url);

//     print(response.body);
//   }
// }

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 250),
          CardContainer(
              child: Column(
            children: [
              SizedBox(height: 10),
              Text('Crear cuenta',
                  style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(), child: _RegisterForm())
            ],
          )),
          SizedBox(height: 50),
          TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: Text(
                '¿Ya tienes una cuenta?',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              )),
          SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ciclesProvider = Provider.of<GetCicles>(context);
    List<Ciclos> ciclos = ciclesProvider.getAllCiclos;
    String _selectedItem = ciclos[0].nameCicle;
    List<String> _options = [];

    for (var i = 0; i < ciclos.length; i++) {
      _options.add(ciclos[i].nameCicle);
    }

    final registerForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          // ignore: sort_child_properties_last
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '', labelText: 'Name', prefixIcon: Icons.person),
              onChanged: (value) => registerForm.name = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'Name field cant be null';
              },
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '', labelText: 'Surname', prefixIcon: Icons.person),
              onChanged: (value) => registerForm.surname = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'Surname field cant be null';
              },
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => registerForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
              },
            ),
            DropdownButton(
              value: _selectedItem,
              items: _options
                  .map(
                    (day) => DropdownMenuItem(
                      child: Text(day),
                      value: day,
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                _selectedItem = value.toString();
              },
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      registerForm.isLoading ? 'Espere' : 'Registrar',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: registerForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!registerForm.isValidForm()) return;

                        // registerForm.isLoading = true;

                        //validar si el login es correcto
                        final String? errorMessage =
                            await authService.createUser(
                          registerForm.name,
                          registerForm.surname,
                          registerForm.email,
                          registerForm.password,
                        );

                        if (errorMessage == null) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          //mostrar error en pantalla
                          print(errorMessage);
                          registerForm.isLoading = false;
                        }
                      })
          ],
        ),
      ),
    );
  }
}
