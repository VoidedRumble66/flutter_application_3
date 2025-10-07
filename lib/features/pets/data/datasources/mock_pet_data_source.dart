import '../models/pet_model.dart';
import '../models/shelter_model.dart';

class MockPetDataSource {
  const MockPetDataSource();

  List<PetModel> fetchPets() {
    return _petData.map(PetModel.fromMap).toList();
  }

  List<ShelterModel> fetchShelters() {
    return _shelterData.map(ShelterModel.fromMap).toList();
  }
}

final List<Map<String, dynamic>> _shelterData = [
  {
    'id': 'shelter_1',
    'name': 'Refugio Patitas Felices',
    'location': 'Ciudad de México, CDMX',
    'phone': '+52 55 1234 5678',
    'email': 'contacto@patitasfelices.mx',
  },
  {
    'id': 'shelter_2',
    'name': 'Huellitas del Sur',
    'location': 'Mérida, Yucatán',
    'phone': '+52 999 987 6543',
    'email': 'hola@huellitasdelsur.org',
  },
  {
    'id': 'shelter_3',
    'name': 'Guardianes de Bigotes',
    'location': 'Guadalajara, Jalisco',
    'phone': '+52 33 3456 7890',
    'email': 'adopta@guardianesbigotes.mx',
  },
];

final List<Map<String, dynamic>> _petData = [
  {
    'id': 'pet_1',
    'name': 'Luna',
    'species': 'gato',
    'breed': 'Siamés',
    'age': 2,
    'size': 'small',
    'gender': 'female',
    'description':
        'Luna es una gatita juguetona y curiosa que ama dormir al sol y recibir cariños en la pancita.',
    'photoUrls': [
      'https://images.unsplash.com/photo-1518791841217-8f162f1e1131',
      'https://images.unsplash.com/photo-1494256997604-768d1f608cac',
    ],
    'isVaccinated': true,
    'isNeutered': true,
    'shelterId': 'shelter_1',
    'location': 'Ciudad de México, CDMX',
  },
  {
    'id': 'pet_2',
    'name': 'Bongo',
    'species': 'perro',
    'breed': 'Labrador Retriever',
    'age': 4,
    'size': 'large',
    'gender': 'male',
    'description':
        'Bongo es un compañero leal con energía para compartir aventuras y caminatas largas.',
    'photoUrls': [
      'https://images.unsplash.com/photo-1507149833265-60c372daea22',
      'https://images.unsplash.com/photo-1494253109108-2e30c049369b',
    ],
    'isVaccinated': true,
    'isNeutered': true,
    'shelterId': 'shelter_1',
    'location': 'Ciudad de México, CDMX',
  },
  {
    'id': 'pet_3',
    'name': 'Milo',
    'species': 'perro',
    'breed': 'Mestizo mediano',
    'age': 1,
    'size': 'medium',
    'gender': 'male',
    'description':
        'Milo es un cachorrito muy inteligente que ya conoce órdenes básicas y disfruta convivir con otros perros.',
    'photoUrls': [
      'https://images.unsplash.com/photo-1548199973-03cce0bbc87b',
      'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e',
    ],
    'isVaccinated': true,
    'isNeutered': false,
    'shelterId': 'shelter_2',
    'location': 'Mérida, Yucatán',
  },
  {
    'id': 'pet_4',
    'name': 'Coco',
    'species': 'ave',
    'breed': 'Cotorra Amazona',
    'age': 5,
    'size': 'small',
    'gender': 'female',
    'description':
        'Coco adora cantar y repetir frases. Está acostumbrada a convivir con familias y necesita mucha atención.',
    'photoUrls': [
      'https://images.unsplash.com/photo-1546443046-ed1ce6ffd1ab',
      'https://images.unsplash.com/photo-1444464666168-49d633b86797',
    ],
    'isVaccinated': true,
    'isNeutered': false,
    'shelterId': 'shelter_2',
    'location': 'Mérida, Yucatán',
  },
  {
    'id': 'pet_5',
    'name': 'Manchitas',
    'species': 'conejo',
    'breed': 'Holandés Enano',
    'age': 3,
    'size': 'small',
    'gender': 'male',
    'description':
        'Manchitas es un conejito muy tranquilo que disfruta los espacios seguros y los snacks de zanahoria.',
    'photoUrls': [
      'https://images.unsplash.com/photo-1542676028-1721e3c9fe63',
      'https://images.unsplash.com/photo-1504788368824-232dff0c7318',
    ],
    'isVaccinated': true,
    'isNeutered': true,
    'shelterId': 'shelter_3',
    'location': 'Guadalajara, Jalisco',
  },
  {
    'id': 'pet_6',
    'name': 'Mora',
    'species': 'gato',
    'breed': 'Criollo',
    'age': 6,
    'size': 'medium',
    'gender': 'female',
    'description':
        'Mora es una gata independiente y amorosa que busca un hogar tranquilo donde descansar en compañía.',
    'photoUrls': [
      'https://images.unsplash.com/photo-1511300636408-a63a89df3482',
      'https://images.unsplash.com/photo-1516371714279-8a2b7e00ad32',
    ],
    'isVaccinated': true,
    'isNeutered': true,
    'shelterId': 'shelter_3',
    'location': 'Guadalajara, Jalisco',
  },
];
