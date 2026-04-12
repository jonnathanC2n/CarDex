class Rating {
  final String id;
  final String carId;
  final String userId;
  final int rating;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.carId,
    required this.userId,
    required this.rating,
    required this.createdAt,
  });

  factory Rating.fromMap(Map<String, dynamic> map, String docId) {
    return Rating(
      id: docId,
      carId: map['carId'] as String,
      userId: map['userId'] as String,
      rating: map['rating'] as int,
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'carId': carId,
      'userId': userId,
      'rating': rating,
      'createdAt': createdAt,
    };
  }
}
