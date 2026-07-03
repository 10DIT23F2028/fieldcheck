import 'package:flutter/foundation.dart' show ValueListenable; // Add this
import 'package:hive_flutter/hive_flutter.dart';
import '../models/checkin.dart';

/// Persists check-ins locally with Hive so every saved record survives an
/// app restart. Hive is used instead of sqflite/shared_preferences because
/// it gives us a fast key-value box plus a ValueListenable the UI can
/// listen to directly (so a manual "refresh" simply re-reads from disk).
class CheckInStorage {
  CheckInStorage._();
  static final CheckInStorage instance = CheckInStorage._();

  static const String boxName = 'checkins';
  Box? _box;

  Box get box {
    final b = _box;
    if (b == null) {
      throw StateError('CheckInStorage.init() must be called before use');
    }
    return b;
  }

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  /// Listenable the Home screen subscribes to so the list updates live
  /// whenever data changes, including after the explicit refresh action.
  ValueListenable<Box> listenable() => box.listenable();

  List<CheckIn> getAll() {
    final items = box.values
        .map((e) => CheckIn.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> save(CheckIn checkIn) async {
    await box.put(checkIn.id, checkIn.toMap());
    // flush() forces Hive to write through to disk immediately instead of
    // waiting for its lazy compaction, so data is durable right away.
    await box.flush();
  }

  /// Re-opens the box from disk. This is what backs the visible "Refresh"
  /// button: it proves the list reflects what is actually persisted, not
  /// just in-memory state, and it's what makes data survive a full app
  /// close + relaunch.
  Future<void> reloadFromDisk() async {
    await box.flush();
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox(boxName);
    }
  }
}