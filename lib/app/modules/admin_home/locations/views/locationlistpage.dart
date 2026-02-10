
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../controller/admin_locationcontroller.dart';

class DistrictLocationListPage extends StatelessWidget {
  final LocationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text(
          "Location Management",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.fetchLocations,
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.stateList.isEmpty) {
          return const Center(
            child: Text(
              "No locations available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.stateList.length,
          itemBuilder: (context, index) {
            final state = controller.stateList[index];

            return _StateCard(state: state);
          },
        );
      }),
    );
  }
}

class _StateCard extends StatelessWidget {
  final state;

  const _StateCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const Icon(Icons.map, color: Color(0xFF089385)),
        title: Text(
          state.state,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${state.districts.length} Districts",
          style: TextStyle(color: Colors.grey.shade600),
        ),
        children: state.districts.map<Widget>((district) {
          return _DistrictCard(district: district);
        }).toList(),
      ),
    );
  }
}

class _DistrictCard extends StatelessWidget {
  final district;

  const _DistrictCard({required this.district});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.deepPurple.shade100),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: const Icon(Icons.location_city,
            color: Color(0xFF089385)),
        title: Text(
          district.district,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "${district.locations.length} Locations",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        children: district.locations.map<Widget>((loc) {
          return _LocationTile(name: loc.location);
        }).toList(),
      ),
    );
  }
}
class _LocationTile extends StatelessWidget {
  final String name;

  const _LocationTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.place, color: Color(0xFF089385), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

