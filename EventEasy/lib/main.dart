// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/entity/guestsEntity.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Guests> guestsList = [];
  String serverMsg = '';
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedSex;
  Future<void> updateGuest(Guests updatedGuest, String id) async {
    try {
      final guestData = {
        'name': updatedGuest.name,
        'contact': updatedGuest.contact,
        'age': updatedGuest.age,
        'sexy': updatedGuest.sexy,
      };

      final response = await http.put(
        Uri.parse('http://127.0.0.1:3333/guest/$id'),
        body: jsonEncode(guestData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        setState(() {
          int index = guestsList.indexWhere((guest) => guest.id == id);
          if (index != -1) {
            guestsList[index] = updatedGuest;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Convidado atualizado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Erro ao atualizar convidado: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $error')),
      );
    }
  }

  void _showEditGuestDialog(Guests guest) {
    final _nameController = TextEditingController(text: guest.name);
    final _contactController = TextEditingController(text: guest.contact);
    final _ageController = TextEditingController(text: guest.age.toString());
    String? _selectedSex = guest.sexy;
    List<String> items = ['M', 'F'];
    String? selectedValue = guest.sexy;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Convidado'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contato'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Idade'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<String>(
                  value: items.contains(selectedValue) ? selectedValue : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                String contact = _contactController.text;
                String age = _ageController.text;
                String? sex = _selectedSex == 'Masculino'
                    ? 'M'
                    : (_selectedSex == 'Feminino' ? 'F' : "M");

                if (name.isNotEmpty && contact.isNotEmpty && age.isNotEmpty) {
                  Guests updatedGuest = Guests(
                    name: name,
                    contact: contact,
                    sexy: sex,
                    age: int.parse(age),
                  );
                  updateGuest(updatedGuest, guest.id!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos!')),
                  );
                }

                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchGuests() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:3333/guests'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        guestsList.clear();
        final data = jsonDecode(response.body);
        for (final jsonItem in data) {
          guestsList.add(Guests.fromJson(jsonItem));
        }
        setState(() {});
      } else {
        setState(() {
          serverMsg = 'Erro retorna dados: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        serverMsg = 'Erro de conexão: $error';
      });
    }
  }

  Future<void> removeGuest(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:3333/guest/$id'),
      );
      if (response.statusCode == 200) {
        setState(() {
          guestsList.removeWhere((guest) => guest.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Convidado removido com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:Text('Erro ao remover convidado: ${response.statusCode}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $error')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    fetchGuests();
  }

  void _showAddGuestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Convidado'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contato'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Idade'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedSex,
                  decoration: const InputDecoration(labelText: 'Sexo'),
                  items: ['Masculino', 'Feminino']
                      .map((sex) => DropdownMenuItem(
                            value: sex,
                            child: Text(sex),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSex = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                String contact = _contactController.text;
                String age = _ageController.text;
                String userID = "If01rBv6vraMm4XUH4lgQjIA3Rs2";
                String? sex = _selectedSex == 'Masculino'
                    ? 'M'
                    : (_selectedSex == 'Feminino' ? 'F' : "Masculino");

                if (name.isNotEmpty &&
                    contact.isNotEmpty &&
                    age.isNotEmpty &&
                    userID.isNotEmpty) {
                  Guests newGuest = Guests(
                    name: name,
                    contact: contact,
                    sexy: sex,
                    age: int.parse(age),
                    userID: userID,
                  );

                  Future<void> addGuest() async {
                    final response = await http.post(
                      Uri.parse('http://127.0.0.1:3333/guest'),
                      body: jsonEncode(newGuest.toJson()),
                      headers: {'Content-Type': 'application/json'},
                    );

                    if (response.statusCode == 201) {
                      setState(() {
                        guestsList.add(newGuest);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Convidado adicionado com sucesso!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Erro ao adicionar convidado: ${response.statusCode}')),
                      );
                    }
                  }

                  addGuest();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos!')),
                  );
                }

                Navigator.of(context).pop();
              },
              child: const Text(
                'Adicionar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convidados"),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: guestsList.length,
                itemBuilder: (context, index) {
                  final guest = guestsList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.black54,
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      title: Text(
                        guest.name!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      subtitle: Text(
                        'Contato: ${guest.contact} | Idade: ${guest.age}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showEditGuestDialog(guest),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeGuest(guest.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _showAddGuestDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Adicionar Convidado",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
