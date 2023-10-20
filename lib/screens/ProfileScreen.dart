import 'package:dac_technologies/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import '../controller/userController.dart';
import '../models/userModel.dart';

class ProfileScreen extends StatefulWidget {
  final User userData;
  const ProfileScreen({Key? key, required this.userData}) : super(key: key);
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool showAdditionalButtons = false;
  @override
  void initState() {
    super.initState();
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackgroundImage(context),
            _buildProfileInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(context) {
    return Stack(
      children: [
        Container(
          height: 380,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.userData.picture),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 14,
          child: Column(
            children: [
              if (showAdditionalButtons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(const Icon(Icons.edit, color: Colors.white), () {
                      _editProfile(context);
                    }),
                    const SizedBox(width: 20),
                    _buildActionButton(const Icon(Icons.delete, color: Colors.white), () {
                      _deleteProfile(context);
                    }),
                  ],
                ),
              _buildActionButton(
                showAdditionalButtons ? const Icon(Icons.close, color: Colors.white) : const Icon(Icons.add, color: Colors.white),
                    () {
                  setState(() {
                    showAdditionalButtons = !showAdditionalButtons;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(Widget icon, Function() onPressed) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(child: icon),
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
          _buildInfoRow(Icons.person_2_outlined, 'Pseudo', widget.userData.username),
          _buildInfoRow(Icons.person, 'Prénom', widget.userData.firstName),
          _buildInfoRow(Icons.person, 'Nom', widget.userData.lastName),
          _buildInfoRow(Icons.email, 'Email', widget.userData.email),
          _buildInfoRow(Icons.phone, 'Telephone', widget.userData.phone),
          _buildInfoRow(Icons.location_city, 'Ville', widget.userData.city),
          _buildInfoRow(Icons.location_on, 'Pays',widget.userData.country),
          _buildInfoRow(Icons.local_post_office_sharp, 'Code Postal', widget.userData.postcode),
          _buildInfoRow(Icons.link, 'Image Url', widget.userData.picture),
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
          title: const Text("Éditer le profil"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditField("Pseudo", widget.userData.username, (value) {
                  setState(() {
                    widget.userData.username = value;
                  });
                }),
                _buildEditField("Prénom", widget.userData.firstName, (value) {
                  setState(() {
                    widget.userData.firstName = value;
                  });
                }),
                _buildEditField("Nom", widget.userData.lastName, (value) {
                  setState(() {
                    widget.userData.lastName = value;
                  });
                }),
                _buildEditField("Email", widget.userData.email, (value) {
                  setState(() {
                    widget.userData.email = value;
                  });
                }),
                _buildEditField("Telephone", widget.userData.phone, (value) {
                  setState(() {
                    widget.userData.phone = value;
                  });
                }),
                _buildEditField("Ville", widget.userData.city, (value) {
                  setState(() {
                    widget.userData.city = value;
                  });
                }),
                _buildEditField("Pays", widget.userData.country, (value) {
                  setState(() {
                    widget.userData.country = value;
                  });
                }),
                _buildEditField("Code Postal", widget.userData.postcode, (value) {
                  setState(() {
                    widget.userData.postcode = value;
                  });
                }),
                _buildEditField("Image Url", widget.userData.picture, (value) {
                  setState(() {
                    widget.userData.picture = value;
                  });
                }),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'Modifier avec succès.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditField(String label, String initialValue, Function(String) onChanged) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }

  void _deleteProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation de la suppression"),
          content: const Text("Êtes-vous sûr de vouloir supprimer ce profil ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performDelete();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(), // Remplacez par votre page d'accueil
                  ),
                );
              },
              child: const Text("Confirmer"),
            ),
          ],
        );
      },
    );
  }

  void _performDelete() {
    // supprimer profil
    setState(() {
      widget.userData.reset();
    });
  }
}
