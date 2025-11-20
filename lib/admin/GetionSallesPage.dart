import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomAppBar.dart';
import 'admin_drawer.dart';

class GestionSallesPage extends StatefulWidget {
  const GestionSallesPage({super.key});

  @override
  State<GestionSallesPage> createState() => _GestionSallesPageState();
}

class _GestionSallesPageState extends State<GestionSallesPage> {
  String selectedMenu = 'Salles';
  final TextEditingController nomController = TextEditingController();
  final List<String> statuts = ['Disponible', 'Occupée', 'Maintenance'];
  String selectedStatut = "Disponible";

  // ✅ Boîte de dialogue pour ajouter une salle
  void _ajouterSalleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text("Ajouter une Salle"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la salle',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Statut',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedStatut,
                    items: statuts
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setStateDialog(() => selectedStatut = v!),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    nomController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nomController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Le nom est obligatoire")),
                      );
                      return;
                    }

                    await FirebaseFirestore.instance.collection('salles').add({
                      'nom': nomController.text.trim(),
                      'statut': selectedStatut,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    nomController.clear();
                    selectedStatut = "Disponible";
                    Navigator.pop(context);
                  },
                  child: const Text("Ajouter"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ✅ Suppression salle
  void _supprimerSalle(String id) async {
    await FirebaseFirestore.instance.collection('salles').doc(id).delete();
  }

  // ✅ Dialogue pour modifier le statut d'une salle
  void _modifierStatutDialog(String id, String currentStatut) {
    String nouveauStatut = currentStatut;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text("Modifier le statut"),
              content: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Nouveau statut',
                  border: OutlineInputBorder(),
                ),
                value: nouveauStatut,
                items: statuts
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setStateDialog(() => nouveauStatut = v!),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('salles')
                        .doc(id)
                        .update({'statut': nouveauStatut});

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Statut mis à jour ✅")),
                    );
                  },
                  child: const Text("Enregistrer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ✅ Interface principale
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Gestion des Salles"),
      body: Row(
        children: [
          AdminDrawer(
            selectedMenu: selectedMenu,
            onSelectMenu: (m) => setState(() => selectedMenu = m),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Liste des Salles",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _ajouterSalleDialog,
                        icon: const Icon(Icons.add),
                        label: const Text("Ajouter une Salle"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('salles')
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final salles = snapshot.data!.docs;
                        if (salles.isEmpty) {
                          return const Center(
                            child: Text(
                              "Aucune salle trouvée",
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: salles.length,
                          itemBuilder: (context, index) {
                            final salle = salles[index];

                            return Card(
                              elevation: 3,
                              child: ListTile(
                                leading: const Icon(Icons.meeting_room, size: 32),
                                title: Text(
                                  salle['nom'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("Statut : ${salle['statut']}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _modifierStatutDialog(
                                        salle.id,
                                        salle['statut'],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _supprimerSalle(salle.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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
