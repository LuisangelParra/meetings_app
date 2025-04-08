import 'package:flutter/material.dart';

/// Widget interactivo para calificar con estrellas.
class StarRating extends StatefulWidget {
  final int maxRating;
  final double initialRating;
  final ValueChanged<double>? onRatingChanged;

  const StarRating({
    Key? key,
    this.maxRating = 5,
    this.initialRating = 0.0,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  Widget buildStar(int index) {
    // Si la posición es menor que la calificación actual se pinta una estrella llena
    final IconData icon = index < _currentRating ? Icons.star : Icons.star_border;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentRating = index + 1.0;
        });
        if (widget.onRatingChanged != null) {
          widget.onRatingChanged!(_currentRating);
        }
      },
      child: Icon(
        icon,
        color: Colors.amber,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) => buildStar(index)),
    );
  }
}