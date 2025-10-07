import '../../domain/entities/shelter.dart';

class ShelterModel extends Shelter {
  const ShelterModel({
    required super.id,
    required super.name,
    required super.location,
    required super.phone,
    required super.email,
  });

  factory ShelterModel.fromMap(Map<String, dynamic> map) {
    return ShelterModel(
      id: map['id'] as String,
      name: map['name'] as String,
      location: map['location'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
    );
  }
}
