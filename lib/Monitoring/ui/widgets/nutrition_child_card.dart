import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/cached_image.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NutritionChildCard extends StatelessWidget {
  final Child child;

  const NutritionChildCard({
    super.key,
    required this.child,
  });

  // Color según género: rosado para mujer, azul para hombre
  Color _getGenderColor(String gender) {
    switch (gender.toLowerCase()) {
      case 'femenino':
        return Colors.pinkAccent;
      case 'masculino':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final childcareCenter = StorageService.instance.getChildcareCenter();
    final fullName = child.getFullName();
    final birthDateFormatted = child.birthDate != null 
        ? DateFormat('dd/MM/yyyy').format(child.birthDate!)
        : 'No especificada';
    final centerName = childcareCenter?.name ?? 'Centro de Cuidado';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).hintColor.withOpacity(0.15),
            offset: Offset(0, 3),
            blurRadius: 10
          )
        ],
      ),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CachedImage(
              image: child.getAvatarImage(),
              isRound: true,
              radius: 90.r,
              color: _getGenderColor(child.gender).withOpacity(0.75),
              fit: BoxFit.cover,
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 5.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(UiIcons.calendar, size: 16.sp,),
                      SizedBox(width: 5.w,),
                      Text("Fecha Nac.: ", style: Theme.of(context).textTheme.bodyMedium),
                      Expanded(
                        child: Text(
                          birthDateFormatted,
                          style: Theme.of(context).textTheme.bodySmall?.merge(
                            TextStyle(fontWeight: FontWeight.w300)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(UiIcons.users, size: 16.sp,),
                      SizedBox(width: 5.w,),
                      Text("Género: ", style: Theme.of(context).textTheme.bodyMedium),
                      Expanded(
                        child: Text(
                          child.getGenderReadable(),
                          style: Theme.of(context).textTheme.bodySmall?.merge(
                            TextStyle(fontWeight: FontWeight.w300)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(UiIcons.home, size: 16.sp,),
                      SizedBox(width: 5.w,),
                      Text('Centro: ', style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          centerName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodySmall?.merge(
                            TextStyle(fontWeight: FontWeight.w300)
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

