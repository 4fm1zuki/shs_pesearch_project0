import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabasePublishableKey =
    String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

bool _backendReady = false;

bool get isBackendConfigured =>
    _supabaseUrl.isNotEmpty && _supabasePublishableKey.isNotEmpty;

SupabaseClient? get backendClient =>
    _backendReady ? Supabase.instance.client : null;

Future<void> initializeBackend() async {
  if (!isBackendConfigured) return;

  try {
    await Supabase.initialize(
      url: _supabaseUrl,
      publishableKey: _supabasePublishableKey,
    );
    _backendReady = true;
  } catch (error) {
    debugPrint('Supabase initialization failed; using local demo data: $error');
  }
}
