lib/
 ├ main.dart
 ├ login_screen.dart
 ├ home_screen.dart
 ├ detail_screen.dart
 └ api_service.dart

api_service.dart----------------------------------------------------
 import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }
}
----------------------------------------------------

main.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba Técnica',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}----------------------------------------------------

login_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void login() {

    if (userController.text.isNotEmpty &&
        passController.text.isNotEmpty) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese usuario y contraseña'),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
              ),
            ),

            TextField(
              controller: passController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            )

          ],
        ),
      ),
    );
  }
}----------------------------------------------------

home_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ApiService apiService = ApiService();

  List users = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {

    try {

      users = await apiService.fetchUsers();

    } catch (e) {

      print(e);

    }

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Usuarios'),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(

              itemCount: users.length,

              itemBuilder: (context, index) {

                final user = users[index];

                return ListTile(

                  title: Text(user['name']),

                  subtitle: Text(user['email']),

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(user: user),
                      ),
                    );

                  },

                );

              },

            ),

    );
  }
}----------------------------------------------------

detail_screen.dar
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {

  final Map user;

  const DetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Detalle'),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              'Nombre: ${user['name']}',
              style: const TextStyle(fontSize: 18),
            ),

            Text(
              'Email: ${user['email']}',
              style: const TextStyle(fontSize: 18),
            ),

            Text(
              'Teléfono: ${user['phone']}',
              style: const TextStyle(fontSize: 18),
            ),

          ],

        ),

      ),

    );
  }
}

