import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectAttendanceDialog extends StatelessWidget {
  final Function(String status) onStatusSelected;
  
  const SelectAttendanceDialog({
    super.key,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      contentPadding: EdgeInsets.only(bottom: 30.h, top: 30.h, left: 30.w, right: 30.w),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Container(
                          width: 120.w,
                          height: 120.w,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onStatusSelected('presente');
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check, size: 50.sp, color: Theme.of(context).primaryColor),
                                  // Text(
                                  //   'P',
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //     fontSize: 42.sp,
                                  //     fontWeight: FontWeight.w900,
                                  //     color: Theme.of(context).primaryColor,
                                  //   ),
                                  // ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Presente',
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                                        TextStyle(
                                            fontSize: 14,
                                            color: Colors.white
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Container(
                          width: 120.w,
                          height: 120.w,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onStatusSelected('falta');
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(15.r)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   'F',
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //     fontSize: 42.sp,
                                  //     fontWeight: FontWeight.w900,
                                  //     color: Theme.of(context).primaryColor,
                                  //   ),
                                  // ),
                                  Icon(Icons.close, size: 50.sp, color: Theme.of(context).primaryColor),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Falta',
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                                        TextStyle(
                                            fontSize: 14,
                                            color: Colors.white
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Container(
                          width: 120.w,
                          height: 120.w,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onStatusSelected('retraso');
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(Radius.circular(15.r)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   'A',
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //     fontSize: 42.sp,
                                  //     fontWeight: FontWeight.w900,
                                  //     color: Theme.of(context).primaryColor,
                                  //   ),
                                  // ),
                                  Icon(Icons.access_time, size: 50.sp, color: Theme.of(context).primaryColor),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Atraso',
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                                        TextStyle(
                                            fontSize: 14,
                                            color: Colors.white
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Container(
                          width: 120.w,
                          height: 120.w,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onStatusSelected('justificado');
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.all(Radius.circular(15.r)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   'J',
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //     fontSize: 42.sp,
                                  //     fontWeight: FontWeight.w900,
                                  //     color: Theme.of(context).primaryColor,
                                  //   ),
                                  // ),
                                  Icon(Icons.flag_outlined, size: 50.sp, color: Theme.of(context).primaryColor),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Justificado',
                                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                                        TextStyle(
                                            fontSize: 14,
                                            color: Colors.white
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
