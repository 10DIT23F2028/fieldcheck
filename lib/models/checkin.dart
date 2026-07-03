import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class CheckIn {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String note;
  
  @HiveField(2)
  final String imagePath;
  
  @HiveField(3)
  final double latitude;
  
  @HiveField(4)
  final double longitude;
  
  @HiveField(5)
  final double? accuracy;
  
  @HiveField(6)
  final DateTime createdAt;

  CheckIn({
    required this.id,
    required this.note,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CheckIn.fromMap(Map<dynamic, dynamic> map) {
    return CheckIn(
      id: map['id'] as String,
      note: map['note'] as String,
      imagePath: map['imagePath'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      accuracy: map['accuracy'] as double?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}