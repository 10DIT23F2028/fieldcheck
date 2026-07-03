import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/checkin.dart';
import '../storage/checkin_storage.dart';

class NewCheckInScreen extends StatefulWidget {
  const NewCheckInScreen({super.key});

  @override
  State<NewCheckInScreen> createState() => _NewCheckInScreenState();
}

enum _LocationState { idle, loading, done, error }

class _NewCheckInScreenState extends State<NewCheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  File? _photo;
  bool _savingPhoto = false;

  _LocationState _locationState = _LocationState.idle;
  Position? _position;
  String? _locationError;

  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------
  // Photo capture
  // ---------------------------------------------------------------------
  Future<void> _takePhoto() async {
    try {
      final picker = ImagePicker();
      final XFile? shot = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (shot == null) return; // user cancelled — not an error

      setState(() => _savingPhoto = true);
      // Copy into app documents dir so the path stays valid across runs.
      final docsDir = await getApplicationDocumentsDirectory();
      final fileName =
          'checkin_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile =
          await File(shot.path).copy('${docsDir.path}/$fileName');

      setState(() {
        _photo = savedFile;
        _savingPhoto = false;
      });
    } catch (e) {
      setState(() => _savingPhoto = false);
      _showSnack('Could not access the camera. Check camera permission.');
    }
  }

  void _removePhoto() => setState(() => _photo = null);

  // ---------------------------------------------------------------------
  // GPS
  // ---------------------------------------------------------------------
  Future<void> _getLocation() async {
    setState(() {
      _locationState = _LocationState.loading;
      _locationError = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are turned off.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permission denied: handled gracefully, app must not crash.
        throw 'Location permission denied. Enable it in app settings.';
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _position = pos;
        _locationState = _LocationState.done;
      });
    } catch (e) {
      setState(() {
        _locationState = _LocationState.error;
        _locationError = e.toString();
      });
    }
  }

  // ---------------------------------------------------------------------
  // Save
  // ---------------------------------------------------------------------
  Future<void> _save() async {
    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;

    if (_photo == null) {
      _showSnack('Please take a photo before saving.');
      return;
    }
    if (_position == null) {
      _showSnack('Please get your location before saving.');
      return;
    }

    setState(() => _saving = true);

    final checkIn = CheckIn(
      id: const Uuid().v4(),
      note: _noteController.text.trim(),
      imagePath: _photo!.path,
      latitude: _position!.latitude,
      longitude: _position!.longitude,
      accuracy: _position!.accuracy,
      createdAt: DateTime.now(),
    );

    await CheckInStorage.instance.save(checkIn);

    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Check-In')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _NoteField(controller: _noteController),
            const SizedBox(height: 20),
            _PhotoSection(
              photo: _photo,
              loading: _savingPhoto,
              onTakePhoto: _takePhoto,
              onRemove: _removePhoto,
            ),
            const SizedBox(height: 20),
            _LocationSection(
              state: _locationState,
              position: _position,
              error: _locationError,
              onGetLocation: _getLocation,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Reusable form sections (keeps build() small, per the requirements)
// ---------------------------------------------------------------------

class _NoteField extends StatelessWidget {
  final TextEditingController controller;
  const _NoteField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Note **',
        hintText: 'Enter your name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Note is required';
        }
        return null;
      },
    );
  }
}

class _PhotoSection extends StatelessWidget {
  final File? photo;
  final bool loading;
  final VoidCallback onTakePhoto;
  final VoidCallback onRemove;

  const _PhotoSection({
    required this.photo,
    required this.loading,
    required this.onTakePhoto,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Photo *',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: loading ? null : onTakePhoto,
          icon: const Icon(Icons.camera_alt_outlined),
          label: Text(photo == null ? 'Take Photo' : 'Retake Photo'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(46),
          ),
        ),
        const SizedBox(height: 10),
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (photo != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  photo!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: onRemove,
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        else
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('No photo yet',
                  style: TextStyle(color: Colors.grey[500])),
            ),
          ),
      ],
    );
  }
}

class _LocationSection extends StatelessWidget {
  final _LocationState state;
  final Position? position;
  final String? error;
  final VoidCallback onGetLocation;

  const _LocationSection({
    required this.state,
    required this.position,
    required this.error,
    required this.onGetLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location *',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: state == _LocationState.loading ? null : onGetLocation,
          icon: const Icon(Icons.location_on_outlined),
          label: const Text('Get Location'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(46),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.withOpacity(0.15)),
          ),
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (state) {
      case _LocationState.idle:
        return Text('Not fetched yet', style: TextStyle(color: Colors.grey[600]));
      case _LocationState.loading:
        return const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text('fetching…'),
          ],
        );
      case _LocationState.error:
        return Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error ?? 'Could not get location.',
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      case _LocationState.done:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _kv('Latitude', position!.latitude.toStringAsFixed(6)),
            _kv('Longitude', position!.longitude.toStringAsFixed(6)),
            _kv('Accuracy', '${position!.accuracy.toStringAsFixed(1)} m'),
          ],
        );
    }
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: TextStyle(color: Colors.grey[700])),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
