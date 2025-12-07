import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'https://lsyzkkfardbfkbpncogn.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxzeXpra2ZhcmRiZmticG5jb2duIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwNjYxMzEsImV4cCI6MjA4MDY0MjEzMX0.Tq-CiP4cyYFSup9Ze96qY_erbIKA1MGjagVXOUpQEh0';

  // GraphQL Endpoint - Platform aware
  static String get graphqlEndpoint {
    // Production environment variable'dan al (build time)
    const backendUrl = String.fromEnvironment('BACKEND_URL');
    if (backendUrl.isNotEmpty) {
      return '$backendUrl/graphql';
    }
    
    // Web için Vercel URL'ini kullan (runtime'da dinamik)
    if (kIsWeb) {
      // Browser'da window.location'dan al
      // Uri.base.origin mevcut origin'i verir (https://your-app.vercel.app)
      final origin = Uri.base.origin;
      // GraphQL endpoint'i /api/graphql veya /graphql olabilir
      return '$origin/api/graphql';
    }
    
    // FIZIKSEL TELEFON icin gerçek IP kullan
    // EMULATOR için 10.0.2.2 kullan
    if (Platform.isAndroid) {
      // Emulator mu yoksa fiziksel cihaz mi kontrol et
      // Fiziksel cihaz için gerçek IP:
      return 'http://192.168.1.219:4000/graphql';
    }
    // iOS simulator veya desktop için localhost
    return 'http://localhost:4000/graphql';
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
