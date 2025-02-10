// lib/widgets/chart/field_drop_zone.dart
import 'package:flutter/material.dart';
import '../../../models/models.dart';

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
    return DragTarget<Field>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHovering ? Colors.grey.shade100 : Colors.white,
            border: Border.all(
              color: isHovering ? Theme.of(context).primaryColor : Colors.grey.shade300,
              width: isHovering ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      '${fields.length}个字段',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: fields.isEmpty
                    ? _buildEmptyHint()
                    : _buildFieldList(),
              ),
            ],
          ),
        );
      },
      onWillAccept: (field) => field != null,
      onAccept: onAccept,
    );
  }

  Widget _buildEmptyHint() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.drag_indicator,
            size: 32,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            '拖拽字段到这里',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: fields.length,
      onReorder: onReorder ?? (_, __) {},
      itemBuilder: (context, index) {
        final field = fields[index];
        return _FieldCard(
          key: ValueKey(field.name),
          field: field,
          onRemove: () => onRemove(field),
        );
      },
    );
  }
}

class _FieldCard extends StatelessWidget {
  final Field field;
  final VoidCallback onRemove;

  const _FieldCard({
    super.key,
    required this.field,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<Field>(
      data: field,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.drag_indicator,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                field.name,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          dense: true,
          leading: const Icon(Icons.drag_indicator, size: 20),
          title: Text(field.name),
          trailing: IconButton(
            icon: const Icon(Icons.remove, size: 20),
            onPressed: onRemove,
            tooltip: '移除字段',
          ),
        ),
      ),
    );
  }
}