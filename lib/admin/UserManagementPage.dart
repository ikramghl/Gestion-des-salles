import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'CustomAppBar.dart';
import 'admin_drawer.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  String selectedMenu = 'Utilisateurs';

  // Référence à l'instance de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Référence à l'instance d'Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- 1. AJOUTER UN UTILISATEUR (AUTHENTIFICATION + FIRESTORE) ---
  Future<void> _ajouterUtilisateur() async {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nom = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController(); // Nouveau champ pour le mot de passe
    String role = 'Professeur';
    bool isLoading = false; // Pour gérer l'état de chargement

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              title: const Text("Ajouter un utilisateur"),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nom,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        validator: (v) => v!.isEmpty ? "Nom obligatoire" : null,
                      ),
                      TextFormField(
                        controller: email,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v!.isEmpty || !v.contains('@') ? "Email valide obligatoire" : null,
                      ),
                      TextFormField(
                        controller: password,
                        decoration: const InputDecoration(labelText: 'Mot de passe initial'),
                        obscureText: true,
                        validator: (v) => v!.length < 6 ? "Mot de passe min. 6 caractères" : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: role,
                        items: ['Administrateur', 'Chef de service', 'Professeur']
                            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (v) => role = v!,
                        decoration: const InputDecoration(labelText: 'Rôle'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      setStateSB(() => isLoading = true);

                      try {
                        // 1. CRÉER L'UTILISATEUR DANS FIREBASE AUTHENTICATION
                        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text,
                        );

                        // 2. ENREGISTRER LES INFORMATIONS DANS FIRESTORE (Collection 'users')
                        await _firestore.collection('users').doc(userCredential.user!.uid).set({
                          'uid': userCredential.user!.uid,
                          'nom': nom.text.trim(),
                          'email': email.text.trim(),
                          'role': role,
                          'createdAt': FieldValue.serverTimestamp(),
                        });

                        // Afficher un succès (optionnel)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Utilisateur ajouté avec succès !')),
                        );

                        Navigator.pop(context); // Fermer la boîte de dialogue

                      } on FirebaseAuthException catch (e) {
                        // Gérer les erreurs d'authentification (ex: email déjà utilisé)
                        String message = 'Erreur d\'authentification.';
                        if (e.code == 'email-already-in-use') {
                          message = 'Cet email est déjà utilisé par un autre compte.';
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      } catch (e) {
                        // Gérer les autres erreurs
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Une erreur inattendue est survenue: $e')),
                        );
                      } finally {
                        setStateSB(() => isLoading = false);
                      }
                    }
                  },
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text("Ajouter"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- 2. SUPPRIMER UN UTILISATEUR (AUTHENTICATION + FIRESTORE) ---
  Future<void> _supprimerUtilisateur(String userId, String userEmail) async {
    // Note: La suppression d'un compte Firebase Auth nécessite une ré-authentification
    // si l'utilisateur à supprimer n'est pas l'utilisateur actuellement connecté.
    // Dans un panneau d'administration, on utilise généralement une fonction Cloud
    // pour supprimer l'utilisateur d'Auth sans être re-authentifié.
    // Pour cet exemple simple, nous allons seulement supprimer le document Firestore.

    try {
      // 1. SUPPRIMER LE DOCUMENT DANS FIRESTORE
      await _firestore.collection('users').doc(userId).delete();

      // Pour la suppression d'Auth, il faudrait utiliser une Cloud Function
      // car le client ne peut pas supprimer un compte Firebase Auth tiers.
      // Si c'était l'utilisateur actuel qui se supprimait lui-même, on utiliserait :
      // await FirebaseAuth.instance.currentUser?.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur $userEmail supprimé (Firestore seulement).')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Gestion des Utilisateurs"),
      body: Row(
        children: [
          AdminDrawer(
              selectedMenu: selectedMenu,
              onSelectMenu: (menu) => setState(() => selectedMenu = menu)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("Liste des utilisateurs",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _ajouterUtilisateur,
                        icon: const Icon(Icons.add),
                        label: const Text("Ajouter"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // --- AFFICHAGE DE LA LISTE DEPUIS FIRESTORE ---
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('users').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Erreur de chargement: ${snapshot.error}'));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        // Les données sont dans snapshot.data!.docs
                        final users = snapshot.data!.docs;

                        if (users.isEmpty) {
                          return const Center(child: Text("Aucun utilisateur trouvé."));
                        }

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final userDoc = users[index];
                            final userData = userDoc.data() as Map<String, dynamic>;

                            // Utilisation de l'UID et de l'Email pour la suppression
                            final userId = userData['uid'] ?? userDoc.id;
                            final userEmail = userData['email'] ?? 'N/A';

                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(userData['nom'] ?? 'Nom Inconnu'),
                                subtitle: Text('${userData['email'] ?? 'Email Inconnu'} - ${userData['role'] ?? 'Rôle Inconnu'}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  // Appel de la nouvelle fonction de suppression avec UID et Email
                                  onPressed: () => _supprimerUtilisateur(userId, userEmail),
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