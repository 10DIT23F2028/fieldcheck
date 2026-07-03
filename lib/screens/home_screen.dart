import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../storage/checkin_storage.dart';
import '../widgets/checkin_card.dart';
import '../widgets/empty_state.dart';
import 'detail_screen.dart';
import 'new_checkin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = CheckInStorage.instance;
  bool _refreshing = false;

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    // Re-reads the box from disk, proving the list is backed by real
    // persisted storage rather than just the in-memory Hive cache.
    await _storage.reloadFromDisk();
    if (mounted) setState(() => _refreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FieldCheck'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _refreshing ? null : _refresh,
            icon: _refreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: _storage.listenable(),
        builder: (context, box, _) {
          final items = _storage.getAll();
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  EmptyState(),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return CheckInCard(
                  checkIn: item,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(checkIn: item),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewCheckInScreen()),
          );
          // Saving inside NewCheckInScreen already writes through to disk
          // and the ValueListenableBuilder above updates automatically,
          // so nothing else is needed here.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
