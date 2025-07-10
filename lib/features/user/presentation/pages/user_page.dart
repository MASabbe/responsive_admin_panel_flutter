import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/providers/team_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/widgets/custom_paginated_data_table.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/widgets/custom_app_drawer.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context);
    final user = authService.currentUser;
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
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Consumer<TeamProvider>(
          builder: (context, teamProvider, child) {
            if (teamProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (teamProvider.isEmpty) {
              return const Center(child: Text('No team data available.'));
            }
            // if (teamProvider is dynamic && teamProvider.errorMessage != null) {
            //   return Center(child: Text('Error: ${teamProvider.errorMessage}'));
            // }
            // TODO: Ganti dengan data dari provider jika sudah ada implementasi
            return CustomPaginatedDataTable(
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
            );
          },
        ),
      ),
    );
  }
}
