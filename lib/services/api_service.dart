import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/destination.dart';

class ApiService {
  static const categoriesUrl = 'https://grthclln.my.id/api/v1/categories.php';
  static const destinationsUrl =
      'https://grthclln.my.id/api/v1/destinations.php';

  static Future<dynamic> _get(String url) async {
    final response = await http
        .get(Uri.parse(url), headers: const {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  static List<dynamic> _data(dynamic response) =>
      response is Map && response['data'] is List
      ? response['data'] as List<dynamic>
      : response is List
      ? response
      : const [];

  static String _text(Map item, List<String> keys, [String fallback = '']) {
    for (final key in keys) {
      final value = item[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return fallback;
  }

  static Future<DashboardData> loadDashboard() async {
    final responses = await Future.wait([
      _get(categoriesUrl),
      _get(destinationsUrl),
    ]);
    final categories = _data(responses[0])
        .whereType<Map>()
        .map(
          (item) => Category(
            id: _text(item, ['id', 'category_id'], item.hashCode.toString()),
            name: _text(item, ['name', 'category_name'], 'Popular'),
          ),
        )
        .toList();
    final destinations = _data(responses[1])
        .whereType<Map>()
        .map(
          (item) => Destination(
            id: _text(item, ['id', 'destination_id'], item.hashCode.toString()),
            name: _text(item, ['name', 'title'], 'Untitled destination'),
            location: _text(item, ['location', 'address', 'city'], 'Indonesia'),
            category: _text(item, [
              'category_name',
              'category',
              'type',
            ], 'Popular'),
            image: _text(
              item,
              ['image_url', 'image', 'thumbnail', 'photo'],
              'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900',
            ),
            description: _text(
              item,
              ['description'],
              'A beautiful place to slow down, breathe, and enjoy your best holiday.',
            ),
            rating:
                double.tryParse(_text(item, ['rating', 'stars'], '4.9')) ?? 4.9,
          ),
        )
        .toList();
    return DashboardData(
      categories: categories.isEmpty
          ? DashboardData.empty().categories
          : [const Category(id: 'all', name: 'All'), ...categories],
      destinations: destinations,
    );
  }
}
