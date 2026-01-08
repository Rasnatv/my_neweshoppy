

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/usersignup_controller.dart';

class UserSignup extends StatelessWidget {
  UserSignup({super.key});

  final UsersignupController controller =
  Get.put(UsersignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/products/store.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              Container(
                color: Colors.black.withOpacity(0.4),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 60),

                        const Text(
                          "Create Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _glassField(
                          controller: controller.nameController,
                          label: "Full Name",
                          icon: Icons.person,
                        ),

                        _glassField(
                          controller: controller.emailController,
                          label: "Email",
                          icon: Icons.email,
                          isEmail: true,
                        ),

                        _glassField(
                          controller: controller.phoneController,
                          label: "Phone",
                          icon: Icons.phone,
                        ),

                        _glassField(
                          controller: controller.addressController,
                          label: "Address",
                          icon: Icons.location_on,
                        ),

                        Obx(() => _glassField(
                          controller:
                          controller.passwordController,
                          label: "Password",
                          icon: Icons.lock,
                          obscure:
                          !controller.isPasswordVisible.value,
                          suffix: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: controller
                                .togglePasswordVisibility,
                          ),
                        )),

                        const SizedBox(height: 20),

                        Obx(() => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                            controller.isLoading.value
                                ? null
                                : controller.register,
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text("Sign Up"),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    bool isEmail = false,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              }
              if (isEmail && !value.contains("@")) {
                return "Invalid email";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: label,
              labelStyle:
              const TextStyle(color: Colors.white70),
              prefixIcon:
              Icon(icon, color: Colors.white70),
              suffixIcon: suffix,
              filled: true,
              fillColor:
              Colors.white.withOpacity(0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
