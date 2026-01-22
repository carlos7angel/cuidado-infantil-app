import 'package:cuidado_infantil/Auth/ui/screens/login_screen.dart';
import 'package:cuidado_infantil/Intro/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  static final String routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: GetBuilder<OnBoardingController>(
          init: OnBoardingController(),
          builder: (controller) {
            return Container(
              child: Stack(
                children: [
                  PageView.builder(
                    physics: BouncingScrollPhysics(),
                    pageSnapping: true,
                    controller: _pageController,
                    reverse: false,
                    itemCount: controller.infographicList.length,
                    onPageChanged: (int page) => controller.setPage(page),
                    itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).padding.top),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(controller.infographicList[index].image, height: ScreenUtil().setHeight(280))
                              ),
                              SizedBox(height: 40,),
                              Container(
                                  child: Text(
                                      controller.infographicList[index].title,
                                      style: Theme.of(context).textTheme.headlineLarge?.merge(TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.secondary))
                                  )
                              ),
                              SizedBox(height: 20,),
                              Container(
                                  child: Text(controller.infographicList[index].content, style: Theme.of(context).textTheme.bodyLarge?.merge(TextStyle(fontSize: 18.sp, height: 1.2, fontWeight: FontWeight.w500)))
                              ),
                            ],
                          ),
                        ),
                      )
                    ),
                  ),
                  Visibility(
                    visible: !(controller.currentPage == (controller.infographicList.length - 1)),
                    child: Positioned(
                      top: ScreenUtil().setHeight(60),
                      right: 20.w,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          padding: EdgeInsets.symmetric(horizontal: 35, vertical: ScreenUtil().setWidth(12)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          //_pageController.jumpToPage(_.infographicList.list.length - 1);
                          _pageController.animateToPage(controller.infographicList.length - 1, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
                        },
                        child: Text(
                          'Saltar',
                          style: Theme.of(context).textTheme.bodyMedium?.merge(TextStyle(fontSize: 14.sp, color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 15.0,
                    bottom: ScreenUtil().setHeight(80),
                    child: Row(
                      children: [
                        for(int i = 0; i < controller.infographicList.length; i++) i == controller.currentPage ? pageIndicator(true) : pageIndicator(false)
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.currentPage == (controller.infographicList.length - 1),
                    child: Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: config.App(context).appWidth(ScreenUtil().setWidth(65)),
                        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(60)),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            padding: EdgeInsets.symmetric(horizontal: 35, vertical: ScreenUtil().setWidth(15)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              ),
                            ),
                          ),
                          onPressed: () { Get.toNamed(LoginScreen.routeName); },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Continuar',
                                style: Theme.of(context).textTheme.bodyMedium?.merge(
                                  TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget pageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      height: 10.h,
      width: isCurrentPage ? 30.w : 10.w,
      decoration: BoxDecoration(
          color: isCurrentPage ? config.AppColors.mainColor(1) : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
    );
  }
}

