import 'package:cuidado_infantil/Child/ui/screens/child_form_screen.dart';
import 'package:cuidado_infantil/Child/ui/screens/child_list_screen.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Intro/ui/screens/home_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_child_list_screen.dart';
import 'package:cuidado_infantil/User/ui/screens/preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.075),
                offset: Offset(0, -2),
                blurRadius: 10
            )
          ]
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(size: 25),
        unselectedItemColor: Theme.of(context).hintColor.withOpacity(1),
        //currentIndex: widget.selectedTab,
        currentIndex: 2,
        onTap: (int i) {
          if(i == 0)
          {
            Get.toNamed(ChildFormScreen.routeName);
          }
          else if(i == 1)
          {
            Get.toNamed(ChildListScreen.routeName);
          }
          else if(i == 2)
          {
            Get.toNamed(HomeScreen.routeName);
          }
          else if(i == 3)
          {
            Get.toNamed(MonitoringChildListScreen.routeName);
          }
          else if(i == 4)
          {
            Get.toNamed(PreferencesScreen.routeName);
          }
          else
          {
            // this._selectTab(i);
          }

        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(UiIcons.edit),
            label: "Nuevo",
            tooltip: "Nuevo Infante",
            //title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(UiIcons.filter),
            label: "Infantes",
            tooltip: "Lista de Inscritos",
            //title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            //title: new Container(height: 5.0),
              label: "Inicio",
              icon: Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.r),
                  ),
                  boxShadow: [
                    //BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                    BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                  ],
                ),
                child: Icon(UiIcons.home, color: Theme.of(context).primaryColor),
              ),
              tooltip: "Inicio"
          ),
          BottomNavigationBarItem(
            icon: Icon(UiIcons.heart),
            label: "Seguimiento",
            tooltip: "Seguimiento y Monitoreo",
            //title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(UiIcons.settings_1),
            label: "Preferencias",
            tooltip: "Mi Perfil",
            //title: new Container(height: 0.0),
          ),
        ],
      ),
    );
  }
}