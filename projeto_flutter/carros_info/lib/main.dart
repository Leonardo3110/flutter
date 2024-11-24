import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carros Info',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> carList = ['Chevrolet', 'Volkswagen', 'Fiat'];

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Carros')),
      body: ListView.builder(
        itemCount: carList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(carList[index]),
            trailing: FavoriteButton(carName: carList[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CarDetailsPage(carName: carList[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CarDetailsPage extends StatelessWidget {
  final String carName;
  const CarDetailsPage({super.key, required this.carName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(carName)),
      body: Center(child: Text('Detalhes sobre $carName')),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final String carName;
  const FavoriteButton({super.key, required this.carName});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = prefs.getBool(widget.carName) ?? false;
    });
  }

  void _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = !_isFavorite;
      prefs.setBool(widget.carName, _isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : null,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
