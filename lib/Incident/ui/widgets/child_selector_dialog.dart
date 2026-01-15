import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ChildSelectorDialog extends StatefulWidget {
  final List<Child> children;
  final Child? selectedChild;
  final Function(Child) onChildSelected;
  final String? Function(String?)? getRoomName;

  const ChildSelectorDialog({
    super.key,
    required this.children,
    this.selectedChild,
    required this.onChildSelected,
    this.getRoomName,
  });

  @override
  State<ChildSelectorDialog> createState() => _ChildSelectorDialogState();
}

class _ChildSelectorDialogState extends State<ChildSelectorDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Child> _filteredChildren = [];

  @override
  void initState() {
    super.initState();
    _filteredChildren = widget.children;
  }

  void _filterChildren(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChildren = widget.children;
      } else {
        final searchQuery = query.toLowerCase();
        _filteredChildren = widget.children.where((child) {
          final fullName = child.getFullName().toLowerCase();
          final firstName = child.firstName.toLowerCase();
          final paternalLastName = child.paternalLastName.toLowerCase();
          final maternalLastName = child.maternalLastName?.toLowerCase() ?? '';
          
          return fullName.contains(searchQuery) ||
                 firstName.contains(searchQuery) ||
                 paternalLastName.contains(searchQuery) ||
                 maternalLastName.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título
            Row(
              children: [
                Icon(
                  UiIcons.user_1,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Seleccionar Niño',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            
            // Campo de búsqueda
            TextField(
              controller: _searchController,
              decoration: FormInputDecoration(
                context: context,
                placeholder: 'Buscar por nombre...',
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                ),
              ),
              onChanged: _filterChildren,
            ),
            SizedBox(height: 20.h),
            
            // Lista de children
            Expanded(
              child: _filteredChildren.isEmpty
                  ? Center(
                      child: Text(
                        'No se encontraron niños',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredChildren.length,
                      itemBuilder: (context, index) {
                        final child = _filteredChildren[index];
                        final isSelected = widget.selectedChild?.id == child.id;
                        
                        return InkWell(
                          onTap: () {
                            widget.onChildSelected(child);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).dividerColor,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.r,
                                  backgroundColor: _getAvatarColor(child.id ?? ''),
                                  child: Text(
                                    child.getInitials(),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        child.getFullName(),
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (child.roomId != null && child.roomId!.isNotEmpty)
                                        Text(
                                          'Grupo: ${widget.getRoomName != null ? (widget.getRoomName!(child.roomId) ?? child.roomId) : child.roomId}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      if (child.birthDate != null)
                                        Text(
                                          'Nacimiento: ${_formatDate(child.birthDate!)}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).colorScheme.secondary,
                                    size: 24.sp,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(String childId) {
    final colors = [
      Color(0xFF3498DB), Color(0xFF2ECC71), Color(0xFFE74C3C),
      Color(0xFF9B59B6), Color(0xFFF39C12), Color(0xFF1ABC9C),
      Color(0xFFE67E22), Color(0xFFE74C3C), Color(0xFF95A5A6),
    ];
    if (childId.isEmpty) return colors[0];
    final hash = childId.hashCode;
    final index = hash.abs() % colors.length;
    return colors[index].withAlpha(255);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

