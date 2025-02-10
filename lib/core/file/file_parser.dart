// lib/core/file_parser.dart
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:uuid/uuid.dart';
import '../../../models/models.dart';

class FileParser {
  static const supportedExtensions = ['csv', 'xlsx', 'xls'];

  Future<DataSource?> parse(
      BuildContext context,
      String fileName,
      Uint8List bytes,
      String extension,
      ) async {
    switch (extension.toLowerCase()) {
      case 'csv':
        return _parseCSV(context, fileName, bytes);
      case 'xlsx':
      case 'xls':
        return _parseExcel(context, fileName, bytes);
      default:
        throw Exception('不支持的文件格式：$extension');
    }
  }

  Future<DataSource?> _parseCSV(
      BuildContext context,
      String fileName,
      Uint8List bytes,
      ) async {
    try {
      String csvString;
      try {
        csvString = utf8.decode(bytes);
      } catch (e) {
        // 如果UTF-8解码失败，尝试使用GB18030
        csvString = const Utf8Decoder(allowMalformed: true).convert(bytes);
      }

      final rows = const CsvToListConverter().convert(csvString);
      if (rows.isEmpty) {
        throw Exception('CSV文件为空');
      }

      final headers = rows.first.map((h) => h.toString().trim()).toList();
      return _createDataSource(fileName, headers, rows.skip(1).toList());
    } catch (e) {
      print('CSV parsing error: $e');
      rethrow;
    }
  }

  Future<DataSource?> _parseExcel(
      BuildContext context,
      String fileName,
      Uint8List bytes,
      ) async {
    try {
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);
      if (decoder.tables.isEmpty) {
        throw Exception('Excel文件没有工作表');
      }

      final sheet = decoder.tables[decoder.tables.keys.first]!;
      if (sheet.rows.isEmpty) {
        throw Exception('工作表为空');
      }

      // 获取表头
      final headers = sheet.rows.first
          .map((cell) => cell?.toString().trim() ?? '')
          .where((header) => header.isNotEmpty)
          .toList();

      if (headers.isEmpty) {
        throw Exception('无法读取表头');
      }

      // 获取数据行
      final dataRows = sheet.rows.skip(1).map((row) {
        return row.map((cell) => cell).toList();
      }).toList();

      return _createDataSource(fileName, headers, dataRows);
    } catch (e) {
      print('Excel parsing error: $e');
      if (e is UnsupportedError) {
        throw Exception('Excel文件格式不兼容，请尝试另存为较新版本的Excel文件（.xlsx）');
      }
      rethrow;
    }
  }

  DataSource _createDataSource(
      String fileName,
      List<String> headers,
      List<List<dynamic>> rows,
      ) {
    final fields = headers.map((header) {
      final columnIndex = headers.indexOf(header);
      final columnValues = rows
          .map((row) => columnIndex < row.length ? row[columnIndex] : null)
          .where((value) => value != null)
          .toList();

      final canBeNumeric = columnValues.every((value) =>
      value is num ||
          (value is String && num.tryParse(value.toString()) != null));

      final canBeDate = columnValues.every((value) =>
      value is DateTime ||
          (value is String && DateTime.tryParse(value.toString()) != null));

      return Field(
        name: header,
        type: canBeNumeric ? 'number' : (canBeDate ? 'date' : 'string'),
        isNumeric: canBeNumeric,
        isDate: canBeDate,
      );
    }).toList();

    return DataSource(
      id: const Uuid().v4(),
      name: fileName,
      type: fileName.split('.').last.toLowerCase(),
      fields: fields,
      createdAt: DateTime.now(),
      records: rows.map((row) {
        final map = <String, dynamic>{};
        for (var i = 0; i < headers.length; i++) {
          if (i < row.length) {
            final value = row[i];
            // 确保数值类型正确处理
            if (value is num) {
              map[headers[i]] = value.toString();
            } else {
              map[headers[i]] = value?.toString() ?? '';
            }
          } else {
            map[headers[i]] = '';
          }
        }
        return map;
      }).toList(),
    );
  }
}