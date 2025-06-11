import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/data/models/team_model.dart';
import 'package:responsive_admin_panel_flutter/data/models/user_model.dart';
import 'package:responsive_admin_panel_flutter/domain/usecases/auth_service.dart';
import 'package:responsive_admin_panel_flutter/domain/usecases/team_service.dart';
import 'package:responsive_admin_panel_flutter/presentation/widgets/custom_paginated_data_table.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final teamService = Provider.of<TeamService>(context);
    final user = authService.currentUser;
    final team = teamService;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Team'),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              // Implementasi toggle tema (menggunakan library seperti shared_preferences)
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Implementasi notifikasi
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              radius: 18.0,
              backgroundImage: NetworkImage(
                user?.avatarUrl ?? 'https://ui-avatars.com/api/?name=User',
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context, user),
      body: SafeArea(
        child: CustomPaginatedDataTable(
          columns: [
            DataColumn(label: Text('No')),
            DataColumn(label: Text('First Name')),
            DataColumn(label: Text('Last Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Avatar')),
          ],
          onPageChanged: (page, rowsPerPage) {
            // Implementasi untuk mengambil data dari server
            // dan memasukkannya ke dalam DataTable

            if (kDebugMode) return [];

            return [
              for (var i = 0; i < 20; i++)
                DataRow(
                  cells: [
                    DataCell(Text('${i + 1}')),
                    DataCell(Text('John')),
                    DataCell(Text('Doe')),
                    DataCell(Text('zHkTt@example.com')),
                    DataCell(
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://ui-avatars.com/api/?name=John+Doe',
                        ),
                      ),
                    ),
                  ],
                ),
              DataRow(
                cells: [
                  DataCell(Text('2')),
                  DataCell(Text('Jane')),
                  DataCell(Text('Doe')),
                  DataCell(Text('2qDl0@example.com')),
                  DataCell(
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://ui-avatars.com/api/?name=Jane+Doe',
                      ),
                    ),
                  ),
                ],
              ),
            ];
          },
          totalRows: 100,
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, User? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'User'),
            accountEmail: Text(user?.email ?? 'user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                user?.avatarUrl ?? 'https://ui-avatars.com/api/?name=User',
              ),
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Projects'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to projects screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.task_alt),
            title: const Text('Tasks'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to tasks screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_outlined),
            title: const Text('Team'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to team screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.message_outlined),
            title: const Text('Messages'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to messages screen
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to help screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () async {
              Navigator.pop(context);
              await Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
