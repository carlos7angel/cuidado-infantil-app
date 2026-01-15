import 'package:cuidado_infantil/Monitoring/controllers/attendance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FilterAttendanceDrawer extends StatelessWidget {
  const FilterAttendanceDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(
      id: 'list_child',
      builder: (controller) {
        return Drawer(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Aplicar filtros',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          controller.clearRoomFilters();
                        },
                        child: Text(
                          'Limpiar',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      ExpansionTile(
                        initiallyExpanded: true,
                        minTileHeight: 55.h,
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                        childrenPadding: EdgeInsets.zero,
                        title: Text(
                          'Salas/Grupos',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: controller.rooms.isEmpty
                            ? [
                                Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Text(
                                    'No hay grupos disponibles',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                )
                              ]
                            : controller.rooms.map((room) {
                                final isSelected = controller.selectedRoomIds.contains(room.id);
                                return CheckboxListTile(
                                  value: isSelected,
                                  onChanged: (value) {
                                    controller.toggleRoomFilter(room.id);
                                  },
                                  activeColor: Theme.of(context).colorScheme.secondary,
                                  title: Text(
                                    room.name,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                );
                              }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

