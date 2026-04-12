import 'package:flutter/material.dart';
import '../models/car.dart';
import '../services/car_service.dart';
import '../widgets/car_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _carService = CarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar')),
      body: StreamBuilder<List<Car>>(
        stream: _carService.getFeed(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final cars = snapshot.data ?? [];
          if (cars.isEmpty) {
            return const Center(child: Text('Nenhum carro no feed ainda.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cars.length,
            itemBuilder: (context, index) => CarCard(
              car: cars[index],
              onTap: () => Navigator.pushNamed(
                context,
                '/car-detail',
                arguments: cars[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
