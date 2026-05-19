
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/merchant_model.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class AdminMerchantController extends GetxController {
  final box = GetStorage();

  var merchants = <AdminMerchant>[].obs;
  var isLoading = false.obs;
  var isExcelGenerating = false.obs;

  Map<String, String> _headers() {
    final token = box.read("auth_token") ?? '';
    return {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  @override
  void onInit() {
    super.onInit();
    fetchMerchants();
  }

  // ── FETCH MERCHANTS ────────────────────────────────────────────
  Future<void> fetchMerchants() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("https://entenaadu.co.in/api/admin/merchants"),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          merchants.value = (body['data'] as List)
              .map((e) => AdminMerchant.fromJson(e))
              .toList();
        } else {
          AppSnackbar.error(body['message'] ?? "Failed to load merchants");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ── DELETE MERCHANT ────────────────────────────────────────────
  Future<void> deleteMerchant(int merchantId) async {
    try {
      isLoading.value = true;

      final response = await http.delete(
        Uri.parse("https://entenaadu.co.in/api/admin/delete-merchant"),
        headers: {
          ..._headers(),
          "Content-Type": "application/json",
        },
        body: jsonEncode({"merchant_id": merchantId}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        merchants.removeWhere((e) => e.id == merchantId);
        AppSnackbar.success(body['message'] ?? "Merchant deleted successfully");
      } else {
        AppSnackbar.error(body['message'] ?? "Failed to delete merchant");
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ── EXCEL DOWNLOAD ─────────────────────────────────────────────
  Future<void> downloadMerchantsExcel() async {
    if (isExcelGenerating.value) return;

    try {
      isExcelGenerating.value = true;

      final workbook = xlsio.Workbook();

      // ── Styles ──────────────────────────────────────────────────
      final titleStyle      = workbook.styles.add('TitleStyle');
      titleStyle.bold       = true;
      titleStyle.fontSize   = 14;
      titleStyle.backColor  = '#1565C0';
      titleStyle.fontColor  = '#FFFFFF';

      final headerStyle     = workbook.styles.add('HeaderStyle');
      headerStyle.bold      = true;
      headerStyle.fontSize  = 10;
      headerStyle.backColor = '#1565C0';
      headerStyle.fontColor = '#FFFFFF';
      headerStyle.wrapText  = true;

      final metaLabelStyle      = workbook.styles.add('MetaLabel');
      metaLabelStyle.bold       = true;
      metaLabelStyle.backColor  = '#E3F2FD';

      final metaValueStyle      = workbook.styles.add('MetaValue');
      metaValueStyle.backColor  = '#E3F2FD';

      final evenStyle      = workbook.styles.add('EvenRow');
      evenStyle.backColor  = '#F5F5F5';

      final oddStyle      = workbook.styles.add('OddRow');
      oddStyle.backColor  = '#FFFFFF';

      // ── Sheet 1 : Summary ────────────────────────────────────────
      final summarySheet = workbook.worksheets[0];
      summarySheet.name  = 'Summary';
      summarySheet.setColumnWidthInPixels(1, 200);
      summarySheet.setColumnWidthInPixels(2, 320);

      summarySheet.getRangeByIndex(1, 1).setText('All Merchants Report');
      summarySheet.getRangeByIndex(1, 1).cellStyle = titleStyle;

      final approvedCount  = merchants
          .where((m) => m.approvalStatus == 'approved')
          .length;
      final pendingCount   = merchants
          .where((m) => m.approvalStatus == 'pending')
          .length;
      final rejectedCount  = merchants
          .where((m) => m.approvalStatus == 'rejected')
          .length;

      _summaryRow(summarySheet, 2,
          'Generated on', DateTime.now().toString(),
          metaLabelStyle, metaValueStyle);
      _summaryRow(summarySheet, 3,
          'Total Merchants', merchants.length.toString(),
          metaLabelStyle, metaValueStyle);
      _summaryRow(summarySheet, 4,
          'Approved Merchants', approvedCount.toString(),
          metaLabelStyle, metaValueStyle);
      _summaryRow(summarySheet, 5,
          'Pending Merchants', pendingCount.toString(),
          metaLabelStyle, metaValueStyle);
      _summaryRow(summarySheet, 6,
          'Rejected Merchants', rejectedCount.toString(),
          metaLabelStyle, metaValueStyle);

      // ── Sheet 2 : Merchant Details ───────────────────────────────
      final detailSheet = workbook.worksheets.addWithName('Merchant Details');

      const headers = [
        'ID', 'Shop Name', 'Email', 'Main Location', 'Approval Status',
      ];

      for (var i = 0; i < headers.length; i++) {
        final cell     = detailSheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle = headerStyle;
      }

      const colWidths = [60, 200, 240, 200, 140];
      for (var i = 0; i < colWidths.length; i++) {
        detailSheet.setColumnWidthInPixels(i + 1, colWidths[i]);
      }

      int  row       = 2;
      bool alternate = false;

      for (final m in merchants) {
        final rowStyle = alternate ? evenStyle : oddStyle;

        final values = [
          m.id.toString(),
          m.shopName,
          m.email,
          m.mainLocation,
          m.approvalStatus,
        ];

        for (var col = 0; col < values.length; col++) {
          final cell     = detailSheet.getRangeByIndex(row, col + 1);
          cell.setText(values[col]);
          cell.cellStyle = rowStyle;
        }

        row++;
        alternate = !alternate;
      }

      // ── Save & open ──────────────────────────────────────────────
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final dir  = await getApplicationDocumentsDirectory();
      final ts   = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/merchants_$ts.xlsx');
      await file.writeAsBytes(bytes);

      isExcelGenerating.value = false;

      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        AppSnackbar.error('Could not open Excel file: ${result.message}');
      }
    } catch (e) {
      isExcelGenerating.value = false;
      AppSnackbar.error('Excel generation failed: $e');
    }
  }

  void _summaryRow(
      xlsio.Worksheet sheet,
      int rowIndex,
      String label,
      String value,
      xlsio.Style labelStyle,
      xlsio.Style valueStyle,
      ) {
    sheet.getRangeByIndex(rowIndex, 1)
      ..setText(label)
      ..cellStyle = labelStyle;
    sheet.getRangeByIndex(rowIndex, 2)
      ..setText(value)
      ..cellStyle = valueStyle;
  }
}
