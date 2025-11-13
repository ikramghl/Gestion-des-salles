import 'package:flutter/material.dart';
import 'AdminDashboardSalles.dart';
import 'GetionSallesPage.dart';
import 'EmploiTempsPage.dart';
import 'UserManagementPage.dart';



class AdminDrawer extends StatefulWidget {
  final String selectedMenu;
  final Function(String) onSelectMenu;

  const AdminDrawer({
    super.key,
    required this.selectedMenu,
    required this.onSelectMenu,
  });

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.blue[900],
      child: ListView(
        children: [
          const SizedBox(height: 20),

          // --- Dashboard ---
          _drawerItem(
            Icons.dashboard,
            'Tableau de bord',
                () {
              widget.onSelectMenu('Tableau de bord');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminDashboardSalles()),
              );
            },
            widget.selectedMenu == 'Tableau de bord',
          ),

          // --- Gestion des salles ---
          _drawerItem(
            Icons.meeting_room,
            'Salles',
                () {
              widget.onSelectMenu('Salles');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GestionSallesPage()),
              );
            },
            widget.selectedMenu == 'Salles',
          ),

          // --- Emploi du temps ---
          _drawerItem(
            Icons.calendar_month,
            'Emploi du temps',
                () {
              widget.onSelectMenu('Emploi du temps');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmploiTempsPage()),
              );
            },
            widget.selectedMenu == 'Emploi du temps',
          ),

          // --- Gestion des utilisateurs ---
          _drawerItem(
            Icons.people,
            'Utilisateurs',
                () {
              widget.onSelectMenu('Utilisateurs');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserManagementPage()),
              );
            },
            widget.selectedMenu == 'Utilisateurs',
          ),

          // --- Permissions ---
         /* _drawerItem(
            Icons.security,
            'Permissions',
                () {
              widget.onSelectMenu('Permissions');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RolePermissionsPage()),
              );
            },
            widget.selectedMenu == 'Permissions',
          ),*/
        ],
      ),
    );
  }

  // --- Fonction de création d’un item de menu principal ---
  Widget _drawerItem(
      IconData icon, String title, VoidCallback onTap, bool isSelected) {
    return Container(
      decoration: isSelected
          ? BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2),
          )
        ],
      )
          : null,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        onTap: onTap,
      ),
    );
  }
}
