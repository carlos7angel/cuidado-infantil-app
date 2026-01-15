import 'package:cuidado_infantil/Incident/models/incident_child.dart';
import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class IncidentChildDetailsCard extends StatelessWidget {
  final IncidentChild child;

  const IncidentChildDetailsCard({
    super.key,
    required this.child,
  });

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'No especificada';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }


  @override
  Widget build(BuildContext context) {
    final fullName = child.fullName ?? 
        '${child.firstName ?? ''} ${child.paternalLastName ?? ''} ${child.maternalLastName ?? ''}'.trim();
    final birthDateFormatted = _formatDate(child.birthDate);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            visualDensity: VisualDensity.compact,
            leading: Icon(UiIcons.idCard, color: Theme.of(context).colorScheme.secondary),
            title: Text(
              'Datos del Infante',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          SizedBox(height: 0.h,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Nombre',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    fullName.isNotEmpty ? fullName : 'N/A',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.h,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Fecha Nacimiento',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    birthDateFormatted,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.h,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Género',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    Child.formatGender(child.gender),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.h,)
        ],
      ),
    );
  }
}

