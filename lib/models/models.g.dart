// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataSourceAdapter extends TypeAdapter<DataSource> {
  @override
  final int typeId = 0;

  @override
  DataSource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataSource(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      fields: (fields[3] as List).cast<Field>(),
      createdAt: fields[4] as DateTime,
      records: (fields[5] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, DataSource obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.fields)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.records);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FieldAdapter extends TypeAdapter<Field> {
  @override
  final int typeId = 1;

  @override
  Field read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Field(
      name: fields[0] as String,
      type: fields[1] as String,
      isNumeric: fields[2] as bool,
      isDate: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Field obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.isNumeric)
      ..writeByte(3)
      ..write(obj.isDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DashboardAdapter extends TypeAdapter<Dashboard> {
  @override
  final int typeId = 2;

  @override
  Dashboard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dashboard(
      id: fields[0] as String,
      name: fields[1] as String,
      charts: (fields[2] as List).cast<ChartWidget>(),
      layout: (fields[3] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Dashboard obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.charts)
      ..writeByte(3)
      ..write(obj.layout);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChartWidgetAdapter extends TypeAdapter<ChartWidget> {
  @override
  final int typeId = 3;

  @override
  ChartWidget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartWidget(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      dimensions: (fields[3] as List).cast<Field>(),
      measures: (fields[4] as List).cast<Field>(),
      settings: (fields[5] as Map).cast<String, dynamic>(),
      dataSource: fields[6] as DataSource,
    );
  }

  @override
  void write(BinaryWriter writer, ChartWidget obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.dimensions)
      ..writeByte(4)
      ..write(obj.measures)
      ..writeByte(5)
      ..write(obj.settings)
      ..writeByte(6)
      ..write(obj.dataSource);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartWidgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
