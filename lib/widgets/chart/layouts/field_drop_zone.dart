// lib/widgets/chart/field_drop_zone.dart
import 'package:flutter/material.dart';
import '../../../models/models.dart';
import 'dart:io';


class FieldDropZone extends StatelessWidget {
  final String title;
  final List<Field> fields;
  final Function(Field) onAccept;
  final Function(Field) onRemove;
  final Function(int oldIndex, int newIndex)? onReorder;

  const FieldDropZone({
    super.key,
    required this.title,
    required this.fields,
    required this.onAccept,
    required this.onRemove,
    this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    return DragTarget<Field>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHovering ? Colors.grey.shade100 : Colors.white,
            border: Border.all(
              color: isHovering ? Theme
                  .of(context)
                  .primaryColor : Colors.grey.shade300,
              width: isHovering ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: isAndroid ? 8 : 12,
                    vertical: isAndroid ? 6 : 8
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(7)),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: isAndroid ? 12 : 14
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${fields.length}个字段',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: isAndroid ? 10 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: fields.isEmpty
                    ? _buildEmptyHint(isAndroid)
                    : _buildFieldList(isAndroid),
              ),
            ],
          ),
        );
      },
      onWillAccept: (field) => field != null,
      onAccept: onAccept,
    );
  }

  Widget _buildEmptyHint(bool isAndroid) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.drag_indicator,
            size: isAndroid ? 24 : 32,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: isAndroid ? 6 : 8),
          Text(
            '拖拽字段到这里',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: isAndroid ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldList(bool isAndroid) {
    return ReorderableListView.builder(
      padding: EdgeInsets.all(isAndroid ? 4 : 8),
      itemCount: fields.length,
      onReorder: onReorder ?? (_, __) {},
      itemBuilder: (context, index) {
        final field = fields[index];
        return _FieldCard(
          key: ValueKey(field.name),
          field: field,
          onRemove: () => onRemove(field),
          isAndroid: isAndroid,
        );
      },
    );
  }
}

class _FieldCard extends StatelessWidget {
  final Field field;
  final VoidCallback onRemove;
  final bool isAndroid;

  const _FieldCard({
    super.key,
    required this.field,
    required this.onRemove,
    required this.isAndroid,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<Field>(
      data: field,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: isAndroid ? 8 : 12,
              vertical: isAndroid ? 6 : 8
          ),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.drag_indicator,
                size: isAndroid ? 14 : 16,
                color: Colors.white,
              ),
              SizedBox(width: isAndroid ? 4 : 6),
              Text(
                field.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: isAndroid ? 12 : 14
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isAndroid ? 120 : 150,  // 限制卡片最大宽度
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isAndroid ? 6 : 8,
                vertical: isAndroid ? 4 : 6
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.drag_indicator,
                  size: isAndroid ? 16 : 18,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: isAndroid ? 4 : 6),
                Flexible(
                  child: Text(
                    field.name,
                    style: TextStyle(
                      fontSize: isAndroid ? 12 : 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: isAndroid ? 4 : 6),
                InkWell(
                  onTap: onRemove,
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: isAndroid ? 16 : 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}