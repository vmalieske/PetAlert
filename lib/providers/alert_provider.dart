import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../models/alert_data.dart';

class AlertProvider extends ChangeNotifier {
  late Box<AlertData> _box;
  List<AlertData> _datasets = [];

  AlertProvider() {
    _load();
  }

  List<AlertData> get datasets => _datasets;

  AlertData get defaultDataset =>
      _datasets.firstWhere((d) => d.isDefault, orElse: () => _datasets.first);

  void _load() {
    _box = Hive.box<AlertData>('alerts');
    _datasets = _box.values.toList();

    if (_datasets.isEmpty) {
      final initial = AlertData(
        id: '1',
        title: 'Zuhause',
        location: 'Zuhause',
        animals: [Animal(type: 'Hund', name: 'Bello')],
        contactName: 'Mama',
        contactPhone: '0123 456789',
        notes: 'Achtung, Hund verteidigt Revier',
        isDefault: true,
      );
      _box.put(initial.id, initial);
      _datasets = [initial];
    }
  }

  void add(AlertData data) {
    _box.put(data.id, data);
    _datasets = _box.values.toList();
    notifyListeners();
  }

  void update(AlertData data) {
    _box.put(data.id, data);
    _datasets = _box.values.toList();
    notifyListeners();
  }

  void remove(String id) {
    _box.delete(id);
    _datasets = _box.values.toList();
    if (_datasets.isNotEmpty && !_datasets.any((d) => d.isDefault)) {
      final first = _datasets.first.copyWith(isDefault: true);
      _box.put(first.id, first);
      _datasets = _box.values.toList();
    }
    notifyListeners();
  }

  void setDefault(String id) {
    final updated = _datasets
        .map((d) => d.copyWith(isDefault: d.id == id))
        .toList();
    for (final d in updated) {
      _box.put(d.id, d);
    }
    _datasets = updated;
    notifyListeners();
  }
}
