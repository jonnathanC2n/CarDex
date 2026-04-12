import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/car.dart';

class CarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Stream<List<Car>> getMyCars(String ownerId) {
    return _firestore
        .collection('cars')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Car.fromMap(doc.data(), doc.id)).toList(),
        );
  }

  Stream<List<Car>> getFeed() {
    return _firestore
        .collection('cars')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Car.fromMap(doc.data(), doc.id)).toList(),
        );
  }

  Future<Car> addCar({
    required String ownerId,
    required String brand,
    required String model,
    required int year,
    required File image,
  }) async {
    final id = _uuid.v4();
    final ref = _storage.ref().child('cars').child('$id.jpg');
    await ref.putFile(image);
    final imageUrl = await ref.getDownloadURL();

    final car = Car(
      id: id,
      ownerId: ownerId,
      brand: brand,
      model: model,
      year: year,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('cars').doc(id).set(car.toMap());
    return car;
  }

  Future<void> updateCar(Car car, {File? newImage}) async {
    Car updatedCar = car;
    if (newImage != null) {
      final ref = _storage.ref().child('cars').child('${car.id}.jpg');
      await ref.putFile(newImage);
      final imageUrl = await ref.getDownloadURL();
      updatedCar = car.copyWith(imageUrl: imageUrl);
    }
    await _firestore.collection('cars').doc(car.id).update(updatedCar.toMap());
  }

  Future<void> deleteCar(String id) async {
    try {
      await _storage.ref().child('cars').child('$id.jpg').delete();
    } catch (_) {}
    await _firestore.collection('cars').doc(id).delete();
  }

  Future<Car?> getCar(String id) async {
    final doc = await _firestore.collection('cars').doc(id).get();
    if (!doc.exists) return null;
    return Car.fromMap(doc.data()!, doc.id);
  }
}
