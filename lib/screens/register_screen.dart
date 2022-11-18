import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import 'package:almagest/services/services.dart';
import 'package:almagest/Models/models.dart';
import 'package:almagest/widgets/widgets.dart';
import 'package:almagest/ui/input_decorations.dart';

import 'package:http/http.dart' as http;

import '../providers/providers.dart';

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
                  create: (_) => RegisterFormProvider(), child: _RegisterForm())
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
    Ciclos selectedItem = ciclos[0];
    List<Ciclos> options = [];
    for (var i = 0; i < ciclos.length; i++) {
      options.add(ciclos[i]);
    }

    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          // ignore: sort_child_properties_last
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '', labelText: 'Name', prefixIcon: Icons.person),
              onChanged: (value) => registerForm.name = value,
              validator: (value) {
                return (value != null && value.length > 1)
                    ? null
                    : 'Name field cant be null';
              },
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '', labelText: 'Surname', prefixIcon: Icons.person),
              onChanged: (value) => registerForm.surname = value,
              validator: (value) {
                return (value != null && value.length > 1)
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
                RegExp regExp = RegExp(pattern);

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
                  hintText: '*******',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 8)
                    ? null
                    : 'The password lenght must be longer than 8';
              },
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*******',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => registerForm.c_password = value,
              validator: (value) {
                return (value == registerForm.password)
                    ? null
                    : 'The password must be equals';
              },
            ),
            DropdownButtonFormField<Ciclos>(
              value: selectedItem,
              items: options
                  .map(
                    (courseName) => DropdownMenuItem(
                      value: courseName,
                      child: Text(courseName.nameCicle),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                registerForm.cicle_id = (value?.idCicle.toInt())!;
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
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
                                registerForm.c_password,
                                registerForm.cicle_id);

                        if (errorMessage == null) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          //mostrar error en pantalla
                          customToast(
                              'The email is already registered', context);
                          registerForm.isLoading = false;
                        }
                      },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    child: Text(
                      registerForm.isLoading ? 'Espere' : 'Registrar',
                      style: const TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }

  void customToast(String s, BuildContext context) {
    showToast(
      s,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}
