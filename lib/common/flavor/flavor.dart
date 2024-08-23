import 'package:supabase_lt/common/env/env.dart';

const flavor = String.fromEnvironment('FLAVOR');

final environment = switch (flavor) {
  'dev' => Development(),
  'stg' => throw UnimplementedError(),
  'prod' => throw UnimplementedError(),
  _ => throw UnimplementedError(),
};

sealed class Flavor {
  String get flavor;
  String get supabaseUrl;
  String get supabaseAnonKey;
}

class Development extends Flavor {
  @override
  String get flavor => 'dev';

  @override
  String get supabaseUrl => Env.supabaseUrl;

  @override
  String get supabaseAnonKey => Env.supabaseAnonKey;
}

class Staging extends Flavor {
  @override
  String get flavor => throw UnimplementedError();

  @override
  String get supabaseAnonKey => throw UnimplementedError();

  @override
  String get supabaseUrl => throw UnimplementedError();
}

class Production extends Flavor {
  @override
  String get flavor => throw UnimplementedError();

  @override
  String get supabaseAnonKey => throw UnimplementedError();

  @override
  String get supabaseUrl => throw UnimplementedError();
}
