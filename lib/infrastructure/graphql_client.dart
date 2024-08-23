import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';

import '../common/flavor/flavor.dart';

ValueNotifier<GraphQLClient> graphCLClientInit() {
  return ValueNotifier(
    GraphQLClient(
      link: HttpLink(
        '${environment.supabaseUrl}/graphql/v1',
        httpClient: ApiKeyClient(Client()),
      ),
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    ),
  );
}

class ApiKeyClient extends BaseClient {
  ApiKeyClient(this.client);
  final Client client;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    final anonKey = environment.supabaseAnonKey;
    if (anonKey.isNotEmpty) {
      request.headers['apiKey'] = anonKey;
    }

    return client.send(request);
  }
}
