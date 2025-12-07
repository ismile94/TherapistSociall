import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // Mapbox initialization is commented out because mapbox_maps_flutter
  // dependency is currently disabled in pubspec.yaml.
  // When map screen is implemented, uncomment the dependency and initialize:
  // MapboxOptions.setAccessToken(AppConfig.mapboxAccessToken);

  runApp(const ProviderScope(child: TherapistSocialApp()));
}
