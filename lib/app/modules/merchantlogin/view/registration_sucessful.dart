import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class MerchantRegistrationSuccessPage extends StatelessWidget {
  final String lottieUrl;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onDashboardPressed;

  MerchantRegistrationSuccessPage({
    Key? key,
    this.lottieUrl =
    'https://assets10.lottiefiles.com/packages/lf20_jbrw3hcz.json', // default success animation
    this.onLoginPressed,
    this.onDashboardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Lottie animation (flexible for different screen sizes)

                 Center(
                  child: Lottie.network(
                    lottieUrl,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.75,
                    repeat: false,
                  ),
                ),


              const SizedBox(height: 8),

              // Title
              Text(
                'Registration Successful!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle / explanation
              Text(
                'Your account has been created and approved by the admin. You can now log in and start selling your products.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onLoginPressed ?? () {
                        // Default action: navigate to '/login' using GetX
                        try {
                          Get.toNamed('/login');
                        } catch (e) {
                          // If route not found, pop and let caller handle
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text('Go to Login'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
