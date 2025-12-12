import 'package:flutter/material.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_member.dart';
import 'package:flutter_application_mms/views/view_dialogs.dart';
import 'package:flutter_application_mms/views/view_user_add.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Member Manager System')),
      body: StreamBuilder<List<Member>>(
        stream: getMemberStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error:${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;

          if (data == null || data.isEmpty) {
            return Center(child: Text('Member Data Empty'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final member = data[index];

              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text(member.name),
                  subtitle: Text(
                    'Role : ${member.userRole.displayName}, Email : ${member.email} ',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('create date : ${member.timestamp}')],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddUserDialog(context: context);
        },
        child: Icon(Icons.add_box),
      ),
    );
  }
}
