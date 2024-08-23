import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/flavor/flavor.dart';

part '../generated/infrastructure/supabase_infra.g.dart';

@riverpod
SupabaseInfra supabaseInfra(SupabaseInfraRef ref) => throw UnimplementedError();

class SupabaseInfra {
  SupabaseInfra(this._supabase);

  // ignore: unused_field
  final Supabase _supabase;

  static Future<SupabaseInfra> init() async {
    final supabase = await Supabase.initialize(
      url: environment.supabaseUrl,
      anonKey: environment.supabaseAnonKey,
    );

    return SupabaseInfra(supabase);
  }
}
