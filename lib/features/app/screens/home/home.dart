import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meetings_app/features/app/screens/home/widgets/search_result.dart';
import 'package:meetings_app/features/app/screens/home/widgets/track_carousel.dart';
import 'package:provider/provider.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:meetings_app/common/widgets/events/lists/past_events_list.dart';
import 'package:meetings_app/common/widgets/texts/section_heading.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/features/app/repository/event_repository.dart';

import 'package:meetings_app/features/app/screens/all_events/all_events.dart';

import 'package:meetings_app/features/app/screens/home/widgets/home_appbar.dart';
import 'package:meetings_app/features/app/screens/home/widgets/home_carousel.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/constants/text_strings.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

/// HomeScreen con búsqueda, carrusel de tracks y listado de eventos.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchResults = false; // Controla si se muestran resultados de búsqueda
  List<Event> _allEvents = [];       // Lista completa de eventos
  List<Event> _filteredEvents = [];  // Lista filtrada por búsqueda

  // Animación para mostrar/ocultar la capa de resultados.
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Inicializar animación.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Cargar eventos desde el repositorio.
    _loadEvents();

    // Listener para el campo de búsqueda.
    _searchController.addListener(() {
      final query = _searchController.text.trim().toLowerCase();
      if (query.isEmpty) {
        setState(() {
          _showSearchResults = false;
        });
        _animationController.reverse();
      } else {
        setState(() {
          _showSearchResults = true;
          _filteredEvents = _allEvents
              .where((event) =>
                  event.titulo.toLowerCase().contains(query))
              .toList();
        });
        _animationController.forward();
      }
    });
  }

  Future<void> _loadEvents() async {
    final eventRepo = Provider.of<EventRepository>(context, listen: false);
    _allEvents = await eventRepo.loadDummyEvents();
    _filteredEvents = List.from(_allEvents);
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark
          ? LColors.dark.withValues(alpha: 0.95)
          : LColors.light.withValues(alpha: 0.95),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Contenido principal scrollable.
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  // Cabecera principal.
                  LPrimaryHeaderContainer(
                    height: 230,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LHomeAppBar(),
                        SizedBox(height: LSizes.sm),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: LSizes.lg * 1.5),
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              LTexts.homeAppbarTitle,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: LColors.white,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Barra de búsqueda (integrada dentro del contenido para desplazarse junto).
                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: LSizes.lg * 1.5),
                      child: LSearchContainer(
                        text: 'Buscar evento',
                        icon: Iconsax.search_favorite,
                        isPostIcon: false,
                        postIconFunction: () {},
                        controller: _searchController,
                      ),
                    ),
                  ),
                  // Resto del contenido.
                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: LSizes.lg * 1.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Carrusel de tracks.
                          const SizedBox(height: 16),
                          LSectionHeading(
                            title: "Categorías",
                            textColor: dark ? LColors.textWhite : LColors.dark,
                            showActionButton: false,
                          ),
                          const SizedBox(height: 8),
                          TrackCarouselWidget(dark: dark),
                          SizedBox(height: LSizes.sm),
                          // Próximos eventos.
                          LSectionHeading(
                            title: "Próximos Eventos",
                            textColor: dark ? LColors.textWhite : LColors.dark,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AllEventsScreen(),
                                ),
                              );
                            },
                          ),
                          const LEventCarousel(),
                          SizedBox(height: LSizes.sm),
                          // Eventos pasados.
                          LSectionHeading(
                            title: "Eventos pasados",
                            textColor: dark ? LColors.textWhite : LColors.dark,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AllEventsScreen(defaultFilter: EventDateFilter.past),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: LSizes.sm),
                          const LPastEventList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Resultados de búsqueda con animación fade.
            Positioned(
              top: 210,
              left: 0,
              right: 0,
              bottom: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _showSearchResults
                    ? Container(
                        color: dark
                            ? LColors.dark.withValues(alpha: 0.9)
                            : LColors.light.withValues(alpha: 0.9),
                        child: SearchResultsWidget(filteredEvents: _filteredEvents),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
