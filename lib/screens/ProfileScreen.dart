import 'package:dac_technologies/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, dynamic> editedUserData = {};

  @override
  void initState() {
    super.initState();
    editedUserData.addAll(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 26, color: Colors.white),
            onPressed: () {
              _editProfile(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, size: 26, color: Colors.white),
            onPressed: () {
              _deleteProfile(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackgroundImage(),
            _buildProfileInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.userData['picture']['large'] ?? ''),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(14),
      child: Column(
        children: [
          _buildInfoRow(Icons.person_2_outlined, 'Pseudo', widget.userData['login']['username']),
          _buildInfoRow(Icons.person, 'Prénom', widget.userData['name']['first']),
          _buildInfoRow(Icons.person, 'Nom', widget.userData['name']['last']),
          _buildInfoRow(Icons.email, 'Email', widget.userData['email']),
          _buildInfoRow(Icons.phone, 'Téléphone', widget.userData['phone']),
          _buildInfoRow(Icons.location_on, 'Addresse', '${widget.userData['location']['street']['name']} ${widget.userData['location']['street']['name']} '),
          _buildInfoRow(Icons.location_city, 'Pays','${widget.userData['location']['city']} ${widget.userData['location']['state']} ${widget.userData['location']['country']}'),
          _buildInfoRow(Icons.local_post_office_sharp, 'Code Postal', '${widget.userData['location']['postcode']}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: Icon(
              icon,
              color: Colors.black,
              size: 24,
            ),
            title: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Éditer le profil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField("Pseudo", "login", "username"),
              _buildEditField("Prénom", "name", "first"),
              _buildEditField("Nom", "name", "last"),
              _buildEditField("Email", "email", null),
              _buildEditField("Téléphone", "phone", null),
              _buildEditField("Adresse", "location", "street['name']"),
              _buildEditField("Pays", "location", "country"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.userData.clear();
                  widget.userData.addAll(editedUserData);
                });
                Navigator.of(context).pop();
              },
              child: Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditField(String label, String category, String? field) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: field != null ? editedUserData[category][field] : editedUserData[category],
      onChanged: (value) {
        setState(() {
          if (field != null) {
            editedUserData[category][field] = value;
          } else {
            editedUserData[category] = value;
          }
        });
      },
    );
  }

  void _deleteProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation de la suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer ce profil ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                // Supprimez le profil ici
                Navigator.of(context).pop();
                _performDelete();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(), // Remplacez par votre page d'accueil
                  ),
                );
              },
              child: Text("Confirmer"),
            ),
          ],
        );
      },
    );
  }

  void _performDelete() {
    // supprimer profil
    setState(() {
      widget.userData.clear();
    });
  }
}
