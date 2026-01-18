import 'dart:io';

import 'package:cuidado_infantil/Child/controllers/child_form_controller.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/cached_image.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChildIdentificationTab extends StatefulWidget {
  final ChildFormController controller;

  const ChildIdentificationTab({
    super.key,
    required this.controller,
  });

  @override
  State<ChildIdentificationTab> createState() => _ChildIdentificationTabState();
}

class _ChildIdentificationTabState extends State<ChildIdentificationTab> with AutomaticKeepAliveClientMixin {
  File? _avatarFile;

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _avatarFile = file;
      });
      widget.controller.updateChildField('avatar', file);
    }
  }

  void _showAvatarSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera, color: Theme.of(context).primaryColor),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAvatar(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Theme.of(context).primaryColor),
                title: const Text('Elegir de la galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAvatar(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarHeader(BuildContext context) {
    final child = widget.controller.currentChild;

    Widget avatarImage;

    if (_avatarFile != null) {
      avatarImage = ClipRRect(
        borderRadius: BorderRadius.circular(80.r),
        child: Image.file(
          _avatarFile!,
          fit: BoxFit.cover,
        ),
      );
    } else if (child != null) {
      avatarImage = CachedImage(
        image: child.getAvatarImage(),
        isRound: true,
        radius: 80.r,
        color: Colors.transparent,
      );
    } else {
      avatarImage = CachedImage(
        image: 'assets/images/anonymous_user.png',
        isRound: true,
        radius: 80.r,
        color: Colors.transparent,
      );
    }

    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100.r,
                height: 100.r,
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: child != null
                      ? child.getAvatarColor()
                      : Colors.grey.withOpacity(0.2),
                ),
                child: avatarImage,
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: InkWell(
                  onTap: _showAvatarSourcePicker,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(
        children: [
          _buildAvatarHeader(context),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              visualDensity: VisualDensity.compact,
              leading: Icon(
                UiIcons.inbox,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
              title: Text(
                'Datos de identificación del infante',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Apellido Paterno: *'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'paternal_last_name',
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(150),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('paternal_last_name', val),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Apellido Materno:'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'maternal_last_name',
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(150),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                          // icon: Icon(
                          //   UiIcons.idCard,
                          //   color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                          // ),
                        ),
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('maternal_last_name', val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Nombre(s): *'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'first_name',
              style: Theme.of(context).textTheme.bodySmall,
              keyboardType: TextInputType.name,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(150),
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.idCard,
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                ),
              ),
              // initialValue: _.denunciationData.fullName,
              onChanged: (val) => widget.controller.updateChildField('first_name', val),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Género: *'),
          FormBuilderRadioGroup<String>(
            name: 'gender',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            orientation: OptionsOrientation.horizontal,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            options: const [
              FormBuilderFieldOption(value: 'masculino', child: Text('Hombre')),
              FormBuilderFieldOption(value: 'femenino', child: Text('Mujer')),
            ],
            onChanged: (val) => widget.controller.updateChildField('gender', val),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Fecha de nacimiento: *'),
          FormFieldShadow(
            child: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Theme.of(context).colorScheme.secondary,
              ),
              child: FormBuilderDateTimePicker(
                name: 'birth_date',
                inputType: InputType.date,
                // firstDate: DateTime.now().subtract(Duration(days: 365 * 30)),
                lastDate: DateTime.now(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                format: DateFormat('dd/MM/yyyy'),
                style: Theme.of(context).textTheme.bodySmall,
                cancelText: 'Cancelar',
                confirmText: 'Aceptar',
                decoration: FormInputDecoration(
                  context: context,
                  // placeholder: 'dd/mm/aaaa',
                  icon: Icon(
                    UiIcons.calendar,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onChanged: (val) => widget.controller.updateChildField('birth_date', val),
                // initialValue: _.denunciationData.dateEvent != null ? _.denunciationData.dateEvent : null,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Dirección: *'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'address',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(600)
              ]),
              decoration: FormInputDecoration(
                context: context,
                icon: Icon(
                  UiIcons.map,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (val) => widget.controller.updateChildField('address', val),
              // initialValue: _.denunciationData.details,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Departamento: *'),
                    FormFieldShadow(
                      child: FormBuilderDropdown(
                        name: 'state',
                        style: Theme.of(context).textTheme.bodySmall,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'La Paz', child: Text('La Paz')),
                          DropdownMenuItem(value: 'Cochabamba', child: Text('Cochabamba')),
                          DropdownMenuItem(value: 'Santa Cruz', child: Text('Santa Cruz')),
                          DropdownMenuItem(value: 'Oruro', child: Text('Oruro')),
                          DropdownMenuItem(value: 'Potosí', child: Text('Potosí')),
                          DropdownMenuItem(value: 'Chuquisaca', child: Text('Chuquisaca')),
                          DropdownMenuItem(value: 'Tarija', child: Text('Tarija')),
                          DropdownMenuItem(value: 'Beni', child: Text('Beni')),
                          DropdownMenuItem(value: 'Pando', child: Text('Pando')),
                        ],
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('state', val),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelForm(text: 'Ciudad: *'),
                    FormFieldShadow(
                      child: FormBuilderTextField(
                        name: 'city',
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(150),
                        ]),
                        decoration: FormInputDecoration(
                          context: context,
                        ),
                        // initialValue: _.denunciationData.fullName,
                        onChanged: (val) => widget.controller.updateChildField('city', val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}

