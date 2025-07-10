import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/providers/drawer_provider.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Drawer(
      child: Consumer<DrawerProvider>(
        builder: (context, drawerProvider, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _createHeader(user),
              _createDrawerItem(
                icon: Icons.dashboard_outlined,
                text: 'Dashboard',
                isSelected: drawerProvider.selectedIndex == 0,
                onTap: () {
                  drawerProvider.setIndex(0);
                  GoRouter.of(context).go('/dashboard');
                },
              ),
              _createDrawerItem(
                icon: Icons.people_outline,
                text: 'All Users',
                isSelected: drawerProvider.selectedIndex == 1,
                onTap: () {
                  drawerProvider.setIndex(1);
                  GoRouter.of(context).go('/dashboard/users');
                },
              ),
              _createDrawerItem(
                icon: Icons.person_outline,
                text: 'My Profile',
                isSelected: drawerProvider.selectedIndex == 2,
                onTap: () {
                  drawerProvider.setIndex(2);
                  GoRouter.of(context).go('/dashboard/profile');
                },
              ),
              const Divider(),
              _createDrawerItem(
                icon: Icons.logout,
                text: 'Sign Out',
                onTap: () {
                  authProvider.signOut();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _createHeader(UserEntity? user) {
    final avatarUrl = user?.avatarUrl;
    return UserAccountsDrawerHeader(
      accountName: Text(user?.name ?? 'Guest'),
      accountEmail: Text(user?.email ?? ''),
      currentAccountPicture: CircleAvatar(
        child: avatarUrl != null && avatarUrl.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 50);
                  },
                ),
              )
            : const Icon(Icons.person, size: 50),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon, required String text, GestureTapCallback? onTap, bool isSelected = false}) {
    return ListTile(
      selected: isSelected,
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
