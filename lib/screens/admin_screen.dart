import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:productos_app/Models/models.dart';

enum Actions { share, delete, archive }

class AdminScreen extends StatelessWidget {
  List<User> users = allUsers;

  BuildContext? get context => null;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Admin Menu'),
          centerTitle: true,
        ),
        body: SlidableAutoCloseBehavior(
          closeWhenOpened: true,
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Slidable(
                key: Key(user.name),
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () => _onDismissed(index, Actions.share),
                  ),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.green,
                      icon: Icons.share,
                      label: 'Share',
                      onPressed: (context) =>
                          _onDismissed(index, Actions.share),
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () => _onDismissed(index, Actions.delete),
                  ),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: (context) =>
                          _onDismissed(index, Actions.delete),
                    ),
                  ],
                ),
                child: buildUserListTile(user),
              );
            },
          ),
        ),
      );

  void _onDismissed(int index, Actions action) {
    final user = users[index];
    setState((_) => users.removeAt(index));

    switch (action) {
      case Actions.delete:
        _showSnackBar(context!, '${users} is deleted', Colors.red);
        break;
      case Actions.share:
        _showSnackBar(context!, '${users} is shared', Colors.green);
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildUserListTile(User user) => Builder(
        builder: (context) => ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(user.name),
          subtitle: Text(user.email),
          onTap: () {
            final slidable = Slidable.of(context)!;
            final isClosed =
                slidable.actionPaneType.value == ActionPaneType.none;
            if (isClosed) {
              slidable.openCurrentActionPane();
            } else {
              slidable.close();
            }
          },
        ),
      );

  void setState(User Function(dynamic _) param0) {}
}
