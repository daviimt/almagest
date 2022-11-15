import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:almagest/Models/models.dart';
import 'package:almagest/services/services.dart';

enum Actions { share, delete, archive }

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context);
    List<Data> users = userService.usuarios;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Menu'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final user = users[index];
            return Slidable(
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: (context) {
                      print(user.id);
                      userService.postActivate(user.id.toString());
                    },
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.person_add_alt,
                    label: 'Activar',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      print(user.id);
                      userService.postDeactivate(user.id.toString());
                    },
                    backgroundColor: const Color.fromARGB(255, 75, 81, 82),
                    foregroundColor: Colors.white,
                    icon: Icons.person_add_disabled_outlined,
                    label: 'Desactivar',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    // An action can be bigger than the others.

                    onPressed: (context) {},
                    backgroundColor: const Color.fromARGB(255, 75, 81, 82),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Editar',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      user.deleted;
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
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: users.length),
    );
  }

  // void _onDismissed(int index, Actions action) {
  //   final user = usuarios[index];
  //   setState((_) => users.removeAt(index));

  //   switch (action) {
  //     case Actions.delete:
  //       _showSnackBar(context!, '${users} is deleted', Colors.red);
  //       break;
  //     case Actions.share:
  //       _showSnackBar(context!, '${users} is shared', Colors.green);
  //       break;
  //   }
  // }

  // ignore: unused_element
  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildUserListTile(user) => ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(user.name + ' ' + user.surname),
        subtitle: Text(user.email),
        leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/511/511649.png')),
      );
}
