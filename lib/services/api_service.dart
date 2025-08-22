import 'dart:convert';
import 'package:daily_health_tracker/models/log_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Activity Logs (pagination supported)
  static const String logsUrl = "https://jsonplaceholder.typicode.com/posts";

  // Steps / Users (ReqRes mock API)
  static const String stepsUrl = "https://reqres.in/api/users";

  // Mock Timer (create JSON at mocki.io with { "next_reminder_in": 600 })
  static const String timerUrl = "https://mocki.io/v1/your-timer-api-id";

  /// Fetch activity logs with pagination
  /// Fetch activity logs with pagination
  /// Fetch activity logs with pagination
  /// Fetch activity logs with pagination
  static Future<List<Log>> fetchLogs(int page, int limit) async {
    try {
      final start = (page - 1) * limit;
      final res = await http.get(Uri.parse("$logsUrl?_start=$start&_limit=$limit"));

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => Log.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load logs: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load logs: $e");
    }
  }

  /// Fetch steps (using ReqRes users mock API)
  static Future<List<dynamic>> fetchSteps(int page) async {
    final res = await http.get(Uri.parse("$stepsUrl?page=$page"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['data']; // ReqRes returns { "data": [ {id, email, ...} ] }
    } else {
      throw Exception("Failed to load steps/users");
    }
  }

  /// Fetch countdown timer (mock JSON from mocki.io)
  static Future<int> fetchTimer() async {
    final res = await http.get(Uri.parse(timerUrl));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['next_reminder_in']; // Example: 600
    } else {
      throw Exception("Failed to load timer");
    }
  }
}
