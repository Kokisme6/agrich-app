import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();
  bool isSaving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _usernameController.text = user.displayName ?? '';
    _photoUrlController.text = user.photoURL ?? '';
  }

  Future<void> _saveChanges() async {
    setState(() {
      isSaving = true;
      error = null;
    });

    try {
      await user.updateDisplayName(_usernameController.text.trim());
      await user.updatePhotoURL(_photoUrlController.text.trim());
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser!;
      setState(() {
        _usernameController.text = updatedUser.displayName ?? '';
        _photoUrlController.text = updatedUser.photoURL ?? '';
      });

      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Something went wrong.";
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF156C26); 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: (_photoUrlController.text.trim().isNotEmpty)
                  ? NetworkImage(_photoUrlController.text.trim())
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
            ),

            const SizedBox(height: 20),

           
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _photoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Profile Image URL',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.image_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 25),

                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    ElevatedButton.icon(
                      onPressed: isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: isSaving
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        isSaving ? 'Saving...' : 'Save Changes',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
