import 'package:cuidado_infantil/Intro/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  static final String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Get.put(SplashController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/logo_cuidado_activo.png', height: ScreenUtil().setHeight(100))
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
                      strokeWidth: 3.5,
                    ),
                    SizedBox(height: 20.h,),
                    Text(
                      'Impulsado por:',
                      style: Theme.of(context).textTheme.bodySmall?.merge(
                          TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500)
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/logo_vmb.png'),
                          height: 20.h,
                        ),
                        SizedBox(width: 5.w,),
                        Image(
                          image: AssetImage('assets/images/logo_koica.png'),
                          height: 20.h,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/logo_onu.png'),
                          height: 30.h,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
