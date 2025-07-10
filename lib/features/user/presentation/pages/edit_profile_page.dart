import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  Uint8List? _avatarBytes;
  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      // Save to temp file
      final tempDir = Directory.systemTemp;
      final tempFile = await File('${tempDir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.png').writeAsBytes(bytes);
      setState(() {
        _avatarBytes = bytes;
        _avatarFile = tempFile;
      });
    }
  }

  Future<void> _saveProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.updateUserProfile(_nameController.text, _emailController.text, _avatarFile);

    if (mounted) {
      if (authProvider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${authProvider.errorMessage}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final avatarUrl = user?.avatarUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _avatarBytes != null
                          ? MemoryImage(_avatarBytes!)
                          : (avatarUrl != null && avatarUrl.isNotEmpty)
                              ? NetworkImage(avatarUrl) as ImageProvider
                              : null,
                      child: (_avatarBytes == null && (avatarUrl == null || avatarUrl.isEmpty))
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(Icons.person, color: Colors.white, size: 20),
                          onPressed: (){},
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email Address (cannot be changed)',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email_outlined),
                    fillColor: Theme.of(context).disabledColor.withAlpha(26),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
