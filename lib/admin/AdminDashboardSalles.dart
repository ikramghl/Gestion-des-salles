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
  DocumentSnapshot? selectedSalle;

  // ========== Récupérer emploi du temps d'une salle ==========
  Stream<QuerySnapshot> getEmploiBySalle(String salleNom) {
    return FirebaseFirestore.instance
        .collectionGroup('horaires')
        .where('salle', isEqualTo: salleNom)
        .orderBy('jourIndex')
        .orderBy('heure')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gestion des Salles'),
      body: Row(
        children: [
          AdminDrawer(
            selectedMenu: selectedMenu,
            onSelectMenu: (menu) => setState(() => selectedMenu = menu),
          ),

          // ======== CONTENU PRINCIPAL =========
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('salles').snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erreur Firestore (salles) : ${snapshot.error}",
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final salles = snapshot.data!.docs;

                  int total = salles.length;
                  int dispo = 0, occ = 0, main = 0;

                  for (var s in salles) {
                    String statut = s['statut'].toString().toLowerCase();
                    if (statut == 'disponible') dispo++;
                    else if (statut == 'occupée' || statut == 'occupee') occ++;
                    else if (statut == 'maintenance') main++;
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statCard('Total des salles', total, Icons.meeting_room, Colors.blue),
                            _statCard('Disponibles', dispo, Icons.check_circle, Colors.green),
                            _statCard('Occupées', occ, Icons.schedule, Colors.orange),
                            _statCard('Maintenance', main, Icons.build_circle, Colors.red),
                          ],
                        ),

                        const SizedBox(height: 25),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: salles.length,
                          itemBuilder: (context, index) {
                            final salle = salles[index];
                            return GestureDetector(
                              onTap: () => setState(() => selectedSalle = salle),
                              child: _salleCard(salle['nom'], salle['statut']),
                            );
                          },
                        ),

                        const SizedBox(height: 40),
                        const Divider(thickness: 1.5),
                        const SizedBox(height: 20),

                        const Text(
                          "Emploi du temps de la salle",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 400,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListView.builder(
                                  itemCount: salles.length,
                                  itemBuilder: (context, index) {
                                    final salle = salles[index];
                                    bool isSelected = selectedSalle?.id == salle.id;

                                    return ListTile(
                                      selected: isSelected,
                                      selectedTileColor: Colors.blue[50],
                                      leading: const Icon(Icons.meeting_room),
                                      title: Text(salle['nom']),
                                      subtitle: Text(salle['statut']),
                                      onTap: () => setState(() => selectedSalle = salle),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(width: 20),

                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 400,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: selectedSalle == null
                                    ? const Center(
                                  child: Text(
                                    "Cliquez sur une salle pour voir son emploi du temps",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                                    : StreamBuilder<QuerySnapshot>(
                                  stream: getEmploiBySalle(selectedSalle!['nom']),
                                  builder: (context, snapshot) {

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          "Erreur Firestore (emploi du temps) : ${snapshot.error}",
                                          style: const TextStyle(color: Colors.red, fontSize: 18),
                                        ),
                                      );
                                    }

                                    if (!snapshot.hasData) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    // -----------------------------
                                    // 🔵 FUSION DES SPECIALITES
                                    // -----------------------------
                                    final emplois = snapshot.data!.docs;

                                    Map<String, Map<String, dynamic>> merged = {};

                                    for (var e in emplois) {
                                      final d = e.data() as Map<String, dynamic>;

                                      String key = "${d['jour']}_${d['heure']}_${d['prof']}_${d['activite']}_${d['salle']}";

                                      if (!merged.containsKey(key)) {
                                        merged[key] = {
                                          'jour': d['jour'],
                                          'heure': d['heure'],
                                          'prof': d['prof'],
                                          'activite': d['activite'],
                                          'specialites': [d['specialite']],
                                        };
                                      } else {
                                        merged[key]!['specialites'].add(d['specialite']);
                                      }
                                    }

                                    final emploisFusionnes = merged.values.toList();

                                    if (emploisFusionnes.isEmpty) {
                                      return const Center(
                                        child: Text("Aucun emploi pour cette salle"),
                                      );
                                    }

                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columns: const [
                                          DataColumn(label: Text("Jour")),
                                          DataColumn(label: Text("Heure")),
                                          DataColumn(label: Text("Prof")),
                                          DataColumn(label: Text("Activité")),
                                          DataColumn(label: Text("Spécialité")),
                                        ],
                                        rows: emploisFusionnes.map((e) {
                                          return DataRow(cells: [
                                            DataCell(Text(e['jour'])),
                                            DataCell(Text(e['heure'])),
                                            DataCell(Text(e['prof'])),
                                            DataCell(Text(e['activite'])),
                                            DataCell(Text(e['specialites'].join(", "))),
                                          ]);
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(nom,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              statut,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
