import 'dart:io';
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
    // Production environment variable'dan al (build time)
    const backendUrl = String.fromEnvironment('BACKEND_URL');
    if (backendUrl.isNotEmpty) {
      debugPrint('🔵 [APP_CONFIG] Using BACKEND_URL from environment: $backendUrl');
      return '$backendUrl/graphql';
    }
    
    // Production mode check - kReleaseMode Flutter'ın release build flag'i
    const bool isProduction = bool.fromEnvironment('dart.vm.product', defaultValue: false);
    const bool isReleaseMode = kReleaseMode;
    
    debugPrint('🔵 [APP_CONFIG] isProduction: $isProduction, isReleaseMode: $isReleaseMode, kIsWeb: $kIsWeb');
    
    // Web için Vercel URL'ini kullan (runtime'da dinamik)
    if (kIsWeb) {
      // Browser'da window.location'dan al
      // Uri.base.origin mevcut origin'i verir (https://your-app.vercel.app)
      final origin = Uri.base.origin;
      final endpoint = '$origin/api/graphql';
      debugPrint('🔵 [APP_CONFIG] Web platform - using origin: $endpoint');
      // GraphQL endpoint'i /api/graphql veya /graphql olabilir
      return endpoint;
    }
    
    // Production build'de (release mode) Vercel URL'ini kullan
    if (isReleaseMode || isProduction) {
      final endpoint = '$vercelBackendUrl/api/graphql';
      debugPrint('🔵 [APP_CONFIG] Production mode - using Vercel URL: $endpoint');
      return endpoint;
    }
    
    // Development mode - local backend kullan
    if (Platform.isAndroid) {
      // Emulator için 10.0.2.2, fiziksel cihaz için local IP
      // Emulator kontrolü için Flutter'ın kendi mekanizmasını kullanabiliriz
      // Şimdilik fiziksel cihaz için local IP kullanıyoruz
      final endpoint = 'http://192.168.1.219:4000/graphql';
      debugPrint('🔵 [APP_CONFIG] Android development - using local IP: $endpoint');
      return endpoint;
    }
    // iOS simulator veya desktop için localhost
    final endpoint = 'http://localhost:4000/graphql';
    debugPrint('🔵 [APP_CONFIG] iOS/Desktop development - using localhost: $endpoint');
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
