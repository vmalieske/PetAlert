import 'package:hive_ce/hive.dart';

part 'alert_data.g.dart';

@HiveType(typeId: 0)
class Animal {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final String name;

  Animal({this.type = '', this.name = ''});

  Animal copyWith({String? type, String? name}) {
    return Animal(type: type ?? this.type, name: name ?? this.name);
  }

  String get display => '$type $name'.trim();
}

@HiveType(typeId: 1)
class AlertData {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final List<Animal> animals;

  @HiveField(4)
  final String contactName;

  @HiveField(5)
  final String contactPhone;

  @HiveField(6)
  final String notes;

  @HiveField(7)
  final bool isDefault;

  AlertData({
    required this.id,
    this.title = '',
    this.location = '',
    this.animals = const [],
    this.contactName = '',
    this.contactPhone = '',
    this.notes = '',
    this.isDefault = false,
  });

  String get notificationTitle {
    final animalText = animals.map((animal) => animal.display).join(', ');
    final loc = location.isNotEmpty ? location : 'Zuhause';
    return '🐾 $loc wartet $animalText';
  }

  String get notificationText {
    return contactName.isNotEmpty
        ? 'Notfallkontakt: $contactName · $contactPhone'
        : 'Kein Notfallkontakt hinterlegt';
  }

  String get displayTitle => title.isNotEmpty ? title : location;

  AlertData copyWith({
    String? title,
    String? location,
    List<Animal>? animals,
    String? contactName,
    String? contactPhone,
    String? notes,
    bool? isDefault,
  }) {
    return AlertData(
      id: id,
      title: title ?? this.title,
      location: location ?? this.location,
      animals: animals ?? this.animals,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      notes: notes ?? this.notes,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
