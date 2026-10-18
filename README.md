# TABANG Feasibility Demo

TABANG is a Flutter prototype for donor discovery and blood-bank coordination in Digos City. It is configured for Material 3 and can be demonstrated without external credentials.

## Run the Demo

Install Flutter, then run:

```sh
flutter pub get
flutter run
```

No Supabase or Google Maps credentials are required for the demo. The donor map, donor profiles, chats, and blood inventory use bundled in-memory sample data. Changes made during a session reset when the app restarts.

To initialize the optional Supabase client, provide a project URL and publishable key at launch:

```sh
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=your-publishable-key
```

The current demo workflows remain local; connecting database tables, authentication, push notifications, live maps, and durable storage is outside this feasibility prototype.

## Demo Paths

- Discover donation information, browse categories, view sample notifications, and open donor registration.
- Register a sample donor profile with validated fields and a date picker.
- Search and filter sample donors by blood type and barangay; select a barangay on the offline map and inspect matching profiles.
- Filter blood-bank inventory by recipient compatibility, component, status, and search; inspect and reserve available units.
- Submit a validated sample blood request and use the in-memory chat, profile, settings, and help screens.

All people, donor availability, inventory, and request confirmations are illustrative. Do not use this prototype for clinical decisions or real patient data.
