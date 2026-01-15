import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/User/controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  static final String routeName = '/change_password';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showPassword = false;

  @override
  void initState() {
    ChangePasswordController changePasswordController = Get.put(ChangePasswordController());
    changePasswordController.fbKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      init: ChangePasswordController(),
      id: 'form_change_password',
      builder: (controller) {
        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(UiIcons.returnIcon, color: Theme.of(context).hintColor),
                onPressed: () => Get.back(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: GradientText(
                config.PRIMARY_GRADIENT,
                "Seguridad",
                size: 20.sp,
                weight: FontWeight.w600,
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () { controller.submit(); },
                  child: Container(
                    margin: EdgeInsets.only(right: 15.w),
                    child: Chip(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                        UiIcons.key,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 24,
                      ),
                      title: Text(
                        'Actualizar contraseña',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  FormBuilder(
                    key: controller.fbKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h,),
                          SizedBox(height: 0.h,),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Nueva contraseña: *',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          FormBuilderTextField(
                            name: 'new_password',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !_showPassword,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              // FormBuilderValidators.password(),
                            ]),
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu nueva contraseña',
                              hintStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                              errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(fontSize: 10, color: Colors.redAccent)),
                              prefixIcon: Icon(UiIcons.padlock_1, color: Theme.of(context).colorScheme.secondary),
                              errorMaxLines: 2,
                              suffixIcon: IconButton(
                                onPressed: () => setState(() { _showPassword = !_showPassword; }),
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                                icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                              ),
                              contentPadding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                            ),
                            initialValue: controller.newPassword,
                            onChanged: (value) => controller.setNewPasswordValue(value ?? ''),
                          ),
                          SizedBox(height: 25.h,),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Confirmar contraseña: *',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          FormBuilderTextField(
                            name: 'confirm_password',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !_showPassword,
                            validator: (val) {
                              if (controller.fbKey.currentState?.fields['new_password']?.value != val) {
                                return 'La contraseña debe ser la misma';
                              }
                              return null;
                            },
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Confirmar tu nueva contraseña',
                             hintStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                              errorStyle: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(fontSize: 10, color: Colors.redAccent)),
                              errorMaxLines: 2,
                              prefixIcon: Icon(UiIcons.padlock_1, color: Theme.of(context).colorScheme.secondary),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() { _showPassword = !_showPassword; }),
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                                icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                              ),
                              contentPadding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                            ),
                            onChanged: (value) => controller.setConfirmPasswordValue(value ?? ''),
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
    );
  }
}