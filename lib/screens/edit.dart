import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/alert_data.dart';
import '../providers/alert_provider.dart';

class EditScreen extends StatefulWidget {
  final AlertData? existing;
  const EditScreen({super.key, this.existing});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _title;
  late TextEditingController _location;
  late TextEditingController _contactName;
  late TextEditingController _contactPhone;
  late TextEditingController _notes;
  late List<Animal> _animals;

  @override
  void initState() {
    super.initState();
    final data = widget.existing;
    _title = TextEditingController(text: data?.title ?? '');
    _location = TextEditingController(text: data?.location ?? '');
    _contactName = TextEditingController(text: data?.contactName ?? '');
    _contactPhone = TextEditingController(text: data?.contactPhone ?? '');
    _notes = TextEditingController(text: data?.notes ?? '');
    _animals = List.from(data?.animals ?? []);
  }

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _contactName.dispose();
    _contactPhone.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _addAnimal() {
    setState(() => _animals.add(Animal()));
  }

  void _removeAnimal(int index) {
    setState(() => _animals.removeAt(index));
  }

  void _save() {
    final provider = context.read<AlertProvider>();
    final base = widget.existing ?? AlertData(id: const Uuid().v4());
    final data = base.copyWith(
      title: _title.text,
      location: _location.text,
      contactName: _contactName.text,
      contactPhone: _contactPhone.text,
      notes: _notes.text,
      animals: _animals,
    );
    if (widget.existing != null) {
      provider.update(data);
    } else {
      provider.add(data);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing != null ? 'Bearbeiten' : 'Neu'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.check))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildField('Titel (optional)', 'z.B. Zuhause', _title),
          _buildField('Ort', 'z.B. Bei Freund Peter', _location),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tiere',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: _addAnimal,
                icon: const Icon(Icons.add),
                label: const Text('Tier hinzufügen'),
              ),
            ],
          ),
          ..._animals.asMap().entries.map((entry) {
            final i = entry.key;
            final animal = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Tierart',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(text: animal.type),
                        onChanged: (v) =>
                            _animals[i] = _animals[i].copyWith(type: v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(text: animal.name),
                        onChanged: (v) =>
                            _animals[i] = _animals[i].copyWith(name: v),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _removeAnimal(i),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          _buildField('Notfallkontakt Name', 'z.B. Mama', _contactName),
          _buildField(
            'Notfallkontakt Nummer',
            'z.B. 0123 456789',
            _contactPhone,
            keyboardType: TextInputType.phone,
          ),
          _buildField(
            'Notizen',
            'z.B. Achtung, Hund verteidigt Revier',
            _notes,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
