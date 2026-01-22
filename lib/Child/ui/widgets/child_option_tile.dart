import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChildOptionTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final String? description;
  final Function onTap;

  const ChildOptionTile({super.key, required this.icon, required this.title, this.description, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(2.0, 4.0), blurRadius: 8)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -60.w,
                top: -60.h,
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        // config.AppColors.mainColor(1),
                        // config.AppColors.mainColor(0.9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                    ),
                    borderRadius: BorderRadius.circular(120.r),
                    //borderRadius: BorderRadius.all(Radius.circular(100))
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.h, left: 10.w),
                      width: 30.w,
                      // child: Text(
                      //   index.toString().length == 1 ? '0'+index.toString() : index.toString(),
                      //   style: TextStyle(fontSize: 22.sp, letterSpacing: -2, height: 1, color: Colors.white.withOpacity(0.85)),
                      //   textAlign: TextAlign.start,
                      // ),
                      child: Icon(icon, size: 24.sp, color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          overlayColor: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.zero)),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.h),
                          // visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () => onTap(),
                        child: ListTile(
                          dense: true,
                          title: Row(
                            children: <Widget>[
                              Container(
                                child: Expanded(
                                  child: Text(
                                    title,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    maxLines: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // subtitle: Text("Seguridad en caso de salidas", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11.sp),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

