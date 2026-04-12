class Car {
  final String id;
  final String ownerId;
  final String brand;
  final String model;
  final int year;
  final String imageUrl;
  final DateTime createdAt;
  final double avgRating;
  final int ratingCount;

  Car({
    required this.id,
    required this.ownerId,
    required this.brand,
    required this.model,
    required this.year,
    required this.imageUrl,
    required this.createdAt,
    this.avgRating = 0.0,
    this.ratingCount = 0,
  });

  factory Car.fromMap(Map<String, dynamic> map, String docId) {
    return Car(
      id: docId,
      ownerId: map['ownerId'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      year: map['year'] as int,
      imageUrl: map['imageUrl'] as String,
      createdAt: (map['createdAt'] as dynamic).toDate(),
      avgRating: (map['avgRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: map['ratingCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'brand': brand,
      'model': model,
      'year': year,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'avgRating': avgRating,
      'ratingCount': ratingCount,
    };
  }

  Car copyWith({
    String? id,
    String? ownerId,
    String? brand,
    String? model,
    int? year,
    String? imageUrl,
    DateTime? createdAt,
    double? avgRating,
    int? ratingCount,
  }) {
    return Car(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }
}
