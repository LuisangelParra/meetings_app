import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/utils/constants/colors.dart';

// Asegúrate de tener un widget StarRating implementado previamente.
class StarRating extends StatefulWidget {
  final double initialRating;
  final int maxRating;
  final ValueChanged<double>? onRatingChanged;

  const StarRating({
    Key? key,
    this.initialRating = 0.0,
    this.maxRating = 5,
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
    final IconData icon =
        index < _currentRating ? Icons.star : Icons.star_border;
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
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          List.generate(widget.maxRating, (index) => buildStar(index)),
    );
  }
}

class RateFooter extends StatefulWidget {
  const RateFooter({
    super.key,
    required this.dark,
    required this.event,
  });

  final bool dark;
  final Event event;

  @override
  State<RateFooter> createState() => _RateFooterState();
}

class _RateFooterState extends State<RateFooter> {
  bool hasRated = false;
  double rating = 0.0;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasRated) {
      
      return Text(
        'Review submitted. Thank you!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: widget.dark ? LColors.textWhite : LColors.dark,
              fontSize: 16,
            ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Widget para calificar con estrellas.
        StarRating(
          initialRating: rating,
          maxRating: 5,
          onRatingChanged: (newRating) {
            setState(() {
              rating = newRating;
            });
          },
        ),
        const SizedBox(height: 8),
        // Campo para dejar un comentario.
        TextField(
          controller: commentController,
          decoration: InputDecoration(
            hintText: 'Leave a comment',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.dark ? LColors.textWhite.withOpacity(0.7) : LColors.darkGrey,
                ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.dark ? LColors.textWhite : LColors.darkGrey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Botón para enviar la review
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // Aquí se simula el envío de la review.
              // Puedes agregar la lógica para enviar el rating y el comentario.
              setState(() {
                hasRated = true;
              });
              print("Review submitted: rating=$rating, comment=${commentController.text}");
            },
            child: Text(
              'Submit Review',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: LColors.textWhite,
                    fontSize: 16,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
