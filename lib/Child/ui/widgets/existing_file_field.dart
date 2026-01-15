import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';

/// Widget que muestra archivos existentes del backend y permite reemplazarlos
class ExistingFileField extends StatelessWidget {
  final String name;
  final String label;
  final List<dynamic>? existingFiles; // Archivos del backend (objetos Map)
  final Function(dynamic)? onChanged;
  final int maxFiles;
  final List<String> allowedExtensions;

  const ExistingFileField({
    super.key,
    required this.name,
    required this.label,
    this.existingFiles,
    this.onChanged,
    this.maxFiles = 1,
    this.allowedExtensions = const ['pdf'],
  });

  /// Extrae información del archivo del backend
  Map<String, dynamic>? _getFileInfo(dynamic file) {
    if (file is Map) {
      return {
        'name': file['original_name'] ?? file['name'] ?? 'Archivo',
        'size': file['human_readable_size'] ?? file['size']?.toString() ?? '',
        'url': file['url'],
        'id': file['id'],
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final fileInfo = existingFiles != null && existingFiles!.isNotEmpty
        ? _getFileInfo(existingFiles!.first)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fileInfo != null) ...[
          // Mostrar archivo existente
          Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.description,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileInfo['name'] ?? 'Archivo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (fileInfo['size'] != null && fileInfo['size'].toString().isNotEmpty)
                        Text(
                          fileInfo['size'].toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                    ],
                  ),
                ),
                // if (fileInfo['url'] != null)
                //   Tooltip(
                //     message: 'Archivo disponible en el servidor',
                //     child: Icon(
                //       Icons.check_circle,
                //       color: Colors.green,
                //       size: 20.sp,
                //     ),
                //   ),
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(bottom: 8.h),
          //   child: Text(
          //     'Reemplazar archivo:',
          //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //       color: Theme.of(context).hintColor,
          //     ),
          //   ),
          // ),
        ],
        // Widget para seleccionar nuevo archivo
        FormFieldShadow(
          child: FormBuilderFilePicker(
            name: name,
            maxFiles: maxFiles,
            allowedExtensions: allowedExtensions,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
            ),
            previewImages: false,
            typeSelectors: [
              TypeSelector(
                type: FileType.custom,
                selector: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 25.w),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        fileInfo != null ? Icons.refresh : Icons.file_upload,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 5),
                      Text(fileInfo != null ? 'Reemplazar PDF' : 'Cargar PDF'),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

