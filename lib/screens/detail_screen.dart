import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/checkin.dart';

class DetailScreen extends StatelessWidget {
  final CheckIn checkIn;
  const DetailScreen({super.key, required this.checkIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-In Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PhotoView(path: checkIn.imagePath),
          const SizedBox(height: 20),
          const _Label('Note'),
          Text(checkIn.note.isEmpty ? '(no note)' : checkIn.note,
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          _ReadOnlyRow('Latitude',
              checkIn.latitude.toStringAsFixed(6)),
          _ReadOnlyRow('Longitude',
              checkIn.longitude.toStringAsFixed(6)),
          _ReadOnlyRow('Accuracy',
              checkIn.accuracy != null
                  ? '${checkIn.accuracy!.toStringAsFixed(1)} m'
                  : '—'),
          _ReadOnlyRow(
            'Created At',
            DateFormat('MMM d, yyyy • h:mm a').format(checkIn.createdAt),
          ),
        ],
      ),
    );
  }
}

class _PhotoView extends StatelessWidget {
  final String? path;
  const _PhotoView({required this.path});

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined,
              color: Colors.redAccent, size: 36),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(path!),
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReadOnlyRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
