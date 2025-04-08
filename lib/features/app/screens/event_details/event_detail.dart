import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/appbar/appbar.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/event_detail_header_container.dart';
import 'package:meetings_app/common/widgets/events/alerts/alert_toggle_button.dart';
import 'package:meetings_app/common/widgets/events/info/event_chip.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/features/app/models/track_model.dart';
import 'package:meetings_app/features/app/repository/track_repository.dart';
import 'package:meetings_app/features/app/screens/event_details/widgets/event_detail_footer.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark
          ? LColors.dark.withValues(alpha: 0.95)
          : LColors.light.withValues(alpha: 0.95),
          
      bottomNavigationBar: _buildFooter(context),
      // Usamos LayoutBuilder + ConstrainedBox para que el SingleChildScrollView
      // tenga al menos la altura completa de la pantalla.
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120), // Espacio para el footer
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cabecera con imagen/banner del evento
                  LEventDetailHeaderContainer(
                    defaultFigures: false,
                    image: event.imageUrl,
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: LSizes.lg),
                      child: Column(
                        children: [
                          // Barra superior con botón de regresar y alertas
                          LAppBar(
                            showBackArrow: true,
                            actions: [
                              AlertToggleButton(title: 'Alert'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Puedes agregar otros elementos sobre la imagen si lo deseas.
                        ],
                      ),
                    ),
                  ),
                  // Tarjeta principal superpuesta (detalles y descripción)
                  Positioned(
                    top: 220, // Ajusta para controlar la superposición sobre la cabecera
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        // Sección 1: Información básica (título, fecha, ubicación, tracks, precio y "Register Now")
                        Container(
                          decoration: BoxDecoration(
                            color: dark ? LColors.accent3 : LColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.titulo,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: dark ? LColors.textWhite : LColors.dark,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: LSizes.sm),
                              Text(
                                LHelperFunctions.formatDate(event.fecha),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: dark ? LColors.light : LColors.darkGrey,
                                    ),
                              ),
                              Text(
                                event.lugar,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: dark ? LColors.light : LColors.darkGrey,
                                    ),
                              ),
                              Text(
                                LHelperFunctions.formatTime(event.fecha),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: dark ? LColors.light : LColors.darkGrey,
                                    ),
                              ),
                              const SizedBox(height: LSizes.sm),
                              Row(
                                children: [
                                  FutureBuilder<List<Track>>(
                                    future: TrackRepository().loadDummyTracks(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const SizedBox(
                                          height: 20, // Espacio mientras se carga (opcional)
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return const SizedBox();
                                      }
                                      if (snapshot.hasData) {
                                        final List<Track> allTracks = snapshot.data!;
                                        final List<String> eventTrackNames = allTracks
                                            .where((track) => track.eventos.contains(event.id))
                                            .map((t) => t.nombre)
                                            .toList();
                                        return Row(
                                          children: eventTrackNames
                                              .map(
                                                (trackName) => Padding(
                                                  padding: const EdgeInsets.only(right: 8),
                                                  child: TrackChip(context, trackName),
                                                ),
                                              )
                                              .toList(),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: LSizes.md),
                        // Sección 2: Descripción y Speakers
                        Container(
                          decoration: BoxDecoration(
                            color: dark ? LColors.accent3 : LColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: dark ? LColors.textWhite : LColors.dark,
                                    ),
                              ),
                              const SizedBox(height: LSizes.sm / 2),
                              Text(
                                event.descripcion,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: dark ? LColors.light : LColors.darkGrey,
                                    ),
                              ),
                              const SizedBox(height: LSizes.md),
                              Text(
                                'Speakers',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: dark ? LColors.textWhite : LColors.dark,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              // Agrega la lista de speakers aquí si lo deseas...
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construye el footer fijo.
  Widget _buildFooter(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: LSizes.lg, vertical: LSizes.sm),
      decoration: BoxDecoration(
        color: dark ? LColors.accent3 : LColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: SubscribeFooter(dark: dark, event: event),
    );
  }
}