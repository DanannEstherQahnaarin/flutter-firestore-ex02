import 'package:flutter/material.dart';
import 'package:flutter_application_mms/appbar/appbars.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_member.dart';
import 'package:flutter_application_mms/dialog/dialogs.dart';
import 'package:intl/intl.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "User List"),
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
              final String createDate = DateFormat(
                'yyyy-MM-ss',
              ).format(member.timestamp);

              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(
                    member.userRole == UserRole.admin
                        ? Icons.verified_user
                        : Icons.person,
                    color: member.userRole == UserRole.admin
                        ? Colors.green
                        : Colors.blueAccent,
                    size: 25,
                  ),
                  title: Text(member.name),
                  subtitle: Text(
                    'Role : ${member.userRole.displayName}, Email : ${member.email} ',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showUpdateUserDialog(
                            context: context,
                            member: member,
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDeleteUserDialog(
                            context: context,
                            member: member,
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                      /*Text('date : $createDate')*/
                    ],
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
