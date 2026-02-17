
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/offerproductcontroller.dart';

class AddOfferProductPage extends StatelessWidget {
  final IntegratedOfferController controller =
  Get.put(IntegratedOfferController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.kPrimary,
        foregroundColor: Colors.white,
        title: Text(
          "Add Offer Product",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          // Show total products added count badge in app bar
          Obx(() {
            if (!controller.offerCreated.value) return SizedBox.shrink();
            return Center(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "${controller.totalProductsAdded.value}/10 products",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Done button
          Obx(() => controller.offerCreated.value
              ? TextButton.icon(
            onPressed: controller.finishOffer,
            icon: Icon(Icons.check_circle, color: Colors.white),
            label: Text("Done",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          )
              : SizedBox.shrink()),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // STEP 1 badge — reactive on offerCreated
                      Obx(() => _buildStepBadge(
                        step: 1,
                        label: "Create Offer",
                        done: controller.offerCreated.value,
                      )),
                      SizedBox(height: 12),
                      _buildOfferDetailsCard(context),
                      SizedBox(height: 24),

                      // STEP 2 section — switches between locked / content
                      Obx(() => controller.offerCreated.value
                          ? _buildStep2Content(context)
                          : _buildStep2Locked()),

                      SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Full-screen loading overlay
          _buildLoadingOverlay(),
        ],
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  // ─── LOADING OVERLAY ─────────────────────────────────────────────────
  Widget _buildLoadingOverlay() {
    return Obx(() {
      final loading =
          controller.isCreatingOffer.value || controller.isSubmitting.value;
      if (!loading) return SizedBox.shrink();
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    controller.isCreatingOffer.value
                        ? "Creating offer..."
                        : "Adding product to offer...",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ─── FAB ─────────────────────────────────────────────────────────────
  Widget _buildFab(BuildContext context) {
    return Obx(() {
      // Step 1 FAB
      if (!controller.offerCreated.value) {
        if (controller.isCreatingOffer.value) return SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: controller.createOffer,
          backgroundColor: AppColors.kPrimary,
          icon: Icon(Icons.rocket_launch_outlined),
          label: Text("Create Offer",
              style: TextStyle(fontWeight: FontWeight.w600)),
          elevation: 4,
        );
      }
      // Step 2 FAB — show only when variants exist and not at limit
      if (controller.variants.isNotEmpty &&
          !controller.isSubmitting.value &&
          controller.variants.length <= 10 &&
          controller.totalProductsAdded.value < 10) {
        return FloatingActionButton.extended(
          onPressed: () => _saveOfferProduct(context),
          backgroundColor: Color(0xFF10B981),
          icon: Icon(Icons.add_circle_outline),
          label: Text("Add Product to Offer",
              style: TextStyle(fontWeight: FontWeight.w600)),
          elevation: 4,
        );
      }
      return SizedBox.shrink();
    });
  }

  // ─── HEADER ──────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Create New Offer",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A))),
          SizedBox(height: 8),
          Text(
            "Step 1: Set discount & banner  →  Step 2: Add up to 10 products",
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  // ─── STEP BADGE ──────────────────────────────────────────────────────
  Widget _buildStepBadge(
      {required int step, required String label, required bool done}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? Color(0xFF10B981) : AppColors.kPrimary,
          ),
          child: Center(
            child: done
                ? Icon(Icons.check, color: Colors.white, size: 18)
                : Text("$step",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
          ),
        ),
        SizedBox(width: 10),
        Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A))),
        if (done) ...[
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xFF10B981).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("Done",
                style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ],
    );
  }

  // ─── STEP 2 LOCKED ───────────────────────────────────────────────────
  Widget _buildStep2Locked() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepBadge(step: 2, label: "Add Products", done: false),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFD1D5DB)),
          ),
          child: Column(
            children: [
              Icon(Icons.lock_outline,
                  color: Color(0xFF9CA3AF), size: 40),
              SizedBox(height: 12),
              Text("Create the offer first",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280))),
              SizedBox(height: 6),
              Text(
                "Set the discount % and banner above, then tap \"Create Offer\" to unlock product addition.",
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── STEP 2 CONTENT ──────────────────────────────────────────────────
  Widget _buildStep2Content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepBadge(step: 2, label: "Add Products", done: false),
        SizedBox(height: 12),
        _buildOfferSummaryBanner(),
        SizedBox(height: 16),
        _buildProductLimitIndicator(),
        SizedBox(height: 16),

        // Block adding more products when 10 are saved
        Obx(() => controller.totalProductsAdded.value >= 10
            ? _buildMaxProductsReachedCard()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductNameCard(),
            SizedBox(height: 16),
            _buildDescriptionCard(),
            SizedBox(height: 16),
            _buildCategoryCard(context),
            SizedBox(height: 24),
            Obx(() =>
            controller.selectedCategory.value.isNotEmpty
                ? Column(children: [
              _buildCommonAttributesSection(),
              SizedBox(height: 24),
            ])
                : SizedBox.shrink()),
            Obx(() => (controller.selectedCategory.value
                .isNotEmpty &&
                controller.hasVariantAttributes())
                ? Column(children: [
              _buildVariantConfigurationSection(context),
              SizedBox(height: 24),
            ])
                : SizedBox.shrink()),
            Obx(() => controller.variants.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVariantsHeader(),
                SizedBox(height: 16),
                ...controller.variants
                    .asMap()
                    .entries
                    .map((entry) => _buildVariantCard(
                    context,
                    entry.key,
                    entry.value)),
              ],
            )
                : SizedBox.shrink()),
          ],
        )),
      ],
    );
  }

  // ─── MAX PRODUCTS REACHED CARD ───────────────────────────────────────
  Widget _buildMaxProductsReachedCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFEF4444).withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.block, color: Color(0xFFEF4444), size: 48),
          SizedBox(height: 12),
          Text("Maximum 10 Products Reached",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444))),
          SizedBox(height: 8),
          Text(
            "You've added all 10 products to this offer. Tap \"Done\" in the top-right to finish.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFFDC2626)),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: controller.finishOffer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF10B981),
              padding:
              EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.check_circle),
            label: Text("Finish Offer",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  // ─── OFFER SUMMARY BANNER ────────────────────────────────────────────
  Widget _buildOfferSummaryBanner() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Color(0xFF10B981).withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.local_offer,
                color: Colors.white, size: 24),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Offer Active ✓",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                SizedBox(height: 4),
                Obx(() => Text(
                  "ID: #${controller.createdOfferId.value} · "
                      "${controller.discountPercentageCtrl.text}% discount",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13),
                )),
              ],
            ),
          ),
          // ── Products saved counter (the KEY fix) ──
          Obx(() {
            final saved = controller.totalProductsAdded.value;
            final isDrafting = controller.variants.isNotEmpty;
            final isAtLimit = saved >= 10;
            return Column(
              children: [
                Text(
                  "$saved",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  "/ 10",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12),
                ),
                Text(
                  isAtLimit ? "full" : "saved",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11),
                ),
                if (isDrafting && !isAtLimit)
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "+1 drafting",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 9,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ─── PRODUCT LIMIT INDICATOR ─────────────────────────────────────────
  Widget _buildProductLimitIndicator() {
    return Obx(() {
      final currentCount = controller.totalProductsAdded.value;
      const maxCount = 10;
      final percentage = (currentCount / maxCount).clamp(0.0, 1.0);
      final isAtLimit = currentCount >= maxCount;
      final isNearLimit = currentCount >= 8;

      final Color indicatorColor;
      final Color bgColor;
      final IconData icon;
      final String message;

      if (isAtLimit) {
        indicatorColor = Color(0xFFEF4444);
        bgColor = Color(0xFFFEE2E2);
        icon = Icons.block;
        message = "Maximum limit reached! Cannot add more products.";
      } else if (isNearLimit) {
        indicatorColor = Color(0xFFF59E0B);
        bgColor = Color(0xFFFEF3C7);
        icon = Icons.warning_amber_rounded;
        message =
        "Almost at limit! ${maxCount - currentCount} remaining.";
      } else {
        indicatorColor = Color(0xFF10B981);
        bgColor = Color(0xFFD1FAE5);
        icon = Icons.check_circle_outline;
        message = "$currentCount of $maxCount products saved";
      }

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border:
          Border.all(color: indicatorColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: indicatorColor, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Limit",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: indicatorColor)),
                      SizedBox(height: 4),
                      Text(message,
                          style: TextStyle(
                              fontSize: 13,
                              color:
                              indicatorColor.withOpacity(0.8))),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor:
                AlwaysStoppedAnimation(indicatorColor),
                minHeight: 8,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── OFFER DETAILS CARD ──────────────────────────────────────────────
  Widget _buildOfferDetailsCard(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
              "Offer Details", Icons.local_offer_outlined),
          SizedBox(height: 16),
          Obx(() {
            final locked = controller.offerCreated.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Discount Percentage",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A))),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: locked
                        ? Color(0xFFF3F4F6)
                        : Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: Color(0xFFE5E7EB)),
                  ),
                  child: TextField(
                    controller:
                    controller.discountPercentageCtrl,
                    enabled: !locked,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontSize: 15,
                        color: locked
                            ? Color(0xFF9CA3AF)
                            : Color(0xFF1A1A1A)),
                    decoration: InputDecoration(
                      hintText: "e.g., 20",
                      prefixIcon: Icon(Icons.percent,
                          color: Color(0xFF6B7280), size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      hintStyle: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14),
                      suffixIcon: locked
                          ? Icon(Icons.lock,
                          color: Color(0xFF9CA3AF),
                          size: 18)
                          : null,
                    ),
                    onChanged: (_) {
                      for (int i = 0;
                      i < controller.variants.length;
                      i++) {
                        controller.updateVariantPrice(i,
                            controller.variants[i].price);
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text("Offer Banner",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A))),
                SizedBox(height: 8),
                _buildBannerPicker(locked),
                if (!locked) ...[
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                      controller.isCreatingOffer.value
                          ? null
                          : controller.createOffer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimary,
                        padding: EdgeInsets.symmetric(
                            vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12)),
                      ),
                      icon: controller.isCreatingOffer.value
                          ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                              AlwaysStoppedAnimation(
                                  Colors.white)))
                          : Icon(Icons.rocket_launch_outlined),
                      label: Text(
                        controller.isCreatingOffer.value
                            ? "Creating..."
                            : "Create Offer & Add Products",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  // ─── BANNER PICKER ────────────────────────────────────────────────────
  Widget _buildBannerPicker(bool locked) {
    return Obx(() => GestureDetector(
      onTap:
      locked ? null : () => controller.pickBannerImage(),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: locked
                ? Color(0xFF10B981).withOpacity(0.5)
                : Color(0xFFE5E7EB),
            width: 2,
          ),
        ),
        child: controller.bannerImage.value == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 48, color: Color(0xFF3B82F6)),
            SizedBox(height: 12),
            Text("Tap to add offer banner",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 4),
            Text("Recommended: 1920 x 1080",
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF))),
          ],
        )
            : Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                  controller.bannerImage.value!,
                  fit: BoxFit.cover),
            ),
            if (locked)
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10),
                  color:
                  Colors.black.withOpacity(0.15),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.white,
                            size: 16),
                        SizedBox(width: 6),
                        Text("Banner Set",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.w600,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            if (!locked)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2),
                            blurRadius: 8)
                      ]),
                  child: IconButton(
                    icon: Icon(Icons.edit,
                        color: Color(0xFF3B82F6),
                        size: 20),
                    onPressed: () =>
                        controller.pickBannerImage(),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }

  // ─── PRODUCT NAME ────────────────────────────────────────────────────
  Widget _buildProductNameCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
              "Product Name", Icons.shopping_bag_outlined),
          SizedBox(height: 12),
          _buildTextField(
            label: "Enter product name",
            hint: "e.g., Classic Cotton T-Shirt",
            icon: Icons.label_outline,
            onChanged: (val) =>
            controller.productName.value = val,
          ),
        ],
      ),
    );
  }

  // ─── DESCRIPTION ─────────────────────────────────────────────────────
  Widget _buildDescriptionCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
              "Product Description", Icons.description_outlined),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E7EB)),
            ),
            child: TextField(
              onChanged: (val) =>
              controller.productDescription.value = val,
              style: TextStyle(
                  fontSize: 15, color: Color(0xFF1A1A1A)),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Describe your product in detail...",
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Icon(Icons.text_fields,
                      color: Color(0xFF6B7280), size: 20),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CATEGORY ────────────────────────────────────────────────────────
  Widget _buildCategoryCard(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Category", Icons.category_outlined),
          SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingCategories.value) {
              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: Color(0xFFE5E7EB))),
                child: Center(
                    child: CircularProgressIndicator()),
              );
            }
            if (controller.apiCategories.isEmpty) {
              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: Color(0xFFE5E7EB))),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber,
                        color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            "No categories available")),
                    TextButton(
                        onPressed: () =>
                            controller.fetchCategories(),
                        child: Text("Retry")),
                  ],
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border:
                  Border.all(color: Color(0xFFE5E7EB))),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.list_alt,
                        color: Color(0xFF6B7280), size: 20),
                    hintText: "Choose a category",
                    hintStyle: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14)),
                value: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value,
                items: controller.apiCategories
                    .map((c) => DropdownMenuItem(
                    value: c.name,
                    child: Text(c.name,
                        style: TextStyle(fontSize: 15))))
                    .toList(),
                onChanged: (val) {
                  if (val != null)
                    controller.onCategoryChanged(val);
                },
                dropdownColor: Colors.white,
                icon: Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF6B7280)),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── COMMON ATTRIBUTES ───────────────────────────────────────────────
  Widget _buildCommonAttributesSection() {
    final config =
    controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.commonAttributes.isEmpty) {
      return SizedBox.shrink();
    }
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
              "Common Attributes", Icons.info_outline),
          SizedBox(height: 8),
          Text("These attributes apply to all variants",
              style: TextStyle(
                  fontSize: 13, color: Color(0xFF6B7280))),
          SizedBox(height: 16),
          ...config.commonAttributes.map((attr) => Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _buildCommonAttributeInput(attr),
          )),
        ],
      ),
    );
  }

  Widget _buildCommonAttributeInput(String attribute) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFE5E7EB))),
      child: TextField(
        onChanged: (value) =>
            controller.setCommonAttribute(attribute, value),
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: attribute,
          hintText: "Enter $attribute",
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle: TextStyle(
              fontSize: 13, color: Color(0xFF6B7280)),
          hintStyle: TextStyle(
              fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  // ─── VARIANT CONFIGURATION ───────────────────────────────────────────
  Widget _buildVariantConfigurationSection(BuildContext context) {
    final config =
    controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.variantAttributes.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Configure Variants", Icons.tune),
          SizedBox(height: 8),
          Text(
            "Example: Color 'Green' → sizes 'S'; Color 'Blue' → sizes 'M, L, XL'",
            style: TextStyle(
                fontSize: 13, color: Color(0xFF6B7280)),
          ),
          SizedBox(height: 16),

          // Configured summary list
          Obx(() {
            if (controller.variantTypeConfigurations.isEmpty) {
              return SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Configured:",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A))),
                SizedBox(height: 8),
                ...controller.variantTypeConfigurations.entries
                    .map(
                      (typeEntry) => Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Color(0xFF10B981).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Color(0xFF10B981)
                                .withOpacity(0.3))),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(typeEntry.key,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF10B981))),
                        SizedBox(height: 8),
                        ...typeEntry.value.entries.map(
                              (primaryEntry) => Padding(
                            padding:
                            EdgeInsets.only(bottom: 4),
                            child: Row(children: [
                              Expanded(
                                child: Text(
                                  "• ${primaryEntry.key}: ${primaryEntry.value.join(', ')}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                      Color(0xFF6B7280)),
                                ),
                              ),
                              if (controller.selectedVariantType
                                  .value ==
                                  typeEntry.key)
                                GestureDetector(
                                  onTap: () => controller
                                      .removePrimaryValue(
                                      primaryEntry.key),
                                  child: Icon(
                                      Icons.delete_outline,
                                      size: 16,
                                      color: Colors.red),
                                ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 16),
              ],
            );
          }),

          // Variant type dropdown
          Obx(() => Container(
            decoration: BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Color(0xFFE5E7EB))),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.category,
                      color: Color(0xFF6B7280), size: 20),
                  hintText:
                  "Select variant type (e.g., Color, Size)",
                  hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14)),
              value: controller
                  .selectedVariantType.value.isEmpty
                  ? null
                  : controller.selectedVariantType.value,
              items: config.variantAttributes
                  .map((attr) => DropdownMenuItem(
                  value: attr,
                  child: Text(attr,
                      style:
                      TextStyle(fontSize: 15))))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.onVariantTypeSelected(value);
                }
              },
              dropdownColor: Colors.white,
              icon: Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFF6B7280)),
            ),
          )),

          Obx(() =>
          controller.selectedVariantType.value.isNotEmpty
              ? Column(children: [
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            _buildVariantValueConfiguration(),
          ])
              : SizedBox.shrink()),

          Obx(() {
            final canGenerate =
                controller.variantTypeConfigurations.isNotEmpty;
            final isAtLimit =
                controller.variants.length >= 10;
            if (!canGenerate) return SizedBox.shrink();
            return Column(
              children: [
                SizedBox(height: 16),
                if (isAtLimit)
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color: Color(0xFFEF4444)
                                .withOpacity(0.3))),
                    child: Row(children: [
                      Icon(Icons.error_outline,
                          color: Color(0xFFEF4444),
                          size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                            "Cannot generate. Maximum 10 products limit reached.",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEF4444),
                                fontWeight:
                                FontWeight.w500)),
                      ),
                    ]),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isAtLimit
                        ? null
                        : controller
                        .generateVariantsFromConfiguration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAtLimit
                          ? Colors.grey
                          : Color(0xFF10B981),
                      padding: EdgeInsets.symmetric(
                          vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12)),
                      disabledBackgroundColor:
                      Colors.grey.shade300,
                    ),
                    icon: Icon(Icons.auto_awesome),
                    label: Text(
                        isAtLimit
                            ? "Limit Reached"
                            : "Generate All Variants",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ─── VARIANT VALUE CONFIGURATION ─────────────────────────────────────
  Widget _buildVariantValueConfiguration() {
    return Obx(() {
      final variantType = controller.selectedVariantType.value;
      final primarySelected =
          controller.currentPrimaryValue.value.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Step 1: Add $variantType Value",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A))),
          SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border:
                    Border.all(color: Color(0xFFE5E7EB))),
                child: TextField(
                  controller:
                  controller.primaryValueController,
                  decoration: InputDecoration(
                      hintText: "e.g., Green, Blue",
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9CA3AF)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12)),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      controller
                          .addPrimaryValue(value.trim());
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final value = controller
                    .primaryValueController.text
                    .trim();
                if (value.isNotEmpty)
                  controller.addPrimaryValue(value);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3B82F6),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8))),
              child: Text("Add",
                  style: TextStyle(
                      fontWeight: FontWeight.w600)),
            ),
          ]),

          if (primarySelected) ...[
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color:
                  Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Color(0xFF3B82F6)
                          .withOpacity(0.3))),
              child: Row(children: [
                Icon(Icons.check_circle,
                    color: Color(0xFF3B82F6), size: 20),
                SizedBox(width: 8),
                Text(
                    "Selected: ${controller.currentPrimaryValue.value}",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3B82F6))),
              ]),
            ),
            SizedBox(height: 20),
            Text(
                "Step 2: Add Values for ${controller.currentPrimaryValue.value}",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A))),
            SizedBox(height: 8),
            Text(
                "e.g., For Green add 'S'; For Blue add 'M', 'L', 'XL'",
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280))),
            SizedBox(height: 12),
            if (controller.currentSecondaryValues.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border:
                    Border.all(color: Color(0xFFE5E7EB))),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.currentSecondaryValues
                      .map((value) => Chip(
                    label: Text(value),
                    deleteIcon:
                    Icon(Icons.close, size: 18),
                    onDeleted: () => controller
                        .removeSecondaryValue(value),
                    backgroundColor: Color(0xFF3B82F6)
                        .withOpacity(0.1),
                    labelStyle: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.w500),
                  ))
                      .toList(),
                ),
              ),
            Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius:
                      BorderRadius.circular(8),
                      border: Border.all(
                          color: Color(0xFFE5E7EB))),
                  child: TextField(
                    controller:
                    controller.secondaryValueController,
                    decoration: InputDecoration(
                        hintText: "e.g., S",
                        hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9CA3AF)),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12)),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        controller
                            .addSecondaryValue(value.trim());
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final value = controller
                      .secondaryValueController.text
                      .trim();
                  if (value.isNotEmpty)
                    controller.addSecondaryValue(value);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(8))),
                child: Text("Add",
                    style: TextStyle(
                        fontWeight: FontWeight.w600)),
              ),
            ]),
            SizedBox(height: 16),
            if (controller.currentSecondaryValues.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                  controller.savePrimaryWithSecondary,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF10B981),
                      padding: EdgeInsets.symmetric(
                          vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12))),
                  icon: Icon(Icons.save),
                  label: Text("Save Configuration",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
              ),
          ],
        ],
      );
    });
  }

  // ─── VARIANTS HEADER ─────────────────────────────────────────────────
  Widget _buildVariantsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product Variants",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A))),
            Obx(() {
              final count = controller.variants.length;
              return Text("$count variant(s) for this product",
                  style: TextStyle(
                      fontSize: 13,
                      color: count >= 10
                          ? Color(0xFFEF4444)
                          : Color(0xFF6B7280),
                      fontWeight: count >= 10
                          ? FontWeight.w600
                          : FontWeight.normal));
            }),
          ],
        ),
      ],
    );
  }

  // ─── VARIANT CARD ────────────────────────────────────────────────────
  Widget _buildVariantCard(BuildContext context, int index,
      OfferProductVariant variant) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF3B82F6).withOpacity(0.05),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)),
            ),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Variant ${index + 1}",
                        style: TextStyle(
                            color: Color(0xFF3B82F6),
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    SizedBox(height: 4),
                    Text(variant.getDisplayName(),
                        style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: Color(0xFFEF4444), size: 20),
                onPressed: () =>
                    _showDeleteDialog(context, index),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePicker(context, index, variant),
                SizedBox(height: 20),
                Row(children: [
                  Expanded(
                      child:
                      _buildPriceField(variant, index)),
                  SizedBox(width: 12),
                  Expanded(
                      child: _buildStockField(variant)),
                ]),
                if (variant.attributes.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text("Variant Attributes",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A))),
                  SizedBox(height: 12),
                  ...variant.attributes.entries.map(
                          (entry) => Padding(
                        padding:
                        EdgeInsets.only(bottom: 12),
                        child: _buildVariantAttributeField(
                            entry.key, entry.value),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── PRICE FIELD ─────────────────────────────────────────────────────
  Widget _buildPriceField(
      OfferProductVariant variant, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Color(0xFF10B981).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color:
                  Color(0xFF10B981).withOpacity(0.3))),
          child: TextField(
            key: Key('price_$index'),
            controller: TextEditingController(
                text: variant.price?.toString() ?? ''),
            onChanged: (val) => controller.updateVariantPrice(
                index, double.tryParse(val)),
            keyboardType:
            TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              labelText: "Original Price (₹)",
              hintText: "0.00",
              prefixIcon: Icon(Icons.currency_rupee,
                  color: Color(0xFF10B981), size: 18),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 12, vertical: 12),
              labelStyle: TextStyle(
                  fontSize: 12, color: Color(0xFF10B981)),
            ),
          ),
        ),
        SizedBox(height: 8),
        Obx(() {
          final _ = controller.variants.length;
          final offerPrice = variant.offerPrice;
          final discount =
              controller.discountPercentageCtrl.text;
          if (offerPrice != null &&
              variant.price != null &&
              variant.price! > 0) {
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: Color(0xFFF59E0B)
                          .withOpacity(0.3))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_offer,
                      color: Color(0xFFF59E0B), size: 12),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      "₹${offerPrice.toStringAsFixed(0)} ($discount% off)",
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF59E0B)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        }),
      ],
    );
  }

  // ─── STOCK FIELD ─────────────────────────────────────────────────────
  Widget _buildStockField(OfferProductVariant variant) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFF3B82F6).withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: Color(0xFF3B82F6).withOpacity(0.3))),
      child: TextField(
        controller: TextEditingController(
            text: variant.stock?.toString() ?? ''),
        onChanged: (val) {
          variant.stock = int.tryParse(val);
          controller.variants.refresh();
        },
        keyboardType: TextInputType.number,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: "Stock",
          hintText: "0",
          prefixIcon: Icon(Icons.inventory_outlined,
              color: Color(0xFF3B82F6), size: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 12, vertical: 12),
          labelStyle: TextStyle(
              fontSize: 12, color: Color(0xFF3B82F6)),
        ),
      ),
    );
  }

  // ─── VARIANT ATTRIBUTE FIELD (read-only) ─────────────────────────────
  Widget _buildVariantAttributeField(
      String attribute, String value) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFE5E7EB))),
      child: TextField(
        controller: TextEditingController(text: value),
        enabled: false,
        style: TextStyle(
            fontSize: 14, color: Color(0xFF6B7280)),
        decoration: InputDecoration(
          labelText: attribute,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 12, vertical: 12),
          labelStyle: TextStyle(
              fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ),
    );
  }

  // ─── IMAGE PICKER ────────────────────────────────────────────────────
  Widget _buildImagePicker(BuildContext context, int index,
      OfferProductVariant variant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Image",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A))),
        SizedBox(height: 12),
        Obx(() {
          final imagePath = index < controller.variants.length
              ? controller.variants[index].imagePath
              : null;
          return GestureDetector(
            onTap: () => controller.pickImage(index),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Color(0xFFE5E7EB), width: 2)),
              child: imagePath == null
                  ? Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: Color(0xFF3B82F6)),
                  SizedBox(height: 8),
                  Text("Tap to add image",
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280))),
                ],
              )
                  : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(10),
                    child: Image.file(File(imagePath),
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2),
                                blurRadius: 8)
                          ]),
                      child: IconButton(
                        icon: Icon(Icons.edit,
                            color: Color(0xFF3B82F6),
                            size: 18),
                        onPressed: () =>
                            controller.pickImage(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── SHARED HELPERS ──────────────────────────────────────────────────
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Color(0xFF3B82F6), size: 20),
        ),
        SizedBox(width: 12),
        Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A))),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE5E7EB))),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(
            fontSize: 15, color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon:
          Icon(icon, color: Color(0xFF6B7280), size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 16),
          labelStyle: TextStyle(
              color: Color(0xFF6B7280), fontSize: 14),
          hintStyle: TextStyle(
              color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Icon(Icons.warning_amber_rounded,
              color: Color(0xFFEF4444)),
          SizedBox(width: 12),
          Text("Remove Variant?"),
        ]),
        content: Text(
            "Are you sure you want to remove this variant?",
            style: TextStyle(
                fontSize: 14, color: Color(0xFF6B7280))),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              controller.removeVariant(index);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444)),
            child: Text("Remove"),
          ),
        ],
      ),
    );
  }

  void _saveOfferProduct(BuildContext context) {
    if (controller.totalProductsAdded.value >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
                child: Text("Maximum 10 products limit reached!",
                    style: TextStyle(
                        fontWeight: FontWeight.w500))),
          ]),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    controller.saveOfferProduct();
  }
}