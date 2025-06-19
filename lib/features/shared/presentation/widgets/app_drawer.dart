import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_admin_panel_flutter/routes/route_names.dart';
import 'package:responsive_admin_panel_flutter/features/dashboard/data/models/user_model.dart';

class AppDrawer extends StatelessWidget {
  final User? user;
  final String? selectedRoute;
  const AppDrawer({Key? key, required this.user, this.selectedRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          _buildTile(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            routeName: RouteNames.dashboard,
            selected: selectedRoute == RouteNames.dashboard,
          ),
          _buildTile(
            context,
            icon: Icons.work_outline,
            title: 'Projects',
            routeName: '/projects',
            selected: selectedRoute == '/projects',
          ),
          _buildTile(
            context,
            icon: Icons.task_alt,
            title: 'Tasks',
            routeName: '/tasks',
            selected: selectedRoute == '/tasks',
          ),
          _buildTile(
            context,
            icon: Icons.group_outlined,
            title: 'Team',
            routeName: '/team',
            selected: selectedRoute == '/team',
          ),
          _buildTile(
            context,
            icon: Icons.message_outlined,
            title: 'Messages',
            routeName: '/messages',
            selected: selectedRoute == '/messages',
          ),
          const Divider(),
          _buildTile(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            routeName: '/settings',
            selected: selectedRoute == '/settings',
          ),
          _buildTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            routeName: '/help',
            selected: selectedRoute == '/help',
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () async {
              Navigator.pop(context);
              await Provider.of<AuthProvider>(context, listen: false).signOut();
              context.go(RouteNames.splash);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, {required IconData icon, required String title, required String routeName, bool selected = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selected,
      onTap: () {
        Navigator.pop(context);
        final currentRoute = GoRouterState.of(context).uri.toString();
        if (currentRoute != routeName) {
          context.go(routeName);
        }
      },
    );
  }
}
