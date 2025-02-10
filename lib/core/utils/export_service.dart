// lib/core/export_service.dart
import 'dart:convert';
import '../../models/models.dart';

class ExportService {
  String exportDashboardToJson(Dashboard dashboard) {
    final Map<String, dynamic> data = {
      'id': dashboard.id,
      'name': dashboard.name,
      'charts': dashboard.charts.map((c) => {
        'id': c.id,
        'name': c.name, // Added chart name
        'type': c.type,
        'dimensions': c.dimensions.map((d) => {
          'name': d.name,
          'type': d.type,
          'isNumeric': d.isNumeric,
          'isDate': d.isDate,
        }).toList(),
        'measures': c.measures.map((m) => {
          'name': m.name,
          'type': m.type,
          'isNumeric': m.isNumeric,
          'isDate': m.isDate,
        }).toList(),
        'settings': c.settings,
        'dataSourceId': c.dataSource.id, // Export DataSource ID
      }).toList(),
      'layout': dashboard.layout,
    };

    return jsonEncode(data);
  }

  Dashboard? importDashboardFromJson(String jsonStr) {
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      return Dashboard(
        id: data['id'] as String,
        name: data['name'] as String,
        charts: (data['charts'] as List).map((c) {
          return ChartWidget(
            id: c['id'] as String,
            name: c['name'] as String,
            type: c['type'] as String,
            dimensions: (c['dimensions'] as List).map((d) {
              return Field(
                name: d['name'] as String,
                type: d['type'] as String,
                isNumeric: d['isNumeric'] as bool,
                isDate: d['isDate'] as bool,
              );
            }).toList(),
            measures: (c['measures'] as List).map((m) {
              return Field(
                name: m['name'] as String,
                type: m['type'] as String,
                isNumeric: m['isNumeric'] as bool,
                isDate: m['isDate'] as bool,
              );
            }).toList(),
            settings: Map<String, dynamic>.from(c['settings']),
            dataSource: DataSource( // Placeholder DataSource
              id: c['dataSourceId'] as String,
              name: 'Placeholder', // Consider storing the name too
              type: 'Unknown',
              fields: [],
              createdAt: DateTime.now(),
              records: [],
            ),
          );
        }).toList(),
        layout: Map<String, dynamic>.from(data['layout']),
      );
    } catch (e) {
      print('Error importing dashboard: $e');
      return null;
    }
  }
}