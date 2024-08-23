import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_lt/infrastructure/graphql_client.dart';

import 'package:supabase_lt/infrastructure/supabase_infra.dart';
import 'package:supabase_lt/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHiveForFlutter();

  late final SupabaseInfra supabaseInfra;

  await Future.wait(
    [
      Future(() async {
        supabaseInfra = await SupabaseInfra.init();
      }),
    ],
  );

  final container = ProviderContainer(
    overrides: [
      supabaseInfraProvider.overrideWithValue(supabaseInfra),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: GraphQLProvider(
        client: graphCLClientInit(),
        child: const App(),
      ),
    ),
  );
}
