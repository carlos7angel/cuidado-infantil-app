import 'package:cuidado_infantil/Config/controllers/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:cuidado_infantil/User/ui/screens/preferences_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderProfile extends StatelessWidget {

  const HeaderProfile({super.key});

  String _getAvatarImage(String? gender) {
    String avatarImage = 'assets/images/blank.png';
    
    if (gender == null || gender.isEmpty) {
      return avatarImage;
    }
    
    final genderLower = gender.toLowerCase();
    
    if (genderLower == 'masculino') {
      avatarImage = 'assets/images/user_man.png';
    }
    
    if (genderLower == 'femenino') {
      avatarImage = 'assets/images/user_woman.png';
    }
    
    return avatarImage;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(
        builder: (session) {
          final gender = session.user?.educator?.gender;
          final avatarImage = _getAvatarImage(gender);
          return GestureDetector(
            onTap: () {
              Get.toNamed(PreferencesScreen.routeName);
            },
            child: Container(
                margin: EdgeInsets.only(right: 13.w),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage: AssetImage(avatarImage),
                    )
                  ],
                )
            ),
          );
        }
    );
  }
}
