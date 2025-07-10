import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/widgets/custom_app_drawer.dart';
import 'package:responsive_admin_panel_flutter/features/user/presentation/providers/user_provider.dart';
import 'package:responsive_admin_panel_flutter/features/user/presentation/widgets/users_data_source.dart';
import 'package:responsive_admin_panel_flutter/injection.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/widgets/custom_app_bar.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  late UserProvider _userProvider;
  UsersDataSource? _dataSource;

  @override
  void initState() {
    super.initState();
    _userProvider = sl<UserProvider>();
    _userProvider.addListener(_onProviderChange);
    _dataSource = UsersDataSource(_userProvider, context);
    if (_userProvider.users.isEmpty) {
      _userProvider.fetchUsers();
    }
  }

  void _onProviderChange() {
    setState(() {
      _dataSource = UsersDataSource(_userProvider, context);
    });
  }

  @override
  void dispose() {
    _userProvider.removeListener(_onProviderChange);
    _userProvider.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dashboard'),
      drawer: const AppDrawer(),
      body: ChangeNotifierProvider.value(
        value: _userProvider,
        child: Consumer<UserProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: PaginatedDataTable(
                header: const Text('User List'),
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('User ID')),
                  DataColumn(label: Text('Actions')),
                ],
                source: _dataSource!,
                rowsPerPage: 10,
              ),
            );
          },
        ),
      ),
    );
  }
}
