
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/admin_registeredusers_controller.dart';

class AdminUserListPage extends StatelessWidget {
  AdminUserListPage({super.key});

  final AdminUserController controller = Get.put(AdminUserController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F9),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Registered Users',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          backgroundColor: Colors.teal,
          elevation: 0,
          actions: [
            // ── Export Buttons (hidden when empty / loading) ──
            Obx(() {
              if (controller.isLoading.value || controller.users.isEmpty) {
                return const SizedBox.shrink();
              }
              return Row(
                children: [
                  // ── Excel Button ──────────────────────────
                  Obx(() => controller.isExcelGenerating.value
                      ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    ),
                  )
                      : IconButton(
                    icon: const Icon(
                      Icons.table_chart_rounded,
                      color: Colors.white,
                    ),
                    tooltip: 'Download Excel',
                    onPressed: controller.downloadUsersExcel,
                  )),

                  // ── PDF Button ────────────────────────────
                  Obx(() => controller.isPdfGenerating.value
                      ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    ),
                  )
                      : IconButton(
                    icon: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.white,
                    ),
                    tooltip: 'Download PDF',
                    onPressed: controller.downloadUsersPdf,
                  )),

                  const SizedBox(width: 4),
                ],
              );
            }),
          ],
        ),

        // ── Body ───────────────────────────────────────────────
        body: Obx(() {
          // Loading state
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.teal,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading users...',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (controller.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_outline,
                      size: 80,
                      color: Colors.teal.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Registered Users',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Users will appear here once they register',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          // User list
          return RefreshIndicator(
            color: Colors.teal,
            onRefresh: controller.fetchUsers,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: controller.users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return _buildUserCard(context, user, index);
              },
            ),
          );
        }),
      ),
    );
  }

  // ── User Card ─────────────────────────────────────────────────
  Widget _buildUserCard(
      BuildContext context,
      Map<String, dynamic> user,
      int index,
      ) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.07),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Top row: avatar + name + date ─────────────────
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Avatar
                  Hero(
                    tag: 'user_${user["id"]}',
                    child: Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(user['name'] ?? ''),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Name + badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'User #${index + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Reg-date chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 15, color: Colors.grey.shade600),
                        const SizedBox(height: 4),
                        Text(
                          user['regDate'] ?? '-',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider ───────────────────────────────────────
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 18),
              color: Colors.grey.shade100,
            ),

            // ── Contact info grid ─────────────────────────────
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _infoChip(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: user['email'] ?? '',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _infoChip(
                          icon: Icons.phone_outlined,
                          title: 'Phone',
                          value: user['phone'] ?? '',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _infoChip(
                    icon: Icons.location_on_outlined,
                    title: 'Address',
                    value: user['address'] ?? '-',
                    color: Colors.orange,
                    fullWidth: true,
                  ),
                ],
              ),
            ),

            // ── View Purchases Button ─────────────────────────
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(
                    '/purchased-products',
                    arguments: {'user_id': user['id']},
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                label: const Text(
                  'View Purchases',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Info Chip ─────────────────────────────────────────────────
  Widget _infoChip({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.18), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
            maxLines: fullWidth ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}