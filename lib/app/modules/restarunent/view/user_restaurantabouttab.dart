
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/user_restaurantaboutsection_controller.dart';
class RestaurantAboutTab extends StatelessWidget {
  final String restaurantId;

  RestaurantAboutTab({super.key, required this.restaurantId});

  final controller = Get.put(RestaurantAboutController());

  @override
  Widget build(BuildContext context) {
    controller.fetchAbout(restaurantId);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = controller.about.value;

      if (data == null) {
        return const Center(child: Text("No details available"));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoTile(Icons.location_on, "Address", data.address),
            infoTile(Icons.phone, "Phone", data.phone),
            infoTile(Icons.email, "Email", data.email),
            infoTile(Icons.language, "Website", data.website),

            const SizedBox(height: 20),

            const Text(
              "Connect With Us",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                socialIcon(
                  icon: Icons.message,
                  color: Colors.green,
                  onTap: () => _launchUrl("https://wa.me/${data.whatsapp}"),
                ),
                socialIcon(
                  icon: Icons.facebook,
                  color: Colors.blue,
                  onTap: () => _launchUrl(data.facebook),
                ),
                socialIcon(
                  icon: Icons.camera_alt,
                  color: Colors.purple,
                  onTap: () => _launchUrl(data.instagram),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
Widget infoTile(IconData icon, String title, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.teal, size: 26),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              Text(value.isEmpty ? "-" : value,
                  style:
                  const TextStyle(color: Colors.black54, fontSize: 14)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget socialIcon({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 28),
    ),
  );
}

Future<void> _launchUrl(String url) async {
  if (url.isEmpty) return;
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
