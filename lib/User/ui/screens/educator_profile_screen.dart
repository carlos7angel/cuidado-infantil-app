import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Intro/ui/screens/home_screen.dart';
import 'package:cuidado_infantil/User/controllers/educator_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EducatorProfileScreen extends StatefulWidget {
  static final String routeName = '/educator_profile';
  const EducatorProfileScreen({super.key});

  @override
  State<EducatorProfileScreen> createState() => _EducatorProfileScreenState();
}

class _EducatorProfileScreenState extends State<EducatorProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    EducatorProfileController educatorProfileController = Get.put(EducatorProfileController());
    educatorProfileController.fbKey = GlobalKey<FormBuilderState>();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offAllNamed(HomeScreen.routeName);
        }
      },
      child: GetBuilder<EducatorProfileController>(
        builder: (controller) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
                onPressed: () {
                  Get.offAllNamed(HomeScreen.routeName);
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: GradientText(
                config.PRIMARY_GRADIENT,
                "Preferencias",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () async {
                    await controller.saveProfile();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15.w),
                    child: Chip(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (controller.isLoading)
                            SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          else
                            Text('Guardar', style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Colors.white))),
                        ],
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
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
                        'Datos del perfil de usuario',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  FormBuilder(
                    key: controller.fbKey,
                    initialValue: {
                      'first_name': controller.user?.educator?.firstName ?? '',
                      'last_name': controller.user?.educator?.lastName ?? '',
                      'birthdate': controller.user?.educator?.birthdate,
                      'gender': controller.user?.educator?.gender,
                      'state': controller.user?.educator?.state,
                      'dni': controller.user?.educator?.dni ?? '',
                      'phone': controller.user?.educator?.phone ?? '',
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h,),
                          // Campo oculto para género (manejado por los botones)
                          FormBuilderTextField(
                            name: 'gender',
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            style: TextStyle(fontSize: 0, height: 0),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Nombre(s): *',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          FormBuilderTextField(
                            name: 'first_name',
                            keyboardType: TextInputType.text,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.maxLength(50),
                            ]),
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Ingrese su nombre',
                              hintStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                              errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(fontSize: 10, color: Colors.redAccent)),
                              prefixIcon: Icon(UiIcons.user_1, color: Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.only(top: 16.0, bottom: 12.0),
                            ),
                            initialValue: controller.user?.educator?.firstName,
                          ),
                          SizedBox(height: 25.h,),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Apellido(s): *',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          FormBuilderTextField(
                            name: 'last_name',
                            keyboardType: TextInputType.text,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.maxLength(50),
                            ]),
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Ingrese su apellido',
                              hintStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                              errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(fontSize: 10, color: Colors.redAccent)),
                              prefixIcon: Icon(UiIcons.user_1, color: Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.only(top: 16.0, bottom: 12.0),
                            ),
                            initialValue: controller.user?.educator?.lastName,
                          ),
                          SizedBox(height: 25.h,),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Fecha de nacimiento:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          FormBuilderDateTimePicker(
                              name: 'birthdate',
                              inputType: InputType.date,
                              firstDate: DateTime.now().subtract(Duration(days: 36500)),
                              lastDate: DateTime.now(),
                              validator: FormBuilderValidators.compose([]),
                              initialDatePickerMode: DatePickerMode.year,
                              format: DateFormat('dd/MM/yyyy'),
                              style: Theme.of(context).textTheme.bodyMedium,
                              cancelText: 'Salir',
                              confirmText: 'Aceptar',
                              decoration: InputDecoration(
                                hintText: 'Ingrese su fecha de nacimiento',
                                hintStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                                errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(fontSize: 10, color: Colors.redAccent)),
                                prefixIcon: Icon(UiIcons.calendar, color: Theme.of(context).colorScheme.secondary),
                                contentPadding: EdgeInsets.only(top: 16.0, bottom: 12.0),
                              ),
                              initialValue: controller.user?.educator?.birthdate,
                          ),
                          SizedBox(height: 25.h,),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Género:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => controller.setGenderValue('masculino'),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 8.h),
                                      shape: RoundedRectangleBorder(side: BorderSide(
                                        color: controller.getGenderValue() == 'masculino' ? Colors.transparent : Colors.lightBlueAccent,
                                        width: 1,
                                        style: BorderStyle.solid
                                      ), borderRadius: BorderRadius.circular(50)),
                                      backgroundColor: controller.getGenderValue() == 'masculino' ? Colors.lightBlueAccent : Colors.transparent,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          UiIcons.user_1,
                                          color: controller.getGenderValue() == 'masculino' ? Colors.white : Colors.lightBlueAccent,
                                        ),
                                        SizedBox(width: 5.w,),
                                        Text(
                                          'Hombre',
                                          style: Theme.of(context).textTheme.titleSmall?.merge(
                                            TextStyle(
                                              color: controller.getGenderValue() == 'masculino' ? Colors.white : Colors.lightBlueAccent,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => controller.setGenderValue('femenino'),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 8.h),
                                      shape: RoundedRectangleBorder(side: BorderSide(
                                        color: controller.getGenderValue() == 'femenino' ? Colors.transparent : Colors.pinkAccent,
                                        width: 1,
                                        style: BorderStyle.solid
                                      ), borderRadius: BorderRadius.circular(50)),
                                      backgroundColor: controller.getGenderValue() == 'femenino' ? Colors.pinkAccent : Colors.transparent,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          UiIcons.user_2,
                                          color: controller.getGenderValue() == 'femenino' ? Colors.white : Colors.pinkAccent,
                                        ),
                                        SizedBox(width: 5.w,),
                                        Text(
                                          'Mujer',
                                          style: Theme.of(context).textTheme.titleSmall?.merge(
                                            TextStyle(
                                              color: controller.getGenderValue() == 'femenino' ? Colors.white : Colors.pinkAccent,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25.h,),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Departamento:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          FormBuilderDropdown(
                            name: "state",
                            icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.secondary),
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Seleccione su departamento',
                              hintStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                              errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(fontSize: 10, color: Colors.redAccent)),
                              prefixIcon: Icon(UiIcons.users, color: Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.only(top: 16.0, bottom: 12.0),
                            ),
                            items: [
                              DropdownMenuItem(value: 'La Paz', child: Text('La Paz')),
                              DropdownMenuItem(value: 'Oruro', child: Text('Oruro')),
                              DropdownMenuItem(value: 'Potosí', child: Text('Potosí')),
                              DropdownMenuItem(value: 'Cochabamba', child: Text('Cochabamba')),
                              DropdownMenuItem(value: 'Chuquisaca', child: Text('Chuquisaca')),
                              DropdownMenuItem(value: 'Tarija', child: Text('Tarija')),
                              DropdownMenuItem(value: 'Santa Cruz', child: Text('Santa Cruz')),
                              DropdownMenuItem(value: 'Beni', child: Text('Beni')),
                              DropdownMenuItem(value: 'Pando', child: Text('Pando')),
                            ],
                            initialValue: controller.user?.educator?.state,
                          ),
                          SizedBox(height: 25.h,),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'DNI:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          FormBuilderTextField(
                            name: 'dni',
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.maxLength(20),
                            ]),
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Ingrese su DNI',
                              hintStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                              errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(fontSize: 10, color: Colors.redAccent)),
                              prefixIcon: Icon(UiIcons.user_1, color: Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.only(top: 16.0, bottom: 12.0),
                            ),
                            initialValue: controller.user?.educator?.dni,
                          ),
                          SizedBox(height: 25.h,),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Teléfono:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          FormBuilderTextField(
                            name: 'phone',
                            keyboardType: TextInputType.phone,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.maxLength(20),
                            ]),
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Ingrese su teléfono',
                              hintStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                              errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(fontSize: 10, color: Colors.redAccent)),
                              prefixIcon: Icon(UiIcons.phoneCall, color: Theme.of(context).colorScheme.secondary),
                              contentPadding: EdgeInsets.only(top: 16.0, bottom: 12.0),
                            ),
                            initialValue: controller.user?.educator?.phone,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          );
        }
      ),
    );
  }
}
