import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/rating.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Future<void> rateCar(String carId, String userId, int rating) async {
    final existing = await _firestore
        .collection('ratings')
        .where('carId', isEqualTo: carId)
        .where('userId', isEqualTo: userId)
        .get();

    if (existing.docs.isNotEmpty) {
      await _firestore.collection('ratings').doc(existing.docs.first.id).update(
        {'rating': rating},
      );
    } else {
      final id = _uuid.v4();
      await _firestore.collection('ratings').doc(id).set({
        'carId': carId,
        'userId': userId,
        'rating': rating,
        'createdAt': DateTime.now(),
      });
    }

    await _updateCarRating(carId);
  }

  Future<int?> getUserRating(String carId, String userId) async {
    final snap = await _firestore
        .collection('ratings')
        .where('carId', isEqualTo: carId)
        .where('userId', isEqualTo: userId)
        .get();
    if (snap.docs.isEmpty) return null;
    return snap.docs.first.data()['rating'] as int;
  }

  Future<void> _updateCarRating(String carId) async {
    final snap = await _firestore
        .collection('ratings')
        .where('carId', isEqualTo: carId)
        .get();
    if (snap.docs.isEmpty) return;

    double sum = 0;
    for (final doc in snap.docs) {
      sum += (doc.data()['rating'] as int);
    }
    final avg = sum / snap.docs.length;

    await _firestore.collection('cars').doc(carId).update({
      'avgRating': avg,
      'ratingCount': snap.docs.length,
    });
  }
}
