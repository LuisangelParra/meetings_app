import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/appbar/appbar.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class AllEventsScreen extends StatelessWidget {
  const AllEventsScreen({super.key, required this.listWidget });

  /// Lista de eventos a mostrar en pantalla
  final Widget listWidget;

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? LColors.dark : LColors.light,
      body: CustomScrollView(
        slivers: [
          // AppBar fijo, implementado como un sliver
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              height: LSizes.appBarHeight * 1.5, // Ajusta según necesites
              padding: const EdgeInsets.symmetric(
                horizontal: LSizes.lg * 1.2,
              ),
              child: const LAppBar(
                showBackArrow: true,
              ),
            ),
          ),
          // Sliver para el contenido de la lista de eventos
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: LSizes.lg * 1.5),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Si LEventList() ya incluye la lista de items, no es necesario agregar más widgets aquí.
                  listWidget,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper: delegate para el SliverPersistentHeader
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;
  final EdgeInsetsGeometry padding; // Nuevo parámetro para padding

  _SliverAppBarDelegate({
    required this.height,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: padding, // Se aplica el padding configurado
      child: SizedBox.expand(child: child),
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return oldDelegate.height != height ||
        oldDelegate.child != child ||
        oldDelegate.padding != padding;
  }
}