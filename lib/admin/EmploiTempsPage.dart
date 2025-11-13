import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomAppBar.dart'; // Assurez-vous que ce fichier existe
import 'admin_drawer.dart'; // Assurez-vous que ce fichier existe

class EmploiTempsPage extends StatefulWidget {
  const EmploiTempsPage({super.key});

  @override
  State<EmploiTempsPage> createState() => _EmploiTempsPageState();
}

class _EmploiTempsPageState extends State<EmploiTempsPage> {
  String selectedMenu = 'Emploi du temps';

  final jours = [
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi",
    "Dimanche"
  ];

  String getJourActuel() => jours[DateTime.now().weekday - 1];

  // --- WIDGET D'AFFICHAGE STYLISÉ ET COMPACT ---
  Widget _activityCard(Map<String, dynamic> cours) {
    Color primaryColor = Colors.indigo;
    Color backgroundColor = Colors.indigo.shade50;
    IconData icon = Icons.event_note;

    // Logique de couleur/icône basée sur l'activité
    String activite = cours['activite']?.toString().toLowerCase() ?? '';
    if (activite.contains('tp')) {
      primaryColor = Colors.teal;
      backgroundColor = Colors.teal.shade50;
      icon = Icons.desktop_windows;
    } else if (activite.contains('cours') || activite.contains('cour')) {
      primaryColor = Colors.blue;
      backgroundColor = Colors.blue.shade50;
      icon = Icons.school;
    } else if (activite.contains('examen') || activite.contains('exam')) {
      primaryColor = Colors.red;
      backgroundColor = Colors.red.shade50;
      icon = Icons.grading;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Ligne 1 : Salle & Activité (mise en valeur)
            Row(
              children: [
                Icon(Icons.meeting_room, size: 16, color: primaryColor),
                const SizedBox(width: 5),
                Text(
                  cours['salle'] ?? 'Salle N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  cours['activite'] ?? 'Activité',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const Divider(height: 10, color: Colors.black12),

            // Ligne 2 : Professeur
            Row(
              children: [
                Icon(Icons.person, size: 14, color: Colors.black54),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "Prof : ${cours['prof'] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Ligne 3 : Spécialité
            Row(
              children: [
                Icon(Icons.tag, size: 14, color: Colors.black54),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "Spé. : ${cours['specialite'] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final jourActuel = getJourActuel();
    // Déterminer le nombre de colonnes pour la GridView basé sur la largeur disponible
    final screenWidth = MediaQuery.of(context).size.width;
    // On suppose qu'après le drawer, il reste beaucoup d'espace (ex: 800px)
    final crossAxisCount = screenWidth > 900 ? 3 : 2; // 3 colonnes si l'écran est large, 2 sinon.

    return Scaffold(
      appBar: const CustomAppBar(title: "Emploi du Temps"),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Emploi du temps du $jourActuel",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () => _openAddEmploiDialog(),
                        child: const Text("Ajouter un emploi"),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collectionGroup('horaires')
                          .where('jour', isEqualTo: jourActuel)
                          .orderBy('heure')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Erreur: ${snapshot.error}'));
                        }

                        final docs = snapshot.data!.docs;

                        if (docs.isEmpty) {
                          return const Center(
                              child: Text("Aucune activité aujourd'hui"));
                        }

                        Map<String, List<Map<String, dynamic>>>
                        emploisParHeure = {};

                        for (var doc in docs) {
                          final data =
                          doc.data() as Map<String, dynamic>;
                          final heure = data['heure'] as String;

                          emploisParHeure.putIfAbsent(heure, () => []);
                          emploisParHeure[heure]!.add(data);
                        }

                        return ListView(
                          children: emploisParHeure.keys.map((heure) {
                            final coursHeure =
                            emploisParHeure[heure]!;

                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                                  child: Text(
                                    heure,
                                    style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ),

                                GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount, // Utilisation de 2 ou 3 colonnes
                                    childAspectRatio: 2.5,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: coursHeure.length,
                                  itemBuilder: (context, i) {
                                    final c = coursHeure[i];
                                    return _activityCard(c);
                                  },
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
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

  /// -----------------------------------------------
  /// BOITE D'AJOUT D'EMPLOI (Non modifiée)
  /// -----------------------------------------------
  /// -----------------------------------------------
  /// BOITE D'AJOUT D'EMPLOI (Modifiée pour spécialités multiples)
  /// -----------------------------------------------
  void _openAddEmploiDialog() {
    final _formKey = GlobalKey<FormState>();
    String jour = jours[0];
    // NOTE: Ce champ va maintenant contenir une chaîne de spécialités séparées par des virgules
    String specialitesInput = '';
    String salle = '';
    String prof = '';
    String activite = '';
    String heure = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un emploi"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: jour,
                  items: jours
                      .map((j) =>
                      DropdownMenuItem(value: j, child: Text(j)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      jour = v;
                    }
                  },
                  decoration: const InputDecoration(labelText: "Jour"),
                ),
                // --- CHAMPS MODIFIÉ : Saisie de spécialités multiples ---
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Spécialités (séparées par une virgule, ex: GL, RT)"),
                  validator: (v) =>
                  v!.isEmpty ? "Obligatoire (minimum une spécialité)" : null,
                  onChanged: (v) => specialitesInput = v,
                ),
                // -----------------------------------------------------
                TextFormField(
                  decoration: const InputDecoration(labelText: "Salle"),
                  validator: (v) => v!.isEmpty ? "Obligatoire" : null,
                  onChanged: (v) => salle = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Prof"),
                  validator: (v) => v!.isEmpty ? "Obligatoire" : null,
                  onChanged: (v) => prof = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Activité"),
                  validator: (v) => v!.isEmpty ? "Obligatoire" : null,
                  onChanged: (v) => activite = v,
                ),
                TextFormField(
                  decoration:
                  const InputDecoration(labelText: "Heure (ex: 08h00)"),
                  validator: (v) => v!.isEmpty ? "Obligatoire" : null,
                  onChanged: (v) => heure = v,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler")),
          ElevatedButton(
            child: const Text("Ajouter"),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {

                // 1. Nettoyer et séparer les spécialités
                List<String> specialitesList = specialitesInput
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();

                // 2. Créer une liste de promesses d'écriture (Future)
                List<Future<void>> writeOperations = [];

                // 3. Boucler sur chaque spécialité et créer une entrée Firestore
                for (String spec in specialitesList) {
                  writeOperations.add(
                    FirebaseFirestore.instance
                        .collection('emplois_temps')
                        .doc(spec.toLowerCase()) // Utilise chaque spécialité comme doc parent
                        .collection('horaires')
                        .add({
                      'jour': jour,
                      'specialite': spec, // Stocke la spécialité actuelle
                      'salle': salle.trim(),
                      'prof': prof.trim(),
                      'activite': activite.trim(),
                      'heure': heure.trim(),
                    }),
                  );
                }

                // 4. Exécuter toutes les écritures en parallèle
                await Future.wait(writeOperations);

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}