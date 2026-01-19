enum GuardianType {
  mother('madre', 'Madre'),
  father('padre', 'Padre'),
  both('ambos', 'Ambos'),
  tutor('tutor', 'Tutor'),
  olderSibling('hermano', 'Hermano'),
  grandparents('abuelos', 'Abuelos'),
  uncles('tios', 'Tíos'),
  other('otros', 'Otros');

  final String value;
  final String label;

  const GuardianType(this.value, this.label);

  static GuardianType? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return GuardianType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum HousingFinish {
  fineWork('obra_fina', 'Obra fina'),
  roughWork('obra_gruesa', 'Obra gruesa');

  final String value;
  final String label;

  const HousingFinish(this.value, this.label);

  static HousingFinish? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return HousingFinish.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum HousingFloorMaterial {
  earth('tierra', 'Tierra'),
  cement('cemento', 'Cemento'),
  tongueAndGroove('machimbre', 'Machimbre'),
  parquet('parquet', 'Parquet');

  final String value;
  final String label;

  const HousingFloorMaterial(this.value, this.label);

  static HousingFloorMaterial? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return HousingFloorMaterial.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum HousingTenure {
  owned('propio', 'Propio'),
  rented('alquiler', 'Alquiler'),
  antichresis('anticretico', 'Anticrético'),
  family('familiar', 'Familiar'),
  caretaker('cuidador', 'Cuidador');

  final String value;
  final String label;

  const HousingTenure(this.value, this.label);

  static HousingTenure? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return HousingTenure.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum HousingType {
  house('casa', 'Casa'),
  apartment('departamento', 'Departamento'),
  room('cuarto', 'Cuarto'),
  other('otro', 'Otro');

  final String value;
  final String label;

  const HousingType(this.value, this.label);

  static HousingType? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return HousingType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum HousingUtility {
  drinkingWater('agua_potable', 'Agua Potable'),
  electricity('energia_electrica', 'Energía Eléctrica'),
  sewerage('alcantarillado', 'Alcantarillado'),
  gas('gas', 'Gas'),
  phone('telefono', 'Teléfono'),
  internet('internet', 'Internet');

  final String value;
  final String label;

  const HousingUtility(this.value, this.label);

  static HousingUtility? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return HousingUtility.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum HousingWallMaterial {
  wood('madera', 'Madera'),
  brick('ladrillo', 'Ladrillo'),
  adobe('adobe', 'Adobe');

  final String value;
  final String label;

  const HousingWallMaterial(this.value, this.label);

  static HousingWallMaterial? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return HousingWallMaterial.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum TransportType {
  own('propio', 'Propio'),
  public('publico', 'Público'),
  walking('a_pie', 'A Pie');

  final String value;
  final String label;

  const TransportType(this.value, this.label);

  static TransportType? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return TransportType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum TravelTime {
  lessThanHalfHour('menos_media_hora', 'Menos de Media Hora'),
  halfToOneHour('media_a_una_hora', 'Media a Una Hora'),
  moreThanOneHour('mas_de_una_hora', 'Más de Una Hora');

  final String value;
  final String label;

  const TravelTime(this.value, this.label);

  static TravelTime? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return TravelTime.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
