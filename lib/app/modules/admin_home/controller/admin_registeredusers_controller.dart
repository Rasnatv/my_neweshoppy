// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/errors/api_error.dart';
// import '../../merchantlogin/widget/successwidget.dart';
//
// class AdminUserController extends GetxController {
//   var users = <Map<String, dynamic>>[].obs;
//   var isLoading = false.obs;
//
//   final box = GetStorage();
//
//   String get authToken => box.read('auth_token') ?? "";
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUsers();
//   }
//
//   Future<void> fetchUsers() async {
//
//
//     isLoading.value = true;
//
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "https://eshoppy.co.in/api/admin/users",
//         ),
//         headers: {
//           "Authorization": "Bearer $authToken",
//           "Accept": "application/json",
//         },
//       );
//
//       final body = jsonDecode(response.body);
//
//       /// ✅ Success (same logic)
//       if (response.statusCode == 200 &&
//           (body["status"] == 1 || body["status"] == "1")) {
//         users.value = List<Map<String, dynamic>>.from(
//           body["data"].map((user) {
//             return {
//               "id": int.tryParse(user["user_id"].toString()) ?? 0,
//               "name": user["full_name"] ?? "",
//               "email": user["email"] ?? "",
//               "phone": user["phone"] ?? "",
//               "address": user["address"] ?? "-",
//               "regDate": user["registered_on"] ?? "-",
//             };
//           }),
//         );
//       } else {
//         /// ✅ API Error Handler
//         final errorMessage = ApiErrorHandler.handleResponse(response);
//         AppSnackbar.error(errorMessage);
//       }
//     } catch (e) {
//       /// ✅ Exception Handling
//       final errorMessage = ApiErrorHandler.handleException(e);
//       AppSnackbar.error(errorMessage);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void deleteUser(int index) {
//     users.removeAt(index);
//
//     /// ✅ Snackbar updated
//     AppSnackbar.success("User removed successfully");
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class AdminUserController extends GetxController {
  var users           = <Map<String, dynamic>>[].obs;
  var isLoading       = false.obs;
  var isPdfGenerating  = false.obs;
  var isExcelGenerating = false.obs;

  final box = GetStorage();

  String get authToken => box.read('auth_token') ?? "";

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // ─────────────────────────────────────────────────────────────
  //  FETCH USERS
  // ─────────────────────────────────────────────────────────────
  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("https://eshoppy.co.in/api/admin/users"),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (body["status"] == 1 || body["status"] == "1")) {
        users.value = List<Map<String, dynamic>>.from(
          body["data"].map((user) {
            return {
              "id": int.tryParse(user["user_id"].toString()) ?? 0,
              "name": user["full_name"] ?? "",
              "email": user["email"] ?? "",
              "phone": user["phone"] ?? "",
              "address": user["address"] ?? "-",
              "regDate": user["registered_on"] ?? "-",
            };
          }),
        );
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  void deleteUser(int index) {
    users.removeAt(index);
    AppSnackbar.success("User removed successfully");
  }

  // ─────────────────────────────────────────────────────────────
  //  EXCEL EXPORT
  // ─────────────────────────────────────────────────────────────
  Future<void> downloadUsersExcel() async {
    if (isExcelGenerating.value) return;
    try {
      isExcelGenerating.value = true;

      final workbook = xlsio.Workbook();

      // ── Styles ────────────────────────────────────────────────
      final titleStyle      = workbook.styles.add('Title');
      titleStyle.bold       = true;
      titleStyle.fontSize   = 14;
      titleStyle.backColor  = '#00695C';
      titleStyle.fontColor  = '#FFFFFF';

      final headerStyle     = workbook.styles.add('Header');
      headerStyle.bold      = true;
      headerStyle.fontSize  = 10;
      headerStyle.backColor = '#00695C';
      headerStyle.fontColor = '#FFFFFF';
      headerStyle.wrapText  = true;

      final metaLabelStyle      = workbook.styles.add('MetaLabel');
      metaLabelStyle.bold       = true;
      metaLabelStyle.backColor  = '#E0F2F1';

      final metaValueStyle      = workbook.styles.add('MetaValue');
      metaValueStyle.backColor  = '#E0F2F1';

      final evenStyle     = workbook.styles.add('Even');
      evenStyle.backColor = '#F5F5F5';

      final oddStyle     = workbook.styles.add('Odd');
      oddStyle.backColor = '#FFFFFF';

      // ── Sheet 1 : Summary ─────────────────────────────────────
      final summarySheet = workbook.worksheets[0];
      summarySheet.name  = 'Summary';
      summarySheet.setColumnWidthInPixels(1, 200);
      summarySheet.setColumnWidthInPixels(2, 320);

      summarySheet.getRangeByIndex(1, 1).setText('Registered Users Report');
      summarySheet.getRangeByIndex(1, 1).cellStyle = titleStyle;

      _summaryRow(summarySheet, 2, 'Generated on',
          _formatNow(), metaLabelStyle, metaValueStyle);
      _summaryRow(summarySheet, 3, 'Total Users',
          users.length.toString(), metaLabelStyle, metaValueStyle);

      // ── Sheet 2 : User Details ────────────────────────────────
      final detailSheet = workbook.worksheets.addWithName('User Details');

      const headers = [
        'No.', 'User ID', 'Full Name', 'Email',
        'Phone', 'Address', 'Registered On',
      ];

      for (var i = 0; i < headers.length; i++) {
        final cell     = detailSheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle = headerStyle;
      }

      const colWidths = [50, 80, 160, 220, 120, 260, 140];
      for (var i = 0; i < colWidths.length; i++) {
        detailSheet.setColumnWidthInPixels(i + 1, colWidths[i]);
      }

      for (var idx = 0; idx < users.length; idx++) {
        final user     = users[idx];
        final rowIndex = idx + 2;
        final rowStyle = (idx % 2 == 0) ? evenStyle : oddStyle;

        final values = [
          (idx + 1).toString(),
          user['id'].toString(),
          user['name'].toString(),
          user['email'].toString(),
          user['phone'].toString(),
          user['address'].toString(),
          user['regDate'].toString(),
        ];

        for (var col = 0; col < values.length; col++) {
          final cell     = detailSheet.getRangeByIndex(rowIndex, col + 1);
          cell.setText(values[col]);
          cell.cellStyle = rowStyle;
        }
      }

      // ── Save & open ───────────────────────────────────────────
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final dir  = await getApplicationDocumentsDirectory();
      final ts   = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/users_$ts.xlsx');
      await file.writeAsBytes(bytes);

      isExcelGenerating.value = false;

      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        AppSnackbar.error('Could not open Excel: ${result.message}');
      }
    } catch (e) {
      isExcelGenerating.value = false;
      AppSnackbar.error('Excel generation failed: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  PDF EXPORT
  // ─────────────────────────────────────────────────────────────
  Future<void> downloadUsersPdf() async {
    if (isPdfGenerating.value) return;
    try {
      isPdfGenerating.value = true;

      final regular = await PdfGoogleFonts.notoSansRegular();
      final bold    = await PdfGoogleFonts.notoSansBold();
      final italic  = await PdfGoogleFonts.notoSansItalic();

      final pdf   = pw.Document();
      final theme = pw.ThemeData.withFont(
        base: regular, bold: bold, italic: italic,
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: theme,
          margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          header: (_) => _pdfHeader(bold: bold, regular: regular),
          footer: (ctx) => _pdfFooter(ctx, regular: regular),
          build: (_) => [
            _pdfSummaryBox(bold: bold, regular: regular),
            pw.SizedBox(height: 20),
            _pdfUserTable(bold: bold, regular: regular),
          ],
        ),
      );

      final dir  = await getApplicationDocumentsDirectory();
      final ts   = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/users_$ts.pdf');
      await file.writeAsBytes(await pdf.save());

      isPdfGenerating.value = false;

      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        AppSnackbar.error('Could not open PDF: ${result.message}');
      }
    } catch (e) {
      isPdfGenerating.value = false;
      AppSnackbar.error('PDF generation failed: $e');
    }
  }

  // ── PDF Header ────────────────────────────────────────────────
  pw.Widget _pdfHeader({
    required pw.Font bold,
    required pw.Font regular,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.teal, width: 1.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Registered Users Report',
                style: pw.TextStyle(
                  font: bold, fontSize: 17,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.teal800,
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                'Eshoppy - Admin Panel',
                style: pw.TextStyle(
                  font: regular, fontSize: 9,
                  color: PdfColors.blueGrey400,
                ),
              ),
            ],
          ),
          pw.Text(
            'Generated: ${_formatNow()}',
            style: pw.TextStyle(
              font: regular, fontSize: 9,
              color: PdfColors.blueGrey400,
            ),
          ),
        ],
      ),
    );
  }

  // ── PDF Footer ────────────────────────────────────────────────
  pw.Widget _pdfFooter(pw.Context ctx, {required pw.Font regular}) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.blueGrey200, width: 1),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Confidential - For internal use only',
            style: pw.TextStyle(
              font: regular, fontSize: 8, color: PdfColors.blueGrey300,
            ),
          ),
          pw.Text(
            'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
            style: pw.TextStyle(
              font: regular, fontSize: 8, color: PdfColors.blueGrey400,
            ),
          ),
        ],
      ),
    );
  }

  // ── PDF Summary Box ───────────────────────────────────────────
  pw.Widget _pdfSummaryBox({
    required pw.Font bold,
    required pw.Font regular,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColors.teal700, PdfColors.teal400],
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
        ),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Column(
            children: [
              pw.Text(
                '${users.length}',
                style: pw.TextStyle(
                  font: bold, fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Total Registered Users',
                style: pw.TextStyle(
                  font: regular, fontSize: 11,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── PDF User Table ────────────────────────────────────────────
  pw.Widget _pdfUserTable({
    required pw.Font bold,
    required pw.Font regular,
  }) {
    const headerBg   = PdfColors.teal700;
    const headerFg   = PdfColors.white;
    const evenBg     = PdfColor(0.96, 0.96, 0.96);
    const oddBg      = PdfColors.white;
    const borderColor = PdfColors.blueGrey100;

    // Column flex widths (total = 20)
    final colFlex = [1, 2, 3, 4, 2, 4, 3];
    final headers  = ['No.', 'ID', 'Name', 'Email', 'Phone', 'Address', 'Reg. Date'];

    pw.Widget cell(
        String text, {
          pw.Font? font,
          double fontSize = 9,
          PdfColor fg = PdfColors.black,
          PdfColor bg = PdfColors.white,
          bool isHeader = false,
        }) {
      return pw.Expanded(
        flex: colFlex[headers.indexOf(isHeader
            ? text
            : text)], // placeholder — handled below
        child: pw.Container(
          color: bg,
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 6, vertical: 7,
          ),
          child: pw.Text(
            text,
            style: pw.TextStyle(
              font: font ?? regular,
              fontSize: fontSize,
              color: fg,
            ),
            maxLines: 2,
          ),
        ),
      );
    }

    // Header row
    pw.Widget headerRow() {
      return pw.Row(
        children: List.generate(headers.length, (i) {
          return pw.Expanded(
            flex: colFlex[i],
            child: pw.Container(
              color: headerBg,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6, vertical: 8,
              ),
              child: pw.Text(
                headers[i],
                style: pw.TextStyle(
                  font: bold, fontSize: 9,
                  color: headerFg,
                ),
              ),
            ),
          );
        }),
      );
    }

    // Data rows
    List<pw.Widget> dataRows() {
      return List.generate(users.length, (idx) {
        final user = users[idx];
        final bg   = idx % 2 == 0 ? evenBg : oddBg;
        final vals = [
          (idx + 1).toString(),
          user['id'].toString(),
          user['name'].toString(),
          user['email'].toString(),
          user['phone'].toString(),
          user['address'].toString(),
          user['regDate'].toString(),
        ];

        return pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: borderColor, width: 0.5),
            ),
          ),
          child: pw.Row(
            children: List.generate(vals.length, (i) {
              return pw.Expanded(
                flex: colFlex[i],
                child: pw.Container(
                  color: bg,
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 6, vertical: 7,
                  ),
                  child: pw.Text(
                    vals[i],
                    style: pw.TextStyle(
                      font: regular, fontSize: 8.5,
                      color: PdfColors.blueGrey800,
                    ),
                    maxLines: 2,
                  ),
                ),
              );
            }),
          ),
        );
      });
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: borderColor),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.ClipRRect(
        horizontalRadius: 8,
        verticalRadius: 8,
        child: pw.Column(
          children: [
            headerRow(),
            ...dataRows(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────────────────────────
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

  String _formatNow() {
    final dt       = DateTime.now();
    const months   = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour     = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute   = dt.minute.toString().padLeft(2, '0');
    final period   = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} '
        '${dt.year}  |  $hour:$minute $period';
  }
}