
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/utils/validators.dart';
import '../controller/addevent_controller.dart';

class AddEventPage extends StatelessWidget {
  AddEventPage({super.key});
  final AddEventController controller = Get.put(AddEventController());

  static const Color _teal          = Color(0xFF00897B);
  static const Color _bg            = Color(0xFFF5F6FA);
  static const Color _card          = Colors.white;
  static const Color _textPrimary   = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _border        = Color(0xFFE5E7EB);
  static const Color _errorColor    = Color(0xFFEF5350);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: NetworkAwareWrapper(child:Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor:AppColors.kPrimary,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "Add Event",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
        body: Stack(
          children: [
            // ── Wrap entire scroll in a Form ──────────────────
            Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Event Details Card ────────────────────
                    _sectionCard(
                      title: "EVENT DETAILS",
                      icon: Icons.info_outline_rounded,
                      children: [
                        _fieldLabel("Event Name"),
                        const SizedBox(height: 6),
                        // DValidator runs on form submit & on user typing
                        _validatedField(
                          controller: controller.eventName,
                          hint: "e.g. Annual Tech Summit",
                          icon: Icons.title_rounded,
                          validator: (v) =>
                              DValidator.validateEmptyText("Event name", v),
                        ),
                        const SizedBox(height: 16),
                        _fieldLabel("Event Location"),
                        const SizedBox(height: 6),
                        _validatedField(
                          controller: controller.eventLocation,
                          hint: "e.g. City Convention Hall",
                          icon: Icons.place_outlined,
                          validator: (v) =>
                              DValidator.validateEmptyText("Event location", v),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Event Coverage Card ───────────────────
                    _sectionCard(
                      title: "EVENT COVERAGE",
                      icon: Icons.map_outlined,
                      children: [_buildAreaDistrictSection()],
                    ),

                    const SizedBox(height: 14),

                    // ── Schedule Card ─────────────────────────
                    _sectionCard(
                      title: "SCHEDULE",
                      icon: Icons.calendar_month_outlined,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildStartDatePicker(context)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildEndDatePicker(context)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildStartTimePicker(context)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildEndTimePicker(context)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Banner Card ───────────────────────────
                    _sectionCard(
                      title: "EVENT BANNER",
                      icon: Icons.image_outlined,
                      children: [_buildBanner()],
                    ),
                  ],
                ),
              ),
            ),

            // ── Sticky Submit ─────────────────────────────────
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildSubmitButton(),
            ),

            // ── Loading Overlay ───────────────────────────────
            Obx(() => controller.isLoading.value
                ? Container(
              color: Colors.black45,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                          color: _teal, strokeWidth: 2.5),
                      SizedBox(height: 16),
                      Text(
                        "Creating event…",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    ));
  }

  // ─────────────────────────────────────────────────────────
  // DATE / TIME PICKER WRAPPERS
  // Each returns a Column: [tile] + optional inline error text
  // ─────────────────────────────────────────────────────────

  Widget _buildStartDatePicker(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.pickDate(context),
          child: _pickerTile(
            label: "Start Date",
            value: controller.eventDate.value,
            icon: Icons.calendar_today_rounded,
            hasError: controller.errorStartDate.value != null,
          ),
        ),
        _inlineError(controller.errorStartDate.value),
      ],
    ));
  }

  Widget _buildEndDatePicker(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.pickEndDate(context),
          child: _pickerTile(
            label: "End Date",
            value: controller.eventEndDate.value,
            icon: Icons.event_rounded,
            hasError: controller.errorEndDate.value != null,
          ),
        ),
        _inlineError(controller.errorEndDate.value),
      ],
    ));
  }

  Widget _buildStartTimePicker(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.pickStartTime(context),
          child: _pickerTile(
            label: "Start Time",
            value: controller.eventStartTime.value,
            icon: Icons.access_time_rounded,
            hasError: controller.errorStartTime.value != null,
          ),
        ),
        _inlineError(controller.errorStartTime.value),
      ],
    ));
  }

  Widget _buildEndTimePicker(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.pickEndTime(context),
          child: _pickerTile(
            label: "End Time",
            value: controller.eventEndTime.value,
            icon: Icons.access_time_filled_rounded,
            hasError: controller.errorEndTime.value != null,
          ),
        ),
        _inlineError(controller.errorEndTime.value),
      ],
    ));
  }

  // ─────────────────────────────────────────────────────────
  // AREA / DISTRICT SECTION
  // ─────────────────────────────────────────────────────────
  Widget _buildAreaDistrictSection() {
    return Obx(() {
      final isArea = controller.showMode.value == "area";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Toggle tabs ───────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                _modeTab(
                  label: "District Wise",
                  icon: Icons.location_city_rounded,
                  selected: !isArea,
                  onTap: () {
                    controller.showMode.value = "district";
                    controller.selectedArea.value = null;
                    controller.errorArea.value    = null;
                  },
                ),
                _modeTab(
                  label: "Area Wise",
                  icon: Icons.grid_view_rounded,
                  selected: isArea,
                  onTap: () => controller.showMode.value = "area",
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── State ─────────────────────────────────────────
          _fieldLabel("Select State"),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isLoadingStates.value) {
              return _loadingDropdown("Loading states…");
            }
            if (controller.stateList.isEmpty) {
              return _emptyDropdown("No states available");
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dropdownField(
                  value: controller.selectedState.value,
                  hint: "Choose a state",
                  icon: Icons.flag_outlined,
                  items: controller.stateList,
                  hasError: controller.errorState.value != null,
                  onChanged: (val) {
                    controller.selectedState.value = val;
                    controller.errorState.value    = null;
                  },
                ),
                _inlineError(controller.errorState.value),
              ],
            );
          }),

          const SizedBox(height: 14),

          // ── District ──────────────────────────────────────
          _fieldLabel("Select District"),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isLoadingDistricts.value) {
              return _loadingDropdown("Loading districts…");
            }
            if (controller.districtList.isEmpty) {
              return _emptyDropdown("No districts available");
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dropdownField(
                  value: controller.selectedDistrict.value,
                  hint: "Choose a district",
                  icon: Icons.location_city_rounded,
                  items: controller.districtList,
                  hasError: controller.errorDistrict.value != null,
                  onChanged: (val) {
                    controller.selectedDistrict.value = val;
                    controller.errorDistrict.value    = null;
                  },
                ),
                _inlineError(controller.errorDistrict.value),
              ],
            );
          }),

          // ── Area (area mode only) ─────────────────────────
          if (isArea) ...[
            const SizedBox(height: 14),
            _fieldLabel("Select Area"),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoadingAreas.value) {
                return _loadingDropdown("Loading areas…");
              }
              if (controller.areaList.isEmpty) {
                return _emptyDropdown("No areas available");
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dropdownField(
                    value: controller.selectedArea.value,
                    hint: "Choose an area",
                    icon: Icons.grid_view_rounded,
                    items: controller.areaList,
                    hasError: controller.errorArea.value != null,
                    onChanged: (val) {
                      controller.selectedArea.value = val;
                      controller.errorArea.value    = null;
                    },
                  ),
                  _inlineError(controller.errorArea.value),
                ],
              );
            }),
          ],

          const SizedBox(height: 10),
        ],
      );
    });
  }

  // ─────────────────────────────────────────────────────────
  // BANNER  (fixed 16:9 ratio, matches home card)
  // ─────────────────────────────────────────────────────────
  Widget _buildBanner() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: controller.pickBannerImage,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: controller.errorBanner.value != null
                    ? _errorColor
                    : controller.bannerImage.value != null
                    ? _teal.withOpacity(0.45)
                    : _border,
                width: 1.4,
              ),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: controller.bannerImage.value == null
                    ? _bannerPlaceholder()
                    : _bannerPreview(),
              ),
            ),
          ),
        ),
        // Inline error under banner box
        _inlineError(controller.errorBanner.value),
      ],
    ));
  }

  Widget _bannerPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: _teal.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add_photo_alternate_outlined,
              color: _teal, size: 26),
        ),
        const SizedBox(height: 10),
        const Text("Tap to upload banner",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textPrimary)),
        const SizedBox(height: 3),
        const Text("Recommended: 16 : 9 ratio",
            style: TextStyle(fontSize: 11, color: _textSecondary)),
      ],
    );
  }

  Widget _bannerPreview() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            controller.bannerImage.value!,
            fit: BoxFit.cover,
          ),
        ),
        // Remove button
        Positioned(
          top: 8, right: 8,
          child: GestureDetector(
            onTap: controller.removeBannerImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.12), blurRadius: 6)
                ],
              ),
              child: const Icon(Icons.close_rounded,
                  size: 14, color: Colors.red),
            ),
          ),
        ),
        // Badge
        Positioned(
          bottom: 8, left: 8,
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1), blurRadius: 6)
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, size: 12, color: _teal),
                SizedBox(width: 4),
                Text("Banner selected",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // SHARED UI COMPONENTS
  // ─────────────────────────────────────────────────────────

  /// Small red error text — shown inline under a field.
  /// Renders nothing when [error] is null.
  Widget _inlineError(String? error) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 4),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 12, color: _errorColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              error,
              style: const TextStyle(
                  fontSize: 11,
                  color: _errorColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeTab({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _teal : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: selected ? Colors.white : _textSecondary),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : _textSecondary,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool hasError = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasError
              ? _errorColor
              : value != null
              ? _teal.withOpacity(0.45)
              : _border,
          width: hasError || value != null ? 1.4 : 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Icon(icon, size: 16, color: _textSecondary),
                const SizedBox(width: 8),
                Text(hint,
                    style: const TextStyle(
                        fontSize: 14, color: _textSecondary)),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.circular(10),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: _textSecondary, size: 20),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(children: [
                Icon(icon, size: 15, color: _teal),
                const SizedBox(width: 8),
                Text(item,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _textPrimary)),
              ]),
            );
          }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: (context) => items.map((item) {
            return Row(children: [
              Icon(icon, size: 16, color: _teal),
              const SizedBox(width: 8),
              Text(item,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _loadingDropdown(String msg) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child:
            CircularProgressIndicator(strokeWidth: 2, color: _teal),
          ),
          const SizedBox(width: 10),
          Text(msg,
              style: const TextStyle(
                  fontSize: 13, color: _textSecondary)),
        ],
      ),
    );
  }

  Widget _emptyDropdown(String msg) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Center(
        child: Text(msg,
            style: const TextStyle(
                fontSize: 13, color: _textSecondary)),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 14, color: _teal),
            const SizedBox(width: 6),
            Text(title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _teal,
                  letterSpacing: 0.8,
                )),
          ]),
          const SizedBox(height: 4),
          Divider(color: _border, height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _textPrimary),
  );

  /// TextField wrapped in TextFormField so DValidator hooks into the Form.
  Widget _validatedField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
          fontSize: 14,
          color: _textPrimary,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        const TextStyle(fontSize: 14, color: _textSecondary),
        prefixIcon: Icon(icon, color: _textSecondary, size: 18),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        filled: true,
        fillColor: _bg,
        // error styling consistent with the rest of the form
        errorStyle: const TextStyle(
            fontSize: 11,
            color: _errorColor,
            fontWeight: FontWeight.w500),
        errorMaxLines: 2,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _teal, width: 1.6)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            const BorderSide(color: _errorColor, width: 1.4)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            const BorderSide(color: _errorColor, width: 1.6)),
      ),
    );
  }

  Widget _pickerTile({
    required String label,
    required String value,
    required IconData icon,
    bool hasError = false,
  }) {
    final bool has = value.isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasError
              ? _errorColor
              : has
              ? _teal.withOpacity(0.45)
              : _border,
          width: hasError || has ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: hasError
                  ? _errorColor
                  : has
                  ? _teal
                  : _textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _textSecondary,
                      letterSpacing: 0.3,
                    )),
                const SizedBox(height: 2),
                Text(
                  has ? value : "Select",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: has ? _textPrimary : _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              size: 15, color: _textSecondary),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() => SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.saveEvent,
            child: const Text(
              "Create Event",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3),
            ),
          ),
        )),
      ),
    );
  }
}