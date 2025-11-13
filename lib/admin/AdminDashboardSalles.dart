import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomAppBar.dart';
import 'admin_drawer.dart';

class AdminDashboardSalles extends StatefulWidget {
  const AdminDashboardSalles({super.key});

  @override
  State<AdminDashboardSalles> createState() => _AdminDashboardSallesState();
}

class _AdminDashboardSallesState extends State<AdminDashboardSalles> {
  String selectedMenu = 'Accueil';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gestion des Salles'),
      body: Row(
        children: [
          AdminDrawer(
            selectedMenu: selectedMenu,
            onSelectMenu: (menu) {
              setState(() => selectedMenu = menu);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('salles').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final salles = snapshot.data!.docs;

                  // Statistiques
                  int total = salles.length;
                  int dispo = 0, occ = 0, main = 0;
                  for (var s in salles) {
                    final statut = s['statut'].toString().toLowerCase();
                    if (statut == 'disponible') dispo++;
                    else if (statut == 'occupée' || statut == 'occupee') occ++;
                    else if (statut == 'maintenance') main++;
                  }

                  return Column(
                    children: [
                      // Statistiques
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statCard('Total des salles', total, Icons.meeting_room, Colors.blue),
                          _statCard('Disponibles', dispo, Icons.check_circle, Colors.green),
                          _statCard('Occupées', occ, Icons.schedule, Colors.orange),
                          _statCard('En maintenance', main, Icons.build_circle, Colors.red),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Grid salles
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: salles.length,
                          itemBuilder: (context, index) {
                            final salle = salles[index];
                            return _salleCard(salle['nom'], salle['statut']);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, int value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: Icon(icon, size: 40, color: color),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('$value', style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }

  Widget _salleCard(String nom, String statut) {
    Color color;
    IconData icon;
    switch (statut.toLowerCase()) {
      case 'disponible':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'occupée':
      case 'occupee':
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      case 'maintenance':
        color = Colors.red;
        icon = Icons.build_circle;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              nom,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              statut,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
