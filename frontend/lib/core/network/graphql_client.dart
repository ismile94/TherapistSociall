import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';

final graphqlClientProvider = Provider<GraphQLClient>((ref) {
  final httpLink = HttpLink(
    AppConfig.graphqlEndpoint,
    defaultHeaders: {'Content-Type': 'application/json'},
  );

  final authLink = AuthLink(
    getToken: () async {
      final token = await SecureStorageService.getAccessToken();
      return token != null ? 'Bearer $token' : null;
    },
  );

  final link = authLink.concat(httpLink);

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
  );
});

final graphqlProvider = Provider<ValueNotifier<GraphQLClient>>((ref) {
  final client = ref.watch(graphqlClientProvider);
  return ValueNotifier(client);
});
