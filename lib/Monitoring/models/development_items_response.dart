import 'package:cuidado_infantil/Monitoring/models/development_item.dart';

class DevelopmentItemsResponse {
  final Map<String, DevelopmentItemsByArea> itemsByArea;

  DevelopmentItemsResponse({
    required this.itemsByArea,
  });

  factory DevelopmentItemsResponse.fromJson(Map<String, dynamic> json) {
    Map<String, DevelopmentItemsByArea> itemsByAreaMap = {};
    
    print('🔍 DEBUG DevelopmentItemsResponse.fromJson: json keys: ${json.keys.toList()}');
    
    // El API retorna: { "data": { "items_by_area": { "MG": {...}, "MF": {...}, ... } } }
    // Primero buscar en data.items_by_area
    if (json.containsKey('data') && json['data'] is Map) {
      final data = json['data'] as Map<String, dynamic>;
      print('🔍 DEBUG: Encontrado data, keys: ${data.keys.toList()}');
      
      if (data.containsKey('items_by_area') && data['items_by_area'] is Map) {
        final itemsByArea = data['items_by_area'] as Map<String, dynamic>;
        print('🔍 DEBUG: Encontrado items_by_area, keys: ${itemsByArea.keys.toList()}');
        
        itemsByArea.forEach((areaKey, areaData) {
          if (areaData is Map) {
            try {
              itemsByAreaMap[areaKey] = DevelopmentItemsByArea.fromJson(areaData as Map<String, dynamic>);
              print('✅ DEBUG: Área $areaKey parseada correctamente - ${itemsByAreaMap[areaKey]!.items.length} items');
            } catch (e) {
              print('❌ ERROR parseando área $areaKey: $e');
            }
          } else {
            print('⚠️ WARNING: Área $areaKey no es un Map, es: ${areaData.runtimeType}');
          }
        });
      } else {
        print('⚠️ WARNING: No se encontró items_by_area en data');
      }
    } else {
      // Si no hay data, buscar las áreas directamente en el json
      print('⚠️ WARNING: No se encontró data, buscando áreas directamente');
      final areaKeys = ['MG', 'MF', 'AL', 'PS'];
      
      for (final areaKey in areaKeys) {
        if (json.containsKey(areaKey)) {
          final areaData = json[areaKey];
          print('🔍 DEBUG: Encontrada área $areaKey, type: ${areaData.runtimeType}');
          
          if (areaData is Map) {
            try {
              itemsByAreaMap[areaKey] = DevelopmentItemsByArea.fromJson(areaData as Map<String, dynamic>);
              print('✅ DEBUG: Área $areaKey parseada correctamente - ${itemsByAreaMap[areaKey]!.items.length} items');
            } catch (e) {
              print('❌ ERROR parseando área $areaKey: $e');
            }
          }
        }
      }
    }

    print('✅ DEBUG: Total áreas parseadas: ${itemsByAreaMap.length}');
    return DevelopmentItemsResponse(
      itemsByArea: itemsByAreaMap,
    );
  }

  Map<String, dynamic> toJson() {
    final itemsByAreaJson = <String, dynamic>{};
    itemsByArea.forEach((key, value) {
      itemsByAreaJson[key] = value.toJson();
    });
    return {
      'data': itemsByAreaJson,
    };
  }

  /// Obtiene todos los items de todas las áreas
  List<DevelopmentItem> getAllItems() {
    final allItems = <DevelopmentItem>[];
    itemsByArea.forEach((key, area) {
      allItems.addAll(area.items);
    });
    return allItems;
  }

  /// Obtiene los items de un área específica
  List<DevelopmentItem> getItemsByArea(String area) {
    return itemsByArea[area]?.items ?? [];
  }
}

