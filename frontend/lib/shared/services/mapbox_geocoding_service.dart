import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/config/app_config.dart';

/// Service for Mapbox Geocoding API
class MapboxGeocodingService {
  static final Dio _dio = Dio();
  static const String _baseUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';

  /// Search for places (cities, towns) based on query
  /// Returns a list of place names
  static Future<List<String>> searchPlaces(String query) async {
    if (query.isEmpty || query.length < 2) {
      return [];
    }

    try {
      // URL encode the query
      final encodedQuery = Uri.encodeComponent(query);
      final response = await _dio.get(
        '$_baseUrl/$encodedQuery.json',
        queryParameters: {
          'access_token': AppConfig.mapboxAccessToken,
          'types': 'place', // Only cities and towns
          'autocomplete': 'true', // Enable autocomplete
          'limit': 10,
          'language': 'en',
        },
        options: Options(
          responseType: ResponseType.json,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        assert(() {
          debugPrint(
              'Mapbox API response for "$query": ${data.toString().substring(0, data.toString().length > 500 ? 500 : data.toString().length)}');
          return true;
        }());

        final features = data['features'] as List<dynamic>?;

        if (features != null && features.isNotEmpty) {
          assert(() {
            debugPrint('Found ${features.length} features');
            return true;
          }());
          final results = <String>[];

          for (final feature in features) {
            try {
              // Use place_name if available (includes full address)
              // Otherwise use text (city name only)
              final placeName = feature['place_name'] as String? ??
                  feature['text'] as String?;

              assert(() {
                debugPrint(
                    'Feature place_name: $placeName, text: ${feature['text']}');
                return true;
              }());

              if (placeName != null && placeName.isNotEmpty) {
                // Extract just the city and region part (remove country if present)
                // Format: "City, Region, Country" -> "City, Region"
                final parts =
                    placeName.split(',').map((s) => s.trim()).toList();
                if (parts.length >= 2) {
                  // Take city and region, skip country
                  results.add('${parts[0]}, ${parts[1]}');
                } else if (parts.length == 1) {
                  results.add(parts[0]);
                }
              }
            } catch (e) {
              // Skip invalid features
              assert(() {
                debugPrint('Error parsing feature: $e');
                return true;
              }());
            }
          }

          assert(() {
            debugPrint('Returning ${results.length} results: $results');
            return true;
          }());
          return results;
        } else {
          assert(() {
            debugPrint('No features found in response');
            return true;
          }());
        }
      } else {
        assert(() {
          debugPrint('Mapbox API error: Status ${response.statusCode}');
          if (response.data != null) {
            debugPrint('Response data: ${response.data}');
          }
          return true;
        }());
      }
    } catch (e, stackTrace) {
      // Log errors for debugging (only in debug mode)
      assert(() {
        debugPrint('Mapbox Geocoding error: $e');
        debugPrint('Stack trace: $stackTrace');
        return true;
      }());
    }

    return [];
  }

  /// Get place details by name
  static Future<Map<String, dynamic>?> getPlaceDetails(String placeName) async {
    try {
      final encodedPlaceName = Uri.encodeComponent(placeName);
      final response = await _dio.get(
        '$_baseUrl/$encodedPlaceName.json',
        queryParameters: {
          'access_token': AppConfig.mapboxAccessToken,
          'types': 'place',
          'limit': 1,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final features = data['features'] as List<dynamic>?;

        if (features != null && features.isNotEmpty) {
          return features.first as Map<String, dynamic>;
        }
      }
    } catch (e) {
      assert(() {
        debugPrint('Mapbox Geocoding error: $e');
        return true;
      }());
    }

    return null;
  }
}
