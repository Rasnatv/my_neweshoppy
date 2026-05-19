

import 'package:entenaadu/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../data/models/locationmodel.dart';
import '../../controller/admin_locationcontroller.dart';

class DistrictLocationListPage extends StatelessWidget {
  final LocationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: AppColors.kPrimary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Location Management",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: controller.fetchLocations,
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final states = controller.stateList;

          if (states.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_off_outlined,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    "No locations available",
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          final totalDistricts = states.fold<int>(
            0, (sum, s) => sum + s.districts.length,
          );
          final totalLocations = states.fold<int>(
            0,
                (sum, s) => sum +
                s.districts.fold<int>(
                  0, (dSum, d) => dSum + d.locations.length,
                ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Summary Bar ──────────────────────────
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.kPrimary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.kPrimary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "${states.length} States  •  $totalDistricts Districts  •  $totalLocations Locations",
                      style: TextStyle(
                        color: AppColors.kPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // ── State List ────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: states.length,
                  itemBuilder: (_, i) => _StateCard(state: states[i]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// State Card  (expands to show districts)
// ─────────────────────────────────────────────────────
class _StateCard extends StatelessWidget {
  final StateItem state;
  const _StateCard({required this.state});

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final totalLocations = state.districts.fold<int>(
      0, (sum, d) => sum + d.locations.length,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // ── State icon ──
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.kPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.map_outlined,
              color: Colors.white, size: 22),
        ),
        title: Text(
          _capitalize(state.state),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            letterSpacing: 0.1,
          ),
        ),
        subtitle: Text(
          "${state.districts.length} district(s)  •  $totalLocations location(s)",
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        childrenPadding:
        const EdgeInsets.fromLTRB(12, 0, 12, 12),
        children: state.districts
            .map((d) => _DistrictCard(district: d))
            .toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// District Card  (nested inside State card)
// ─────────────────────────────────────────────────────
class _DistrictCard extends StatelessWidget {
  final DistrictItem district;
  const _DistrictCard({required this.district});

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.deepPurple.withOpacity(0.12),
        ),
      ),
      child: ExpansionTile(
        tilePadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.location_city,
              color: Colors.deepPurple.shade600, size: 18),
        ),
        title: Text(
          _capitalize(district.district),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.deepPurple.shade800,
          ),
        ),
        subtitle: Text(
          "${district.locations.length} location(s)",
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        childrenPadding:
        const EdgeInsets.fromLTRB(14, 4, 14, 14),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: district.locations
                .map((loc) => _LocationChip(name: loc.location))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Location Chip
// ─────────────────────────────────────────────────────
class _LocationChip extends StatelessWidget {
  final String name;
  const _LocationChip({required this.name});

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.place, size: 14, color: Colors.deepPurple.shade600),
          const SizedBox(width: 6),
          Text(
            _capitalize(name),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple.shade700,
            ),
          ),
        ],
      ),
    );
  }
}