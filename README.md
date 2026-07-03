# FieldCheck — Field Check-In App

A small Flutter app to check in at a location: take a photo, record GPS
coordinates, and save the record locally so it appears in a history list
and survives an app restart.

## How to run

1. Make sure Flutter is installed (`flutter doctor`).
2. From the project root:
   ```
   flutter pub get
   ```
3. Add the native permissions (required for camera/location to work on
   device — these are **not** added automatically by `flutter create`,
   since this project was authored as source files only):
   - Open `android/app/src/main/AndroidManifest_PERMISSIONS_SNIPPET.xml`
     and copy its contents into your `AndroidManifest.xml`, inside the
     `<manifest>` tag.
   - Open `ios/Runner/Info_PERMISSIONS_SNIPPET.plist` and copy its keys
     into your `ios/Runner/Info.plist`, inside the top-level `<dict>`.
4. Run on a real device or simulator/emulator with a camera + location
   available:
   ```
   flutter run
   ```
   (Camera and precise GPS generally don't work on the iOS Simulator —
   use a physical device or an Android emulator with a configured
   location.)

## Plugins used

| Purpose        | Plugin                                  |
|-----------------|------------------------------------------|
| Camera          | `image_picker`                          |
| GPS             | `geolocator`, `permission_handler`      |
| Local storage   | `hive`, `hive_flutter`, `path_provider` |
| IDs / dates     | `uuid`, `intl`                          |

Storage uses Hive instead of sqflite/shared_preferences: each check-in is
stored as a plain map (id, note, photo path, lat/lng/accuracy, createdAt)
in a single Hive box, so no code generation step is required. `box.flush()`
is called on every save so data is written through to disk immediately —
this is what makes the **refresh button** on Home meaningful: it re-opens
the box from disk (`reloadFromDisk()`), proving the list reflects what is
actually persisted rather than just in-memory state, and confirming data
survives a full app close + relaunch.

## Project structure

```
lib/
  models/checkin.dart          CheckIn data model (toMap/fromMap)
  storage/checkin_storage.dart Hive read/write/refresh logic
  widgets/checkin_card.dart    Reusable history list row
  widgets/empty_state.dart     Empty state for Home
  screens/home_screen.dart     Home / History (+ refresh, FAB)
  screens/new_checkin_screen.dart  New Check-In form
  screens/detail_screen.dart   Read-only Detail screen
  main.dart                    App entry + red/white theme
```

## Requirements checklist

### 1 · UI Layouts
- [x] Three screens (Home/History, New Check-In, Detail) with navigation
- [x] Home: list with thumbnail + note + timestamp, plus empty state
- [x] New Check-In: note field with validation, Take Photo + preview,
      Get Location with lat/lng/accuracy + loading state, Save button
- [x] Detail: read-only record view
- [x] Split into reusable components (`CheckInCard`, `EmptyState`,
      `_NoteField`, `_PhotoSection`, `_LocationSection`) — no giant
      single `build()`

### 2 · Hardware integration
- [x] Camera — `image_picker` (camera source), shown as a preview with a
      remove (✕) action
- [x] GPS — `geolocator`, shows latitude / longitude / accuracy with a
      "fetching…" loading state
- [x] Local storage — `hive`, every check-in persists across app restarts
- [x] Permissions handled for both camera and location; denied/disabled
      permissions show a message instead of crashing the app

### Extra (per request)
- [x] Red & white theme throughout
- [x] Refresh button on Home that reloads the persisted data from disk

### Known limitations / not done
- No edit or delete on existing check-ins (wireframe only specifies
  read-only Detail, so this was intentionally left out)
- No automated tests included
- Not yet verified on a physical iOS device (built and reasoned through
  against the geolocator/image_picker APIs, but I don't have a device
  here to record the requested screen capture — please run `flutter run`
  locally to confirm the photo / GPS / saved-history flow, then attach
  your own screenshots or screen recording here before submitting)
