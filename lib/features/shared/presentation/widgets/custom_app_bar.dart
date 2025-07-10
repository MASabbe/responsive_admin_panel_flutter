import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                themeProvider.toggleTheme(!themeProvider.isDarkMode);
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Notification implementation
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final user = auth.currentUser;
              final avatarUrl = user?.avatarUrl;

              return CircleAvatar(
                radius: 18.0,
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty) 
                    ? NetworkImage(avatarUrl) 
                    : null,
                child: (avatarUrl == null || avatarUrl.isEmpty) 
                    ? const Icon(Icons.person, size: 24) 
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
