import 'package:flutter/foundation.dart';

class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'https://lsyzkkfardbfkbpncogn.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxzeXpra2ZhcmRiZmticG5jb2duIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwNjYxMzEsImV4cCI6MjA4MDY0MjEzMX0.Tq-CiP4cyYFSup9Ze96qY_erbIKA1MGjagVXOUpQEh0';

  // Vercel Production URL - Bu URL'i Vercel dashboard'dan alın
  // Format: https://your-project-name.vercel.app
  static const String vercelBackendUrl = 'https://therapistsocial.vercel.app';
  
  // GraphQL Endpoint - Platform aware
  static String get graphqlEndpoint {
    // Build-time override: BACKEND_URL=https://your-deployment.vercel.app/api
    const backendUrl = String.fromEnvironment('BACKEND_URL');
    if (backendUrl.isNotEmpty) {
      debugPrint('🔵 [APP_CONFIG] Using BACKEND_URL from environment: $backendUrl');
      return '$backendUrl/graphql';
    }

    // Web için runtime origin (Vercel domain)
    if (kIsWeb) {
      final origin = Uri.base.origin; // e.g. https://therapistsocial.vercel.app
      final endpoint = '$origin/api/graphql';
      debugPrint('🔵 [APP_CONFIG] Web platform - using origin: $endpoint');
      return endpoint;
    }

    // Tüm diğer platformlar: Vercel prod endpoint
    const endpoint = '$vercelBackendUrl/api/graphql';
    debugPrint('🔵 [APP_CONFIG] Using Vercel backend for all platforms: $endpoint');
    return endpoint;
  }

  // Mapbox Configuration
  static const String mapboxAccessToken =
      'pk.eyJ1IjoiaWhtdWluIiwiYSI6ImNtaXYxYjN0djBoM3IzZnF2eGM5cG9jaGYifQ.HLl104cLoN24GRoC2we4oQ';

  // Cloudflare R2 Configuration
  static const String r2PublicUrl = 'https://your-bucket.r2.dev';

  // Cache Settings
  static const Duration feedCacheDuration = Duration(minutes: 10);
  static const Duration profileCacheDuration = Duration(hours: 24);
  static const Duration mapClusterCacheDuration = Duration(minutes: 5);

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Image Settings
  static const int maxImageSizeMB = 10;
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
  ];
}
