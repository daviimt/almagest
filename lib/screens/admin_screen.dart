import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:productos_app/Models/models.dart';

class AdminScreen extends StatelessWidget {
  List<User> users = allUsers;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Admin Menu'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return buildUserListTile(user);
          },
        ),
      );

  Widget buildUserListTile(User user) =>
      ListTile(contentPadding: const EdgeInsets.all(16));
}
