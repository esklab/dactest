import 'dart:convert';
import 'package:dac_technologies/controller/userController.dart';
import 'package:dac_technologies/screens/ProfileScreen.dart';
import 'package:dac_technologies/services/api_services.dart';
import 'package:flutter/material.dart';
import '../models/userModel.dart';
import '../services/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> userData = [];
  List<User> filteredUserData = [];
  final RandomUser randomUser = RandomUser();
  final UserController userController =UserController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final List<User>? users = await randomUser.fetchUserData();
    if (users != null) {
      final dbHelper = DatabaseHelper();
      for (final user in users) {
        await dbHelper.insertProfile(user.toMap());
      }
      setState(() {
        userData = users;
        filteredUserData = List.from(userData);
      });
    }
  }

  Future<void> displayProfilesFromSQLite() async {
    final dbHelper = DatabaseHelper();
    final profiles = await dbHelper.getProfiles();
    setState(() {
      userData = profiles.cast<User>();
      filteredUserData = List.from(userData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              buildSearchBar(),
              Expanded(child: buildCard()
              ),
            ],
          ),
          Positioned(
            bottom: 18,
            right: 18,
            child: Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _createProfile(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black54,
      title: const Text(
        "Dac test",
        style: TextStyle(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
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
          String fullName = '${user.firstName} ${user.lastName}';
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
                        userData[index].picture,
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
                            '${userData[index].firstName} ${userData[index].lastName}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          buildUserDetail('Email', userData[index].email),
                          buildUserDetail('Phone', userData[index].phone),
                          buildUserDetail('Location', userData[index].city),
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
    final TextEditingController pictureController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Créer un profil"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCreateProfileField("Pseudo", pseudoController),
                _buildCreateProfileField("Prénom", firstNameController),
                _buildCreateProfileField("Nom", lastNameController),
                _buildCreateProfileField("Email", emailController),
                _buildCreateProfileField("Telephone", phoneController),
                _buildCreateProfileField("Ville", cityController),
                _buildCreateProfileField("Pays", countryController),
                _buildCreateProfileField("Code Postal", postcodeController),
                _buildCreateProfileField("Picture", pictureController),
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
              onPressed: () async {
                if (userController.isInputValid(
                    pseudoController.text,
                    firstNameController.text,
                    lastNameController.text,
                    emailController.text,
                    phoneController.text,
                    cityController.text,
                    countryController.text,
                    postcodeController.text,
                    pictureController.text)) {
                  // Créez un nouvel utilisateur avec les données saisies
                  final newUser = User(
                    username: pseudoController.text,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    city: cityController.text,
                    country: countryController.text,
                    postcode: postcodeController.text,
                    picture: pictureController.text,
                  );
                  setState(() {
                    userData.add(newUser);
                    filteredUserData.add(newUser);
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Enregistrement reussis.',
                        style: TextStyle(color: Colors.white),),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Veuillez remplir tous les champs correctement.',
                        style: TextStyle(color: Colors.white),),
                    ),
                  );
                }
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



