import 'dart:convert';
import 'package:dac_technologies/screens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> filteredUserData = [];
  static const apiUrl = "https://randomuser.me/api/";

  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse('$apiUrl?results=100'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      // Stockez les données de l'API dans SQLite
      final dbHelper = DatabaseHelper();
      for (final user in results) {
        await dbHelper.insertProfile({
          'username': user['login']['username'],
          'firstName': user['name']['first'],
          'lastName': user['name']['last'],
          'email': user['email'],
          'phone': user['phone'],
          'city': user['location']['city'],
          'country': user['location']['country'],
          'postcode': user['location']['postcode'],
        });
      }
      setState(() {
        userData = results.cast<Map<String, dynamic>>();
        filteredUserData = List.from(userData);
      });
    }
  }

  Future<void> displayProfilesFromSQLite() async {
    final dbHelper = DatabaseHelper();
    final profiles = await dbHelper.getProfiles();
    setState(() {
      userData = profiles;
      filteredUserData = List.from(userData);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildSearchBar(),
          Expanded(child: buildCard()
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black54,
      title: const Text(
        "DAC TEST",
        style: TextStyle(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add_circle_outline,size: 26,color: Colors.white,),
          onPressed: () {
            _createProfile(context);
          },
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: TextField(
        style: const TextStyle(fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'Recherche...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
        onChanged: (text) {
          performSearch(text);
        },
      ),
    );
  }
  void performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredUserData = List.from(userData);
      });
    } else {
      setState(() {
        filteredUserData = userData.where((user) {
          String fullName = '${user['name']['first']} ${user['name']['last']}';
          return fullName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Widget buildCard() {
    return RefreshIndicator(
      onRefresh: () async{
        await fetchUserData();
      },
      child: userData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount:filteredUserData.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(), // Clé unique/element
            onDismissed: (direction) {
              setState(() {
                userData.removeAt(index); // Supprimez élément lorsquon glisse
              });
            },
            background: Container(
              color: Colors.red,
              child: const Center(
                child: Text(
                  "Supprimer",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userData: userData[index]),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      child: Image.network(
                        userData[index]['picture']['large'] ?? '',
                        fit: BoxFit.cover,
                        height: 320,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userData[index]['name']['first']} ${userData[index]['name']['last']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          buildUserDetail('Email', userData[index]['email']),
                          buildUserDetail('Phone', userData[index]['phone']),
                          buildUserDetail('Location', userData[index]['location']['city']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget buildUserDetail(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  void _createProfile(BuildContext context) {
    final TextEditingController pseudoController = TextEditingController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController countryController = TextEditingController();
    final TextEditingController postcodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Créer un profil"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCreateProfileField("Pseudo", pseudoController),
                _buildCreateProfileField("Prénom", firstNameController),
                _buildCreateProfileField("Nom", lastNameController),
                _buildCreateProfileField("Email", emailController),
                _buildCreateProfileField("Téléphone", phoneController),
                _buildCreateProfileField("Ville", cityController),
                _buildCreateProfileField("Pays", countryController),
                _buildCreateProfileField("Code Postal", postcodeController),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                // Créez un nouvel utilisateur avec les données saisies
                final dbHelper = DatabaseHelper();
                final newUser = {
                  'login': {
                    'username': pseudoController.text,
                  },
                  'name': {
                    'first': firstNameController.text,
                    'last': lastNameController.text,
                  },
                  'email': emailController.text,
                  'phone': phoneController.text,
                  'location': {
                    'city': cityController.text,
                    'country': countryController.text,
                    'postcode': postcodeController.text,
                  },
                };
                final id = await dbHelper.insertProfile(newUser);
                newUser['id'] = id;
                setState(() {
                  userData.add(newUser);
                  filteredUserData.add(newUser);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Créer"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCreateProfileField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}