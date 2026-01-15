class DevelopmentItem {
  final String? id;
  final String developmentItemId;
  final int itemNumber;
  final String description;
  final AgeRange? ageRange;
  final bool achieved;
  final String? achievedLabel;

  DevelopmentItem({
    this.id,
    required this.developmentItemId,
    required this.itemNumber,
    required this.description,
    this.ageRange,
    this.achieved = false,
    this.achievedLabel,
  });

  factory DevelopmentItem.fromJson(Map<String, dynamic> json) {
    AgeRange? ageRange;
    
    // El API puede retornar age_range como objeto o age_min_months/age_max_months
    if (json['age_range'] != null && json['age_range'] is Map) {
      ageRange = AgeRange.fromJson(json['age_range'] as Map<String, dynamic>);
    } else if (json['age_min_months'] != null || json['age_max_months'] != null) {
      // Crear AgeRange desde age_min_months y age_max_months
      ageRange = AgeRange(
        minMonths: json['age_min_months'] is int 
            ? json['age_min_months'] 
            : (json['age_min_months'] != null ? int.tryParse(json['age_min_months'].toString()) ?? 0 : 0),
        maxMonths: json['age_max_months'] is int 
            ? json['age_max_months'] 
            : (json['age_max_months'] != null ? int.tryParse(json['age_max_months'].toString()) ?? 0 : 0),
      );
    }

    // El development_item_id puede venir como 'development_item_id' o 'id'
    final developmentItemId = json['development_item_id']?.toString() ?? 
                              json['id']?.toString() ?? 
                              '';

    return DevelopmentItem(
      id: json['id']?.toString(),
      developmentItemId: developmentItemId,
      itemNumber: json['item_number'] is int 
          ? json['item_number'] 
          : (json['item_number'] != null ? int.tryParse(json['item_number'].toString()) ?? 0 : 0),
      description: json['description']?.toString() ?? '',
      ageRange: ageRange,
      achieved: json['achieved'] == true || json['achieved'] == 'true',
      achievedLabel: json['achieved_label']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'development_item_id': developmentItemId,
      'item_number': itemNumber,
      'description': description,
      'age_range': ageRange?.toJson(),
      'achieved': achieved,
      'achieved_label': achievedLabel,
    };
  }
}

class AgeRange {
  final int minMonths;
  final int maxMonths;

  AgeRange({
    required this.minMonths,
    required this.maxMonths,
  });

  factory AgeRange.fromJson(Map<String, dynamic> json) {
    return AgeRange(
      minMonths: json['min_months'] is int 
          ? json['min_months'] 
          : (json['min_months'] != null ? int.tryParse(json['min_months'].toString()) ?? 0 : 0),
      maxMonths: json['max_months'] is int 
          ? json['max_months'] 
          : (json['max_months'] != null ? int.tryParse(json['max_months'].toString()) ?? 0 : 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_months': minMonths,
      'max_months': maxMonths,
    };
  }

  String get formattedRange {
    if (minMonths == maxMonths) {
      return '$minMonths mes${minMonths == 1 ? '' : 'es'}';
    }
    return '$minMonths-$maxMonths meses';
  }
}

class DevelopmentItemsByArea {
  final String area;
  final String areaLabel;
  final List<DevelopmentItem> items;
  final int total;
  final int achievedCount;
  final int notAchievedCount;

  DevelopmentItemsByArea({
    required this.area,
    required this.areaLabel,
    required this.items,
    required this.total,
    required this.achievedCount,
    required this.notAchievedCount,
  });

  factory DevelopmentItemsByArea.fromJson(Map<String, dynamic> json) {
    List<DevelopmentItem> itemsList = [];
    
    print('🔍 DEBUG DevelopmentItemsByArea.fromJson: json keys: ${json.keys.toList()}');
    
    if (json['items'] != null && json['items'] is List) {
      final itemsData = json['items'] as List;
      print('🔍 DEBUG: Encontrada lista de items con ${itemsData.length} elementos');
      
      itemsList = itemsData.map((item) {
        try {
          if (item is Map) {
            return DevelopmentItem.fromJson(item as Map<String, dynamic>);
          } else {
            print('⚠️ WARNING: Item no es un Map, es: ${item.runtimeType}');
            return null;
          }
        } catch (e) {
          print('❌ ERROR parseando item: $e');
          return null;
        }
      }).whereType<DevelopmentItem>().toList();
      
      print('✅ DEBUG: ${itemsList.length} items parseados correctamente');
    } else {
      print('⚠️ WARNING: No se encontró campo "items" o no es una lista');
    }

    // El API puede retornar 'total' o 'total_items'
    final total = json['total'] is int 
        ? json['total'] 
        : (json['total_items'] is int 
            ? json['total_items'] 
            : (json['total'] != null 
                ? int.tryParse(json['total'].toString()) ?? 0 
                : (json['total_items'] != null 
                    ? int.tryParse(json['total_items'].toString()) ?? 0 
                    : itemsList.length)));
    
    final achievedCount = json['achieved_count'] is int 
        ? json['achieved_count'] 
        : (json['achieved_count'] != null ? int.tryParse(json['achieved_count'].toString()) ?? 0 : 0);
    
    final notAchievedCount = json['not_achieved_count'] is int 
        ? json['not_achieved_count'] 
        : (json['not_achieved_count'] != null ? int.tryParse(json['not_achieved_count'].toString()) ?? 0 : 0);

    return DevelopmentItemsByArea(
      area: json['area']?.toString() ?? '',
      areaLabel: json['area_label']?.toString() ?? '',
      items: itemsList,
      total: total,
      achievedCount: achievedCount,
      notAchievedCount: notAchievedCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'area_label': areaLabel,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'achieved_count': achievedCount,
      'not_achieved_count': notAchievedCount,
    };
  }
}

