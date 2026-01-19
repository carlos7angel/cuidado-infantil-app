import 'package:cuidado_infantil/Child/controllers/child_form_controller.dart';
import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Child/models/enums.dart';
import 'package:cuidado_infantil/Child/models/family_member.dart';
import 'package:cuidado_infantil/Child/ui/widgets/family_member_dialog.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/form_field_shadow.dart';
import 'package:cuidado_infantil/Config/widgets/form_input_decoration.dart';
import 'package:cuidado_infantil/Config/widgets/label_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class ChildSocialTab extends StatefulWidget {
  final ChildFormController controller;

  const ChildSocialTab({
    super.key,
    required this.controller,
  });

  @override
  State<ChildSocialTab> createState() => _ChildSocialTabState();
}

class _ChildSocialTabState extends State<ChildSocialTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _openFamilyMemberDialog(BuildContext context,
      {FamilyMember? member, int? index}) {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (ctx) {
        return FamilyMemberDialog(
          member: member,
          onSave: (newMember) {
            if (index != null) {
              widget.controller.updateFamilyMember(index, newMember);
            } else {
              widget.controller.addFamilyMember(newMember);
            }
          },
        );
      },
    );
  }

  Widget _familyMemberTile(BuildContext context, FamilyMember member, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(
            width: 1, color: Theme.of(context).colorScheme.secondary.withOpacity(0.20)),
        borderRadius: BorderRadius.circular(10.r),
        color: Theme.of(context).focusColor.withOpacity(0.05),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 3.w, color: Theme.of(context).colorScheme.secondary)),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 22.w,
              child: Icon(
                UiIcons.users,
                size: 18.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${member.firstName} ${member.lastName}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Relación: ${member.relationship}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (member.hasIncome)
                  Text(
                    'Ingreso: ${member.incomeType} - ${member.incomeTotal}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => _openFamilyMemberDialog(context,
                    member: member, index: index),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent, size: 20),
                onPressed: () => widget.controller.removeFamilyMember(index),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          LabelForm(text: 'Infante a cargo de: *'),
          FormFieldShadow(
            child: FormBuilderDropdown(
              name: 'guardian_type',
              style: Theme.of(context).textTheme.bodySmall,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              decoration: FormInputDecoration(context: context),
              items: GuardianType.values.map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.label),
              )).toList(),
              onChanged: (val) => widget.controller.updateChildField('guardian_type', val),
            ),
          ),
          SizedBox(height: 20.h),
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
                'Integrantes de la Familia',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: ButtonTheme(
                padding: EdgeInsets.all(0),
                minWidth: 50.0,
                height: 25.0,
                child: TextButton(
                  onPressed: () => _openFamilyMemberDialog(context),
                  child: Text(
                    "+ Nuevo",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          GetBuilder(
            id: 'family_members',
            init: widget.controller,
            builder: (controllerState) {
              if (widget.controller.familyMembers.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.15)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'Sin familiares registrados',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              }
              return Column(
                children: List.generate(
                  widget.controller.familyMembers.length,
                  (index) => _familyMemberTile(context, widget.controller.familyMembers[index], index),
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
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
                'Situación de habitabilidad',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          LabelForm(text: 'Tipo de vivienda:'),
          FormBuilderRadioGroup(
            name: 'housing_type',
            orientation: OptionsOrientation.vertical,
            // validator: FormBuilderValidators.compose([
            //   FormBuilderValidators.required(),
            // ]),
            options: HousingType.values.map((e) => FormBuilderFieldOption(
              value: e.value,
              child: Text(e.label),
            )).toList(),
            decoration: InputDecoration(contentPadding: EdgeInsets.all(0), border: InputBorder.none)
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Tenencia de vivienda:'),
          FormFieldShadow(
            child: FormBuilderDropdown(
              name: 'housing_tenure',
              style: Theme.of(context).textTheme.bodySmall,
              // validator: FormBuilderValidators.compose([
              //   FormBuilderValidators.required(),
              // ]),
              onChanged: (val) => widget.controller.updateChildField('housing_tenure', val),
              decoration: FormInputDecoration(context: context),
              items: HousingTenure.values.map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.label),
              )).toList(),
            ),
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Estructura de la vivienda:'),
          FormFieldShadow(
            child: FormBuilderDropdown(
              name: 'housing_structure',
              style: Theme.of(context).textTheme.bodySmall,
              // validator: FormBuilderValidators.compose([
              //   FormBuilderValidators.required(),
              // ]),
              decoration: FormInputDecoration(context: context),
              items: HousingWallMaterial.values.map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.label),
              )).toList(),
            ),
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Tipo de piso:'),
          FormFieldShadow(
            child: FormBuilderDropdown(
              name: 'floor_type',
              style: Theme.of(context).textTheme.bodySmall,
              // validator: FormBuilderValidators.compose([
              //   FormBuilderValidators.required(),
              // ]),
              decoration: FormInputDecoration(context: context),
              items: HousingFloorMaterial.values.map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.label),
              )).toList(),
            ),
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Acabado de la vivienda:'),
          FormFieldShadow(
            child: FormBuilderDropdown(
              name: 'finishing_type',
              style: Theme.of(context).textTheme.bodySmall,
              // validator: FormBuilderValidators.compose([
              //   FormBuilderValidators.required(),
              // ]),
              decoration: FormInputDecoration(context: context),
              items: HousingFinish.values.map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.label),
              )).toList(),
            ),
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Número de dormitorios:'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'bedrooms',
              style: Theme.of(context).textTheme.bodySmall,
              keyboardType: TextInputType.number,
              // validator: FormBuilderValidators.compose([
              //   FormBuilderValidators.required(),
              //   FormBuilderValidators.numeric(),
              // ]),
              decoration: FormInputDecoration(context: context),
            ),
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Habitaciones:'),
          FormBuilderCheckboxGroup(
            name: 'rooms',
            orientation: OptionsOrientation.vertical,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
            ),
            options: const [
              FormBuilderFieldOption(value: 'dormitorio', child: Text('Dormitorio(s)')),
              FormBuilderFieldOption(value: 'sala', child: Text('Sala')),
              FormBuilderFieldOption(value: 'cocina', child: Text('Cocina')),
              FormBuilderFieldOption(value: 'comedor', child: Text('Comedor')),
              FormBuilderFieldOption(value: 'bano', child: Text('Baño')),
            ],
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Servicios básicos:'),
          FormBuilderCheckboxGroup(
            name: 'basic_services',
            orientation: OptionsOrientation.vertical,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
            ),
            options: HousingUtility.values.map((e) => FormBuilderFieldOption(
              value: e.value,
              child: Text(e.label),
            )).toList(),
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Medio de transporte al CCI:'),
          FormFieldShadow(
            child: FormBuilderDropdown(
              name: 'transport_type',
              style: Theme.of(context).textTheme.bodySmall,
              // validator: FormBuilderValidators.compose([
              //   FormBuilderValidators.required(),
              // ]),
              decoration: FormInputDecoration(context: context),
              items: TransportType.values.map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.label),
              )).toList(),
            ),
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Tiempo de demora en llegar al CCI:'),
          FormFieldShadow(
            child: FormBuilderDropdown(
              name: 'travel_time',
              style: Theme.of(context).textTheme.bodySmall,
              // validator: FormBuilderValidators.compose([
              //   FormBuilderValidators.required(),
              // ]),
              decoration: FormInputDecoration(context: context),
              items: TravelTime.values.map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.label),
              )).toList(),
            ),
          ),


          SizedBox(height: 20.h),
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
                'Otros aspectos sociales',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          SizedBox(height: 20.h), 
          LabelForm(text: 'Antecedentes de incidentes'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'incident_history',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(600, checkNullOrEmpty: false),
              ]),
              decoration: FormInputDecoration(context: context),
              onChanged: (val) => widget.controller.updateChildField('incident_history', val),
            ),
          ),

          SizedBox(height: 20.h),
          LabelForm(text: 'Tenencia de mascotas'),
          FormFieldShadow(
            child: FormBuilderTextField(
              name: 'pets',
              style: Theme.of(context).textTheme.bodySmall,
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(600, checkNullOrEmpty: false),
              ]),
              decoration: FormInputDecoration(context: context),
              onChanged: (val) => widget.controller.updateChildField('pets', val),
            ),
          ),

          

          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}

