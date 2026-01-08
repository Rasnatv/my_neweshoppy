
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../product/widgtet/productcard.dart';

class ShopDetailPage extends StatelessWidget {
  // Replace these with your actual data
  final String title = 'City Bakery';
  final String address = 'Test address';
  final String phone1 = '9207255558';
  final String phone2 = '9656325896';
  final String website = 'www.example.com';
  final String email = 'dch@example.com';

  // Shop location (example coordinates)
  final double shopLatitude = 12.9716;
  final double shopLongitude = 77.5946;

  // Replace with your asset image path
  final String headerImage = 'assets/images/products/citybakers.jpg';
  final List<String> galleryImages = [
    'assets/images/products/citybakers.jpg',
    'assets/images/products/citybakers.jpg',
    'assets/images/products/citybakers.jpg',
    'assets/images/products/citybakers.jpg',
  ];


  ShopDetailPage({super.key});

  void _launchPhone(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _launchWebsite(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _openMap(double lat, double lng) async {
    final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header image with overlay
              SizedBox(
                height: 230,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                      child: Image.asset(
                        headerImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.35),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 6,
                      top: 6,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back ,color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 16,
                      child: Center(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                blurRadius: 6,
                                color: Colors.black45,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab bar
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Material(
                  color: Colors.transparent,
                  child: TabBar(
                    indicatorColor: Colors.blue.shade700,
                    labelColor: Colors.blue.shade700,
                    unselectedLabelColor: Colors.grey.shade600,
                    tabs: const [
                      Tab(text: 'PRODUCT'),
                      Tab(text: 'GALLERY'),
                      Tab(text: 'ABOUT'),
                    ],
                  ),
                ),
              ),

              // Tab views
              Expanded(
                child: TabBarView(
                  children: [
                    // ------------------ PRODUCT TAB ------------------
                    GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: 4,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard();
                      },
                    ),


                    // ------------------ GALLERY TAB ------------------

                    GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: galleryImages.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            galleryImages[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),




// ------------------ PRODUCTS TAB ------------------

                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                      child: Column(
                        children: [
                          // Location Card
                          InkWell(
                            onTap: () => _openMap(shopLatitude, shopLongitude),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.red, size: 28),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      "View Shop Location",
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      color: Colors.grey, size: 18),
                                ],
                              ),
                            ),
                          ),

                          // Info Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 1),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    children: [
                                      _infoRow(
                                        icon: Icons.location_on_outlined,
                                        label: 'ADDRESS',
                                        value: address,
                                        onTap: null,
                                      ),
                                      const SizedBox(height: 12),
                                      _infoRow(
                                        icon: Icons.phone_outlined,
                                        label: 'PHONE',
                                        value: phone1,
                                        onTap: () => _launchPhone(phone1),
                                      ),
                                      const SizedBox(height: 12),
                                      _infoRow(
                                        icon: Icons.phone_outlined,
                                        label: 'PHONE',
                                        value: phone2,
                                        onTap: () => _launchPhone(phone2),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1, color: Color(0xFFE6E6E6)),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    children: [
                                      _infoRow(
                                        icon: Icons.language_outlined,
                                        label: 'WEBSITE',
                                        value: website,
                                        onTap: () => _launchWebsite(website),
                                      ),
                                      const SizedBox(height: 12),
                                      _infoRow(
                                        icon: Icons.email_outlined,
                                        label: 'E-MAIL',
                                        value: email,
                                        onTap: () => _launchEmail(email),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Social icons row
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _socialCircle(
                                  icon: Icons.facebook,
                                  label: 'WhatsApp',
                                  onTap: () => _launchPhone(phone1),
                                ),
                                _socialCircle(
                                  icon: Icons.camera_alt_outlined,
                                  label: 'Instagram',
                                  onTap: () => _launchWebsite('https://www.instagram.com'),
                                ),
                                _socialCircle(
                                  icon: Icons.facebook,
                                  label: 'Facebook',
                                  onTap: () => _launchWebsite('https://www.facebook.com'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Info row helper
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  // Circle social button helper
  Widget _socialCircle({required IconData icon, required String label, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(icon, size: 30, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
