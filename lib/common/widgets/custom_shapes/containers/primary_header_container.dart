import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/circular_container.dart';


class LPrimaryHeaderContainer extends StatelessWidget {
  const LPrimaryHeaderContainer({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LCurvedEdgeWidget(
      child: Container(
        color: LColors.light,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 250,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(top: -100, right: -200, child: LCircularContainer(width: 400, height: 400, radius: 400, backgraundColor: LColors.accent)),
              Positioned(top: 70, right: 120, child: LCircularContainer(width: 300, height: 300, radius: 300, backgraundColor: LColors.secondary)),
              Positioned(top: -300, right: 40, child: LCircularContainer(width: 500, height: 500, radius: 500, backgraundColor: LColors.primary)),
              child
            ],
          ),
        ),
      ),
    );
  }
}

