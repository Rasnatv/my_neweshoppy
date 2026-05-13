import 'package:eshoppy/app/modules/admin_home/view/restaurant/restaurantmenumanagementwidget/shared_uihelpers.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/style/app_colors.dart';
import '../../../../../data/models/adminretaurant_menumodel.dart';
import '../controller/restaurant_menuaddingcontroller.dart';
import 'capacityrangleformats.dart';



class TablesTabzz extends StatelessWidget {
  const TablesTabzz({super.key});

  RestaurantmenuController get c => Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        gradientStripzz(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildCardzz(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionHeaderzz(
                      icon: Icons.add_circle_outline_rounded,
                      title: 'Add Table Type',
                      subtitle:
                      'Configure seating groups for your restaurant floor',
                    ),
                    const SizedBox(height: 20),
                    modernTextFieldzz(
                      controller: c.tableTypeCtrl,
                      label: 'Table Name',
                      hint: 'e.g. 6 seater, 4 seater',
                      icon: Icons.table_restaurant_outlined,
                    ),
                    const SizedBox(height: 16),
                    modernTextFieldzz(
                      controller: c.capacityRangeCtrl,
                      label: 'Capacity Range',
                      hint: 'e.g. 7  or  1–7',
                      icon: Icons.people_outline,
                      type: TextInputType.text,
                      inputFormatters: [CapacityRangeFormatterzz()],
                    ),
                    const SizedBox(height: 16),
                    modernTextFieldzz(
                      controller: c.tableIdsCtrl,
                      label: 'Table IDs',
                      hint: 'e.g. T1, T2, T3',
                      icon: Icons.grid_view_rounded,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => modernDropdownzz<SeatingType>(
                      label: 'Seating Arrangement',
                      icon: Icons.chair_outlined,
                      value: c.seatingType.value,
                      items: SeatingType.values,
                      itemLabel: (e) => e.name.capitalizeFirst!,
                      onChanged: (v) => c.seatingType.value = v!,
                    )),
                    const SizedBox(height: 24),
                    Obx(() => primaryBtnzz(
                      label: 'Add Table Type',
                      icon: Icons.add_rounded,
                      loading: c.isAddingTable.value,
                      onPressed:
                      c.isAddingTable.value ? null : c.submitTableForm,
                    )),
                  ]),
            ),
            buildCardzz(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionHeaderzz(
                      icon: Icons.table_restaurant_rounded,
                      title: 'Your Tables',
                      subtitle: 'Manage existing seating configurations',
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (c.tableTypes.isEmpty) {
                        return emptyStatezz(
                          icon: Icons.table_restaurant_outlined,
                          message: 'No tables configured yet',
                          sub: 'Add your first table type above',
                        );
                      }
                      return Column(
                        children: c.tableTypes
                            .map((table) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.kPrimary
                                    .withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.table_restaurant,
                                  color: AppColors.kPrimary,
                                  size: 22),
                            ),
                            title: Text(table.name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1D2E))),
                            subtitle: Padding(
                              padding:
                              const EdgeInsets.only(top: 6),
                              child: Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    chipzz(
                                        '${table.capacityRange} seats',
                                        Icons.people_outline),
                                    chipzz(
                                        table.seatingType.name
                                            .capitalizeFirst!,
                                        Icons.chair_outlined),
                                    chipzz(
                                        table.availableTables
                                            .join(', '),
                                        Icons.grid_view_rounded),
                                  ]),
                            ),
                            isThreeLine: true,
                            trailing: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.delete_outline,
                                  color: Colors.red.shade400,
                                  size: 18),
                            ),
                            onTap: () =>
                                c.removeTableTypeLocally(table),
                          ),
                        ))
                            .toList(),
                      );
                    }),
                  ]),
            ),
          ]),
        ),
      ]),
    );
  }
}