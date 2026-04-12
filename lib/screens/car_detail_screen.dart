import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/car.dart';
import '../services/car_service.dart';
import '../services/rating_service.dart';
import 'edit_car_screen.dart';

class CarDetailScreen extends StatefulWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final _carService = CarService();
  final _ratingService = RatingService();
  late Car _car;
  int? _userRating;

  @override
  void initState() {
    super.initState();
    _car = widget.car;
    _loadRating();
  }

  Future<void> _loadRating() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _userRating = await _ratingService.getUserRating(_car.id, userId);
      if (mounted) setState(() {});
    }
  }

  Future<void> _rate(int rating) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await _ratingService.rateCar(_car.id, userId, rating);
    _userRating = rating;
    final updated = await _carService.getCar(_car.id);
    if (updated != null && mounted) {
      setState(() => _car = updated);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir carro?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _carService.deleteCar(_car.id);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = _car.ownerId == FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_car.brand} ${_car.model}'),
        actions: isOwner
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push<Car>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCarScreen(car: _car),
                      ),
                    );
                    if (result != null && mounted) {
                      setState(() => _car = result);
                    }
                  },
                ),
                IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: CachedNetworkImage(
                imageUrl: _car.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_car.brand} ${_car.model}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_car.year}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _car.ratingCount > 0
                            ? '${_car.avgRating.toStringAsFixed(1)} (${_car.ratingCount} avaliações)'
                            : 'Sem avaliações',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  if (!isOwner) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Avalie este carro',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final rating = index + 1;
                        return IconButton(
                          icon: Icon(
                            rating <= (_userRating ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            size: 36,
                          ),
                          onPressed: () => _rate(rating),
                          color: Theme.of(context).colorScheme.secondary,
                        );
                      }),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
