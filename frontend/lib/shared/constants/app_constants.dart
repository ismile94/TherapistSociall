class AppConstants {
  // Cache Keys
  static const String cacheKeyFeed = 'feed_cache';
  static const String cacheKeyProfile = 'profile_cache';
  static const String cacheKeyMapClusters = 'map_clusters_cache';

  // Storage Keys
  static const String storageKeyAccessToken = 'access_token';
  static const String storageKeyRefreshToken = 'refresh_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyLanguage = 'language';

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Image Settings
  static const int maxImageSizeBytes = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
  ];

  // Map Settings
  static const double defaultMapZoom = 10.0;
  static const double minMapZoom = 5.0;
  static const double maxMapZoom = 18.0;
  static const double clusterRadius = 0.01; // degrees

  // Debounce Durations
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration mapUpdateDebounce = Duration(milliseconds: 300);

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Duration fastAnimationDuration = Duration(milliseconds: 200);
}
