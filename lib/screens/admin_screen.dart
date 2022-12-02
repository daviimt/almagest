import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:almagest/Models/models.dart';
import 'package:almagest/services/services.dart';
import 'package:cool_alert/cool_alert.dart';

enum Actions { share, delete, archive }

List<Data> users = [];

Future refresh(BuildContext context) async {
  users.clear();
  var usersService = Provider.of<UserService>(context, listen: false);
  usersService.getUsers();
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersService = Provider.of<UserService>(context, listen: false);
    users = usersService.usuarios.cast<Data>();
    List<Data> usersFinal = [];
    for (int i = 0; i < users.length; i++) {
      if (users[i].deleted == 0 && users[i].type == "u") {
        usersFinal.add(users[i]);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Menu'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            refresh(context);
            Navigator.pushReplacementNamed(context, 'admin');
          },
          child: builListView(context, buildUserService(context), usersFinal),
        ));
  }

  // ignore: unused_element
  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  UserService buildUserService(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    return userService;
  }

  List builList(UserService userService) {
    List<Data> users = userService.usuarios;
    return users;
  }

  Widget builListView(
          BuildContext context, UserService userService, List users) =>
      ListView.separated(
          itemBuilder: (context, index) {
            final user = users[index];
            if (user.actived == 0) {
              return Slidable(
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        userService.postActivate(user.id.toString());
                        refresh(context);
                        Navigator.pushReplacementNamed(context, 'admin');
                      },
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.person_add_alt,
                      label: 'Activar',
                    )
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext _) async {
                        await CoolAlert.show(
                          context: context,
                          type: CoolAlertType.warning,
                          title: 'Confirmar',
                          text:
                              '¿Estás seguro de eliminar la cuenta seleccionada?',
                          showCancelBtn: true,
                          confirmBtnColor: Colors.purple,
                          confirmBtnText: 'Eliminar',
                          onConfirmBtnTap: () {
                            userService.postDelete(user.id.toString());
                            refresh(context);
                            Navigator.pushReplacementNamed(context, 'admin');
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
                child: buildUserListTile(user),
              );
            } else {
              return Slidable(
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        userService.postDeactivate(user.id.toString());
                        refresh(context);
                        Navigator.pushReplacementNamed(context, 'admin');
                      },
                      backgroundColor: const Color.fromARGB(255, 75, 81, 82),
                      foregroundColor: Colors.white,
                      icon: Icons.person_add_disabled_outlined,
                      label: 'Desactivar',
                    )
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        userService.postDelete(user.id.toString());
                        refresh(context);
                        Navigator.pushReplacementNamed(context, 'admin');
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Eliminar',
                    ),
                  ],
                ),
                child: buildUserListTile(user),
              );
            }
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: users.length);

  Widget buildUserListTile(user) => ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(user.firstname + ' ' + user.secondname),
        subtitle: Text(user.email),
        leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/511/511649.png')),
      );
}
