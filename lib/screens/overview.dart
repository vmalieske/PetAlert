import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alert_provider.dart';
import '../models/alert_data.dart';
import 'edit.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  void _showContextMenu(BuildContext context, AlertData data) {
    final provider = context.read<AlertProvider>();
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!data.isDefault)
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Als Standard setzen'),
                onTap: () {
                  provider.setDefault(data.id);
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Bearbeiten'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditScreen(existing: data)),
                );
              },
            ),
            if (!data.isDefault)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Löschen',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  provider.remove(data.id);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final datasets = context.watch<AlertProvider>().datasets;

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: datasets.length,
        itemBuilder: (context, index) {
          final data = datasets[index];
          return _DatasetCard(
            data: data,
            onLongPress: () => _showContextMenu(context, data),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'overview_fab',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DatasetCard extends StatelessWidget {
  final AlertData data;
  final VoidCallback onLongPress;

  const _DatasetCard({required this.data, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: data.isDefault
              ? BorderSide(color: color, width: 2.5)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.displayTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (data.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Standard',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _PreviewRow(
                icon: Icons.location_on_outlined,
                value: data.location.isNotEmpty ? data.location : '-',
              ),
              _PreviewRow(
                icon: Icons.pets_outlined,
                value: data.animals.isNotEmpty
                    ? data.animals.map((a) => a.display).join(', ')
                    : '-',
              ),
              _PreviewRow(
                icon: Icons.phone_outlined,
                value: data.contactName.isNotEmpty
                    ? '${data.contactName} · ${data.contactPhone}'
                    : 'Kein Kontakt hinterlegt',
              ),
              if (data.notes.isNotEmpty)
                _PreviewRow(icon: Icons.notes_outlined, value: data.notes),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _PreviewRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
