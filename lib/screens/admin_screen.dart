import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:almagest/Models/models.dart';
import 'package:almagest/services/services.dart';

enum Actions { share, delete, archive }

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: builListView(context, buildUserService(context),
          builList(buildUserService(context))),
    );
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
                        Navigator.pushReplacementNamed(context, 'admin').then(
                            (value) => setState(() =>
                                users = userService.getUsers() as List<Data>));
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
                      onPressed: (context) {
                        userService.postDelete(user.id.toString());
                        Navigator.pushReplacementNamed(context, 'admin').then(
                            (value) => setState(() => const AdminScreen()));
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
                        Navigator.pushReplacementNamed(context, 'admin').then(
                            (value) => setState(() => const AdminScreen()));
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
                        Navigator.pushReplacementNamed(context, 'admin').then(
                            (value) => setState(() => const AdminScreen()));
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
        title: Text(user.name + ' ' + user.surname),
        subtitle: Text(user.email),
        leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/511/511649.png')),
      );
}
