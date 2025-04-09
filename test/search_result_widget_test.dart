import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/features/app/screens/home/widgets/search_result.dart';

void main() {
  testWidgets('SearchResultsWidget displays events correctly',
      (WidgetTester tester) async {
    // Create test events
    final List<Event> testEvents = [
      Event(
        id: 1,
        titulo: "Flutter Workshop",
        descripcion: "Learn Flutter basics",
        tema: "Tech",
        ponente: "John Doe",
        invitadosEspeciales: [],
        modalidad: "Virtual",
        plataforma: "Zoom",
        fecha: DateTime.now().add(const Duration(days: 10)),
        horaInicio: "10:00",
        horaFin: "12:00",
        maxParticipantes: 50,
        suscritos: 30,
        imageUrl: "assets/images/event.jpg",
      ),
      Event(
        id: 2,
        titulo: "AI Conference",
        descripcion: "Discussing AI trends",
        tema: "IA",
        ponente: "Jane Smith",
        invitadosEspeciales: ["Guest Speaker"],
        modalidad: "Presencial",
        lugar: "Main Hall",
        fecha: DateTime.now().add(const Duration(days: 20)),
        horaInicio: "14:00",
        horaFin: "16:00",
        maxParticipantes: 100,
        suscritos: 75,
        imageUrl: "assets/images/event.jpg",
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchResultsWidget(filteredEvents: testEvents),
        ),
      ),
    );

    // Check events are displayed
    expect(find.text('Flutter Workshop'), findsOneWidget);
    expect(find.text('Tech'), findsOneWidget);

    expect(find.text('AI Conference'), findsOneWidget);
    expect(find.text('IA'), findsOneWidget);

    // Check calendar icons are shown
    expect(find.byIcon(Icons.calendar_1), findsNWidgets(2));
  });

  testWidgets('SearchResultsWidget displays past event indicator',
      (WidgetTester tester) async {
    // Create a past event
    final List<Event> pastEvents = [
      Event(
        id: 3,
        titulo: "Past Workshop",
        descripcion: "Already happened",
        tema: "Tech",
        ponente: "Past Speaker",
        invitadosEspeciales: [],
        modalidad: "Presencial",
        lugar: "Old Venue",
        fecha: DateTime.now().subtract(const Duration(days: 5)),
        horaInicio: "09:00",
        horaFin: "11:00",
        maxParticipantes: 40,
        suscritos: 38,
        imageUrl: "assets/images/event.jpg",
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchResultsWidget(filteredEvents: pastEvents),
        ),
      ),
    );

    // Check past event is displayed with indicator
    expect(find.text('Past Workshop'), findsOneWidget);
    expect(find.text('Evento pasado'), findsOneWidget);
  });

  testWidgets('SearchResultsWidget shows no results message',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const SearchResultsWidget(filteredEvents: []),
        ),
      ),
    );

    // Check no results message
    expect(find.text('No hay resultados'), findsOneWidget);
  });

  testWidgets('SearchResultsWidget navigates to event details on tap',
      (WidgetTester tester) async {
    final List<Event> testEvents = [
      Event(
        id: 1,
        titulo: "Flutter Workshop",
        descripcion: "Learn Flutter basics",
        tema: "Tech",
        ponente: "John Doe",
        invitadosEspeciales: [],
        modalidad: "Virtual",
        plataforma: "Zoom",
        fecha: DateTime.now().add(const Duration(days: 10)),
        horaInicio: "10:00",
        horaFin: "12:00",
        maxParticipantes: 50,
        suscritos: 30,
        imageUrl: "assets/images/event.jpg",
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchResultsWidget(filteredEvents: testEvents),
        ),
      ),
    );

    // Tap on event
    await tester.tap(find.text('Flutter Workshop'));
    await tester.pumpAndSettle();

    // Check navigation happened (new route was pushed)
    // We can't test the actual navigation destination easily in this test,
    // but we can verify a new route was pushed to the navigator
    expect(find.text('Flutter Workshop'), findsNothing);
  });
}
