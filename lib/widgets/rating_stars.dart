import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final int maxRating;
  final double size;
  final Color? color;
  final bool interactive;
  final ValueChanged<int>? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 24,
    this.color,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? Theme.of(context).colorScheme.secondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;
        return interactive
            ? GestureDetector(
                onTap: () => onRatingChanged?.call(starIndex),
                child: Icon(
                  isFilled ? Icons.star : Icons.star_border,
                  size: size,
                  color: starColor,
                ),
              )
            : Icon(
                isFilled ? Icons.star : Icons.star_border,
                size: size,
                color: starColor,
              );
      }),
    );
  }
}

class RatingDisplay extends StatelessWidget {
  final double avgRating;
  final int count;
  final double size;

  const RatingDisplay({
    super.key,
    required this.avgRating,
    required this.count,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: size,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 4),
        Text(
          count > 0
              ? '${avgRating.toStringAsFixed(1)} ($count)'
              : 'Sem avaliações',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
