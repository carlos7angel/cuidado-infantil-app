import 'package:cuidado_infantil/Child/controllers/child_list_controller.dart';
import 'package:cuidado_infantil/Child/ui/widgets/filter_child_drawer.dart';
import 'package:cuidado_infantil/Config/services/storage_service.dart';
import 'package:cuidado_infantil/Config/general/ui_icons.dart';
import 'package:cuidado_infantil/Config/widgets/empty_list.dart';
import 'package:cuidado_infantil/Config/widgets/gradient_text.dart';
import 'package:cuidado_infantil/Config/general/app_config.dart' as config;
import 'package:cuidado_infantil/Config/widgets/sliver_app_bar_title.dart';
import 'package:cuidado_infantil/Intro/ui/screens/home_screen.dart';
import 'package:cuidado_infantil/Intro/ui/widgets/navigation_menu.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_child_options_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_nutrition_list_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_vaccination_tracking_screen.dart';
import 'package:cuidado_infantil/Monitoring/ui/screens/monitoring_development_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MonitoringChildListScreen extends StatefulWidget {
  static final String routeName = '/monitoring_child_list';
  const MonitoringChildListScreen({super.key});

  @override
  State<MonitoringChildListScreen> createState() => _MonitoringChildListScreenState();
}

class _MonitoringChildListScreenState extends State<MonitoringChildListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  // Lista de colores para los avatares
  static final List<Color> _avatarColors = [
    Color(0xFF1ABC9C), // Turquesa
    Color(0xFF2ECC71), // Verde esmeralda
    Color(0xFF3498DB), // Azul peter river
    Color(0xFF9B59B6), // Amatista
    Color(0xFF34495E), // Asfalto
    Color(0xFFF1C40F), // Girasol
    Color(0xFFE67E22), // Zanahoria
    Color(0xFFE74C3C), // Alizarina
    Color(0xFF95A5A6), // Concreto
  ];

  /// Obtiene un color aleatorio pero consistente para un child basado en su ID
  Color _getAvatarColor(String? childId) {
    if (childId == null || childId.isEmpty) {
      // Si no hay ID, usar el primer color por defecto
      return _avatarColors[0];
    }

    // Usar el hash del ID para obtener un índice consistente
    final hash = childId.hashCode;
    final index = hash.abs() % _avatarColors.length;
    return _avatarColors[index];
  }

  @override
  void initState() {
    super.initState();
    Get.put(ChildListController());

    // Listener para el campo de búsqueda
    _searchController.addListener(() {
      final controller = Get.find<ChildListController>();
      controller.filterChildren(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offAllNamed(HomeScreen.routeName);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: RefreshIndicator(
          // edgeOffset: 210.w,
          onRefresh: () async {
            final controller = Get.find<ChildListController>();
            await controller.loadChildren();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                centerTitle: false,
                title: SliverAppBarTitle(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.w),
                    child: GradientText(
                      config.GRAY_LIGHT_GRADIENT_BUBBLE,
                      'Seguimiento y Monitoreo',
                      size: 18.sp,
                      align: TextAlign.left,
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(UiIcons.returnIcon, color: Theme.of(context).primaryColor, size: 24.sp,),
                  onPressed: () {
                    Get.offAllNamed(HomeScreen.routeName);
                  },
                ),
                actions: <Widget>[
                  SizedBox.shrink()
                ],
                backgroundColor: Theme.of(context).colorScheme.secondary,
                expandedHeight: 150.w,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [Colors.cyan, config.Colors().accentColor(0.5)]
                            )
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: (AppBar().preferredSize.height).h),
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                          // decoration: BoxDecoration(border: Border.all(width: 1)),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30.h,),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                                  child: GradientText(
                                    config.GRAY_LIGHT_GRADIENT_BUBBLE,
                                    "Seguimiento y",
                                    size: 28.sp,
                                    weight: FontWeight.w700,
                                    align: TextAlign.left,
                                  )
                              ),
                              SizedBox(height: 0.h,),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                                  child: GradientText(
                                    config.GRAY_LIGHT_GRADIENT_BUBBLE,
                                    "Monitoreo",
                                    size: 28.sp,
                                    weight: FontWeight.w700,
                                    align: TextAlign.left,
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: -60.w,
                        bottom: 10.h,
                        child: Container(
                          width: 300.w,
                          height: 300.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(300.r),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30.w,
                        top: -80.h,
                        child: Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(150.r),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Buscador fijado cuando se hace scroll
              GetBuilder<ChildListController>(
                id: 'list_child',
                builder: (controller) {
                  // No mostrar buscador cuando está cargando
                  if (controller.loading) {
                    return SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  // Buscador fijado usando SliverPersistentHeader
                  return SliverPersistentHeader(
                    pinned: true,
                    delegate: _SearchBarDelegate(
                      child: Container(
                        height: 70.h,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 10)
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: 'Buscar ',
                                  hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.8)),
                                  prefixIcon: Icon(UiIcons.loupe, size: 20, color: Theme.of(context).hintColor),
                                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _scaffoldKey.currentState?.openEndDrawer();
                                },
                                icon: Icon(UiIcons.settings_2, size: 20, color: Theme.of(context).hintColor.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      context: context,
                    ),
                  );
                },
              ),
              // Espacio después del buscador fijado
              GetBuilder<ChildListController>(
                id: 'list_child',
                builder: (controller) {
                  if (controller.loading) {
                    return SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                  return SliverToBoxAdapter(
                    child: SizedBox(height: 10.h),
                  );
                },
              ),
              // Contenido: loading, estados vacíos o lista
              GetBuilder<ChildListController>(
                id: 'list_child',
                builder: (controller) {
                  // Estado de carga
                  if (controller.loading) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    );
                  }

                  // Estado: No hay infantes registrados (mostrar mensaje después del buscador)
                  if (controller.childList.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: EmptyList(
                        icon: UiIcons.user_1,
                        message: 'No hay infantes registrados',
                      ),
                      ),
                    );
                  }

                  // Estado: Búsqueda sin resultados (mostrar mensaje después del buscador)
                  if (controller.searchChildList.isEmpty && _searchController.text.isNotEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              UiIcons.loupe,
                              size: 64,
                              color: Theme.of(context).hintColor.withOpacity(0.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No se encontraron resultados',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Intenta con otros términos de búsqueda',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Lista normal de children
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final child = controller.searchChildList[index];
                        final initial = child.getInitials();
                        final fullName = child.getFullName();
                        final ageText = child.getAge();

                        return InkWell(
                          onTap: () async {
                            await StorageService.instance.setSelectedChild(child);
                            Get.toNamed(MonitoringChildOptionsScreen.routeName);
                          },
                          child: Container(
                            color: Theme.of(context).focusColor.withOpacity(0.10),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            margin: EdgeInsets.only(bottom: index < controller.searchChildList.length - 1 ? 7 : 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircleAvatar(
                                    radius: 18.r,
                                    backgroundColor: _getAvatarColor(child.id),
                                    child: Text(
                                      initial,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        fullName.isNotEmpty ? fullName : 'Sin nombre',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: Theme.of(context).textTheme.bodyMedium?.merge(
                                          TextStyle(fontSize: 15.sp),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        ageText,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context).textTheme.bodyMedium?.merge(
                                          TextStyle(fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Botón de menú contextual
                                PopupMenuButton<String>(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Theme.of(context).hintColor,
                                    size: 20.sp,
                                  ),
                                  onSelected: (value) async {
                                    await StorageService.instance.setSelectedChild(child);
                                    switch (value) {
                                      case 'nutrition':
                                        Get.toNamed(MonitoringNutritionListScreen.routeName);
                                        break;
                                      case 'vaccination':
                                        Get.toNamed(MonitoringVaccinationTrackingScreen.routeName);
                                        break;
                                      case 'development':
                                        Get.toNamed(MonitoringDevelopmentListScreen.routeName);
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'nutrition',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.restaurant,
                                            size: 20.sp,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                          SizedBox(width: 10.w),
                                          Text('Seguimiento Nutricional'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'vaccination',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.vaccines,
                                            size: 20.sp,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                          SizedBox(width: 10.w),
                                          Text('Control de Vacunas'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'development',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.psychology,
                                            size: 20.sp,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                          SizedBox(width: 10.w),
                                          Text('Desarrollo de la Infancia'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: controller.searchChildList.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        endDrawer: FilterChildDrawer(),
        bottomNavigationBar: NavigationMenu()
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final BuildContext context;

  _SearchBarDelegate({required this.child, required this.context});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent {
    // Altura: padding vertical (10.h * 2 = 20.h) + altura del TextField con padding (~50.h)
    // Total: aproximadamente 70.h
    return 70.h;
  }

  @override
  double get minExtent {
    // Mismo tamaño que maxExtent para que no se encoja (pinned header)
    return 70.h;
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
