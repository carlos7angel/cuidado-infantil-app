import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardChild extends StatelessWidget {
  final Child? child;

  const CardChild({super.key, this.child});


  String _formatDate(DateTime? date) {
    if (date == null) return 'No especificada';
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }



  IconData _getGenderIcon(String? gender) {
    if (gender == null || gender.isEmpty) return UiIcons.user_1;
    final genderLower = gender.toLowerCase();
    if (genderLower == 'masculino') {
      return UiIcons.user_1;
    } else if (genderLower == 'femenino') {
      return UiIcons.user_2;
    }
    return UiIcons.users;
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el child desde storage si no se pasó como parámetro
    final selectedChild = child ?? StorageService.instance.getSelectedChild();

    // Si no hay child, mostrar un mensaje o widget vacío
    if (selectedChild == null) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Center(
          child: Text(
            'No hay infante seleccionado',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final fullName = selectedChild.getFullName();
    final birthDateFormatted = _formatDate(selectedChild.birthDate);
    final genderFormatted = selectedChild.getGenderReadable();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
        ],
      ),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 80.r,
              height: 80.r,
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedChild.getAvatarColor().withOpacity(0.75),
              ),
              child: CachedImage(
                image: selectedChild.getAvatarImage(),
                isRound: true,
                radius: 80.r,
                color: Colors.transparent,
              )
            ),
            SizedBox(width: 15.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    fullName.isNotEmpty ? fullName : 'Sin nombre',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        UiIcons.lineChart,
                        color: Theme.of(context).primaryColor,
                        size: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          selectedChild.getAge(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium?.merge(
                              TextStyle(fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9))
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        UiIcons.calendar,
                        color: Theme.of(context).primaryColor,
                        size: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          birthDateFormatted,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium?.merge(
                              TextStyle(fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9))
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        _getGenderIcon(selectedChild.gender),
                        color: Theme.of(context).primaryColor,
                        size: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          genderFormatted,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium?.merge(
                              TextStyle(fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9))
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
