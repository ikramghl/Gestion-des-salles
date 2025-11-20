import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});


  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Changer le mot de passe"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mot de passe actuel"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Nouveau mot de passe"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mot de passe modifié (simulation).")),
                );
              },
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  // user info
  void _showUserInfoDialog(BuildContext context) {
    const userEmail = "amina@exemple.com";
    const role = "Administrateur";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Profil utilisateur"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Email : $userEmail"),
              SizedBox(height: 10),
              Text("Rôle : $role"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fermer"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showChangePasswordDialog(context);
              },
              icon: const Icon(Icons.lock),
              label: const Text("Changer le mot de passe"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      backgroundColor:Colors.blue[900],
      actions: [

        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          onSelected: (value) {
            if (value == 'profile') {
              _showUserInfoDialog(context);
            } else if (value == 'changePassword') {
              _showChangePasswordDialog(context);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem<String>(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('Voir le profil'),
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'changePassword',
              child: ListTile(
                leading: Icon(Icons.lock),
                title: Text('Changer le mot de passe'),
              ),
            ),
          ],
        ),

        // logout
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Se déconnecter',
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
