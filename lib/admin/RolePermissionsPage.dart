import 'package:flutter/material.dart';
import 'CustomAppBar.dart';
import 'admin_drawer.dart';

class RolePermissionsPage extends StatefulWidget {
  const RolePermissionsPage({super.key});

  @override
  State<RolePermissionsPage> createState() => _RolePermissionsPageState();
}

class _RolePermissionsPageState extends State<RolePermissionsPage> {
  String selectedMenu = 'Permissions';
  String selectedRole = 'Administrateur';

  final Map<String, List<String>> permissions = {
    'Administrateur': ['Gérer les utilisateurs', 'Modifier les salles', 'Voir emploi du temps'],
    'Chef de service': ['Modifier les salles', 'Voir emploi du temps'],
    'Professeur': ['Voir emploi du temps'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Rôles & Permissions"),
      body: Row(
        children: [
          AdminDrawer(
            selectedMenu: selectedMenu,
            onSelectMenu: (menu) => setState(() => selectedMenu = menu),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Définir les permissions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: selectedRole,
                    items: permissions.keys.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (value) => setState(() => selectedRole = value!),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: permissions[selectedRole]!
                        .map((p) => Chip(label: Text(p), backgroundColor: Colors.blue.shade100))
                        .toList(),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Permissions enregistrées avec succès.")),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Enregistrer"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
