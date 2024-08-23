// ignore_for_file: avoid_classes_with_only_static_members

import 'package:envied/envied.dart';

part '../../generated/env/env.g.dart';

@Envied(path: './envied.env')
abstract class Env {
  @EnviedField(varName: 'Supabase_URL', obfuscate: true)
  static final String supabaseUrl = _Env.supabaseUrl;
  @EnviedField(varName: 'Supabase_Anon_Key', obfuscate: true)
  static final String supabaseAnonKey = _Env.supabaseAnonKey;
}
