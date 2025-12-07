import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';

final graphqlClientProvider = Provider<GraphQLClient>((ref) {
  final endpoint = AppConfig.graphqlEndpoint;
  debugPrint('🔵 [GRAPHQL_CLIENT] Initializing GraphQL client');
  debugPrint('🔵 [GRAPHQL_CLIENT] Endpoint: $endpoint');
  
  final httpLink = HttpLink(
    endpoint,
    defaultHeaders: {'Content-Type': 'application/json'},
  );

  final authLink = AuthLink(
    getToken: () async {
      final token = await SecureStorageService.getAccessToken();
      final hasToken = token != null;
      debugPrint('🔵 [GRAPHQL_CLIENT] AuthLink getToken called - hasToken: $hasToken');
      return token != null ? 'Bearer $token' : null;
    },
  );

  final link = authLink.concat(httpLink);

  final client = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
  );
  
  debugPrint('🟢 [GRAPHQL_CLIENT] GraphQL client initialized');
  return client;
});

final graphqlProvider = Provider<ValueNotifier<GraphQLClient>>((ref) {
  final client = ref.watch(graphqlClientProvider);
  return ValueNotifier(client);
});
