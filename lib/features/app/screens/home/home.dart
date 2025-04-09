import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:meetings_app/common/widgets/events/lists/past_events_list.dart';
import 'package:meetings_app/common/widgets/texts/section_heading.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/features/app/repository/event_repository.dart';
import 'package:meetings_app/features/app/screens/all_events/all_events.dart';
import 'package:meetings_app/features/app/screens/event_details/event_detail.dart';
import 'package:meetings_app/features/app/screens/home/widgets/home_appbar.dart';
import 'package:meetings_app/features/app/screens/home/widgets/home_carousel.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/constants/text_strings.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

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

  // Animación para mostrar/ocultar la lista de resultados
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Inicializar la animación
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Cargar los eventos desde el repositorio.
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
    // Carga los eventos desde el repositorio.
    _allEvents = await EventRepository().loadDummyEvents();
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
          // El Stack ocupa toda la pantalla, pero la search bar se integra en el scroll.
          fit: StackFit.expand,
          children: [
            // Contenido principal scrollable.
            SingleChildScrollView(
              // Se asigna padding inferior para evitar que el contenido quede oculto (si se usa algún footer fijo).
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  // Cabecera con imagen/banner del evento.
                  LPrimaryHeaderContainer(
                    height: 230,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// -- AppBar --
                        const LHomeAppBar(),
                        SizedBox(height: LSizes.sm),
                        /// -- Header --
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: LSizes.lg * 1.5),
                          child: SizedBox(
                            width: 180,
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
                  // Inserta la search bar en el Column.
                  // Usamos Transform.translate para que se superponga parcialmente al header.
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
                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: LSizes.lg * 1.5),
                      child: Column(
                        children: [
                          // Popular events list
                              LSectionHeading(
                                title: "Próximos Eventos",
                                textColor: dark ? LColors.textWhite : LColors.dark,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllEventsScreen(),
                                    ),
                                  );
                                },
                              ),
                              const LEventCarousel(),
                              SizedBox(height: LSizes.sm),
                              LSectionHeading(
                                title: "Eventos pasados",
                                textColor: dark ? LColors.textWhite : LColors.dark,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllEventsScreen(defaultFilter: EventDateFilter.past,),
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
            // Resultados de búsqueda (fijos dentro del SingleChildScrollView)
            Positioned(
              top: 244,
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
                        child: _buildSearchResults(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la lista de resultados de búsqueda.
  Widget _buildSearchResults() {
    if (_filteredEvents.isEmpty) {
      return const Center(child: Text('No hay resultados'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        // Determinar si el evento es pasado.
        final isPast = event.fecha.isBefore(DateTime.now());
        return ListTile(
          title: Text(event.titulo),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.tema),
              if (isPast)
                const Text(
                  'Evento pasado',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          leading: const Icon(Iconsax.calendar_1),
          onTap: () {
            // Navega a los detalles del evento.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailScreen(event: event),
              ),
            );
          },
        );
      },
    );
  }
}
