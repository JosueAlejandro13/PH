lib/
 ├─ models/
 │   └─ user.dart
 ├─ services/
 │   └─ user_service.dart
 ├─ viewmodels/
 │   └─ users_viewmodel.dart
 ├─ screens/
 │   └─ users_page.dart
 └─ main.dart

************
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  provider: ^6.1.2
****************

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
*************


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static const _baseUrl =
      'https://jsonplaceholder.typicode.com/users';

  // GET
  Future<List<User>> fetchUsers() async {
    final res = await http.get(Uri.parse(_baseUrl));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  // POST
  Future<User> createUser(User user) async {
    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (res.statusCode == 201) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception('Error al crear usuario');
    }
  }

  // PUT
  Future<User> updateUser(User user) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (res.statusCode == 200) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception('Error al actualizar usuario');
    }
  }

  // DELETE
  Future<void> deleteUser(int id) async {
    final res = await http.delete(
      Uri.parse('$_baseUrl/$id'),
    );

    if (res.statusCode != 200) {
      throw Exception('Error al eliminar usuario');
    }
  }
}

**********************

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UsersViewModel extends ChangeNotifier {
  final UserService _service = UserService();

  List<User> users = [];
  bool isLoading = false;
  String? error;

  Future<void> loadUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      users = await _service.fetchUsers();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(User user) async {
    final newUser = await _service.createUser(user);
    users.add(newUser);
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    final updated = await _service.updateUser(user);
    final index = users.indexWhere((u) => u.id == user.id);
    users[index] = updated;
    notifyListeners();
  }

  Future<void> removeUser(int id) async {
    await _service.deleteUser(id);
    users.removeWhere((u) => u.id == id);
    notifyListeners();
  }
}

*******************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/users_viewmodel.dart';
import '../models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UsersViewModel>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsersViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Usuarios')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          vm.addUser(
            User(id: 999, name: 'Nuevo Usuario', email: 'nuevo@mail.com'),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vm.users.length,
              itemBuilder: (_, i) {
                final user = vm.users[i];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          vm.updateUser(
                            User(
                              id: user.id,
                              name: '${user.name} (edit)',
                              email: user.email,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          vm.removeUser(user.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

***********************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/users_page.dart';
import 'viewmodels/users_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersViewModel(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: UsersPage(),
      ),
    );
  }
}

