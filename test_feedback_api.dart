// Prueba del sistema de feedback con la API
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const contractKey = 'bolt1234';
  const baseUrl = 'https://unidb.openlab.uninorte.edu.co';
  
  print('=== TESTING FEEDBACK API ===');
  
  // 1. Test fetching existing feedbacks
  await testGetFeedbacks(baseUrl, contractKey);
  
  // 2. Test creating a new feedback
  await testCreateFeedback(baseUrl, contractKey);
  
  // 3. Test fetching feedbacks again to see the new one
  await testGetFeedbacks(baseUrl, contractKey);
  
  print('\n=== FEEDBACK API TESTS COMPLETED ===');
}

Future<void> testGetFeedbacks(String baseUrl, String contractKey) async {
  print('\n--- Testing GET feedbacks ---');
  final url = '$baseUrl/$contractKey/data/feedbacks/all?format=json';
  
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: 30));

    print('Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Response type: ${jsonData.runtimeType}');
      
      if (jsonData is List) {
        print('Found ${jsonData.length} feedbacks (direct list)');
        for (var feedback in jsonData.take(3)) {
          print('  Feedback: ${feedback}');
        }
      } else if (jsonData is Map && jsonData.containsKey('data')) {
        final data = jsonData['data'];
        if (data is List) {
          print('Found ${data.length} feedbacks (in data field)');
          for (var feedback in data.take(3)) {
            if (feedback is Map && feedback.containsKey('data')) {
              print('  Feedback (entry_id: ${feedback['entry_id']}): ${feedback['data']}');
            } else {
              print('  Feedback: ${feedback}');
            }
          }
        }
      } else {
        print('Unexpected response format: $jsonData');
      }
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error fetching feedbacks: $e');
  }
}

Future<void> testCreateFeedback(String baseUrl, String contractKey) async {
  print('\n--- Testing CREATE feedback ---');
  final url = '$baseUrl/$contractKey/data/store';
  
  final feedbackData = {
    'table_name': 'feedbacks',
    'data': {
      'event_id': 1, // Assuming event with ID 1 exists (chocolate event)
      'rating': 5,
      'comment': 'Excelente evento de prueba desde Flutter! 🎉',
      'created_at': DateTime.now().toIso8601String(),
    }
  };
  
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(feedbackData),
    ).timeout(Duration(seconds: 30));

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Feedback created successfully!');
    } else {
      print('❌ Failed to create feedback');
    }
  } catch (e) {
    print('Error creating feedback: $e');
  }
} 