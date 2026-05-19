
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio; // <-- NEW

import '../../../data/errors/api_error.dart';
import '../../../data/models/merchant_orderrecievedmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class MerchantOrdersController extends GetxController {
  final _box = GetStorage();

  final isLoading         = true.obs;
  final isPdfGenerating   = false.obs;
  final isExcelGenerating = false.obs;
  final orders            = <MerchantOrderModel>[].obs;

  String get _token => _box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchMerchantOrders();
  }

  Future<void> fetchMerchantOrders() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('https://entenaadu.co.in/api/merchant/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          final List data = body['data'] as List;
          orders.value =
              data.map((e) => MerchantOrderModel.fromJson(e)).toList();
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to load orders');
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

  // ─────────────────────────────────────────────────────────────
  //  DATE FORMAT
  // ─────────────────────────────────────────────────────────────
  String formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      final hour = dt.hour > 12
          ? dt.hour - 12
          : dt.hour == 0
          ? 12
          : dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} '
          '${dt.year}  |  $hour:$minute $period';
    } catch (_) {
      return raw;
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  STATS
  // ─────────────────────────────────────────────────────────────
  int    get totalOrdersCount => orders.length;
  double get totalRevenue =>
      orders.fold(0.0, (sum, o) => sum + o.totalAmount);

  // ─────────────────────────────────────────────────────────────
  //  IMAGE FETCHER
  // ─────────────────────────────────────────────────────────────
  Future<pw.MemoryImage?> _fetchImage(String url) async {
    if (url.trim().isEmpty) return null;
    try {
      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) {
        return pw.MemoryImage(res.bodyBytes);
      }
    } catch (_) {}
    return null;
  }

  // ─────────────────────────────────────────────────────────────
  //  EXCEL GENERATION & OPEN  (syncfusion_flutter_xlsio)
  // ─────────────────────────────────────────────────────────────
  Future<void> downloadOrdersExcel() async {
    if (isExcelGenerating.value) return;

    try {
      isExcelGenerating.value = true;

      final workbook = xlsio.Workbook();

      // ── Reusable styles ───────────────────────────────────────
      final titleStyle     = workbook.styles.add('TitleStyle');
      titleStyle.bold      = true;
      titleStyle.fontSize  = 14;
      titleStyle.backColor = '#1565C0';
      titleStyle.fontColor = '#FFFFFF';

      final headerStyle     = workbook.styles.add('HeaderStyle');
      headerStyle.bold      = true;
      headerStyle.fontSize  = 10;
      headerStyle.backColor = '#1565C0';
      headerStyle.fontColor = '#FFFFFF';
      headerStyle.wrapText  = true;

      final metaLabelStyle     = workbook.styles.add('MetaLabel');
      metaLabelStyle.bold      = true;
      metaLabelStyle.backColor = '#E3F2FD';

      final metaValueStyle     = workbook.styles.add('MetaValue');
      metaValueStyle.backColor = '#E3F2FD';

      final evenStyle     = workbook.styles.add('EvenRow');
      evenStyle.backColor = '#F5F5F5';

      final oddStyle     = workbook.styles.add('OddRow');
      oddStyle.backColor = '#FFFFFF';

      // ── Sheet 1 : Summary ─────────────────────────────────────
      final summarySheet = workbook.worksheets[0];
      summarySheet.name  = 'Summary';
      summarySheet.setColumnWidthInPixels(1, 200);
      summarySheet.setColumnWidthInPixels(2, 320);

      summarySheet.getRangeByIndex(1, 1).setText('Merchant Orders Report');
      summarySheet.getRangeByIndex(1, 1).cellStyle = titleStyle;

      _summaryRow(summarySheet, 2,
          'Generated on', formatDate(DateTime.now().toIso8601String()),
          metaLabelStyle, metaValueStyle);
      _summaryRow(summarySheet, 3,
          'Total Orders', totalOrdersCount.toString(),
          metaLabelStyle, metaValueStyle);
      _summaryRow(summarySheet, 4,
          'Total Revenue', 'Rs.${totalRevenue.toStringAsFixed(2)}',
          metaLabelStyle, metaValueStyle);

      // ── Sheet 2 : Order Details ───────────────────────────────
      final detailSheet = workbook.worksheets.addWithName('Order Details');

      const headers = [
        'Order ID', 'Order Date', 'Customer Name', 'Phone',
        'Delivery Address', 'Product Name', 'Variant',
        'Qty', 'Unit Price (Rs.)', 'Original Price (Rs.)',
        'Line Total (Rs.)', 'Order Total (Rs.)', 'Total Products',
      ];

      for (var i = 0; i < headers.length; i++) {
        final cell     = detailSheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle = headerStyle;
      }

      // Column widths in pixels
      const colWidths = [
        100, 220, 160, 120, 280, 220, 180,
        50,  130, 160, 120, 130, 110,
      ];
      for (var i = 0; i < colWidths.length; i++) {
        detailSheet.setColumnWidthInPixels(i + 1, colWidths[i]);
      }

      // Data rows
      int  row       = 2;
      bool alternate = false;

      for (final order in orders) {
        for (final p in order.products) {
          final variant       = p.selectedVariant;
          final unitPrice     = variant?.effectivePrice ?? p.price;
          final originalPrice = variant?.price ?? p.price;
          final variantLabel  =
          (variant != null && variant.attributes.isNotEmpty)
              ? variant.attributes.entries
              .map((e) => '${e.key}: ${e.value}')
              .join(', ')
              : '';

          final rowStyle = alternate ? evenStyle : oddStyle;

          final values = [
            order.orderId.toString(),
            formatDate(order.orderDate),
            order.address.name,
            order.address.phone,
            order.address.address,
            p.productName,
            variantLabel,
            p.quantity.toString(),
            unitPrice.toStringAsFixed(2),
            originalPrice.toStringAsFixed(2),
            p.total.toStringAsFixed(2),
            order.totalAmount.toStringAsFixed(2),
            order.products.length.toString(),
          ];

          for (var col = 0; col < values.length; col++) {
            final cell     = detailSheet.getRangeByIndex(row, col + 1);
            cell.setText(values[col]);
            cell.cellStyle = rowStyle;
          }

          row++;
          alternate = !alternate;
        }
      }

      // ── Save & open ───────────────────────────────────────────
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final dir  = await getApplicationDocumentsDirectory();
      final ts   = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/orders_$ts.xlsx');
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

  /// Writes a label + value pair into [sheet] at [rowIndex] with styles.
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

  // ─────────────────────────────────────────────────────────────
  //  PDF GENERATION & OPEN
  // ─────────────────────────────────────────────────────────────
  Future<void> downloadOrdersPdf() async {
    if (isPdfGenerating.value) return;

    try {
      isPdfGenerating.value = true;

      final regular = await PdfGoogleFonts.notoSansRegular();
      final bold    = await PdfGoogleFonts.notoSansBold();
      final italic  = await PdfGoogleFonts.notoSansItalic();

      final urlSet = <String>{};
      for (final order in orders) {
        for (final p in order.products) {
          final url = (p.selectedVariant?.image.isNotEmpty == true)
              ? p.selectedVariant!.image
              : p.image;
          if (url.trim().isNotEmpty) urlSet.add(url);
        }
      }

      final imageMap = <String, pw.MemoryImage?>{};
      await Future.wait(
        urlSet.map((url) async {
          imageMap[url] = await _fetchImage(url);
        }),
      );

      final pdf   = pw.Document();
      final theme = pw.ThemeData.withFont(
        base:   regular,
        bold:   bold,
        italic: italic,
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
            ...orders.map(
                  (o) => _pdfOrderBlock(
                o, imageMap, bold: bold, regular: regular,
              ),
            ),
          ],
        ),
      );

      final dir  = await getApplicationDocumentsDirectory();
      final ts   = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/orders_$ts.pdf');
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
          bottom: pw.BorderSide(color: PdfColors.blueGrey200, width: 1),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Merchant Orders Report',
                style: pw.TextStyle(
                  font: bold, fontSize: 17,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                'entenaadu - Merchant Panel',
                style: pw.TextStyle(
                  font: regular, fontSize: 9,
                  color: PdfColors.blueGrey400,
                ),
              ),
            ],
          ),
          pw.Text(
            'Generated: ${formatDate(DateTime.now().toIso8601String())}',
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
          colors: [PdfColors.blue700, PdfColors.blue500],
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
        ),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _pdfSummaryCell(
            label: 'Total Orders', value: '$totalOrdersCount',
            bold: bold, regular: regular,
          ),
          pw.Container(width: 1, height: 44, color: PdfColors.white),
          _pdfSummaryCell(
            label: 'Total Revenue',
            value: 'Rs.${totalRevenue.toStringAsFixed(0)}',
            bold: bold, regular: regular,
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfSummaryCell({
    required String label,
    required String value,
    required pw.Font bold,
    required pw.Font regular,
  }) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            font: bold, fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: pw.TextStyle(
            font: regular, fontSize: 10, color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  // ── PDF Order Block ───────────────────────────────────────────
  pw.Widget _pdfOrderBlock(
      MerchantOrderModel order,
      Map<String, pw.MemoryImage?> imageMap, {
        required pw.Font bold,
        required pw.Font regular,
      }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 18),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blueGrey100),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // ── Order Header ──────────────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 14, vertical: 11),
            decoration: const pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.only(
                topLeft:  pw.Radius.circular(10),
                topRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  children: [
                    pw.Container(
                      width: 8, height: 8,
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.blue700,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      'Order #${order.orderId}',
                      style: pw.TextStyle(
                        font: bold, fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  formatDate(order.orderDate),
                  style: pw.TextStyle(
                    font: regular, fontSize: 9,
                    color: PdfColors.blueGrey500,
                  ),
                ),
              ],
            ),
          ),

          // ── Products ──────────────────────────────────────────
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Column(
              children: order.products.map((p) {
                final imageUrl =
                (p.selectedVariant?.image.isNotEmpty == true)
                    ? p.selectedVariant!.image
                    : p.image;
                final img         = imageMap[imageUrl];
                final unitPrice   = p.selectedVariant?.effectivePrice ?? p.price;
                final variant     = p.selectedVariant;
                final hasDiscount = variant != null &&
                    variant.finalPrice != null &&
                    variant.finalPrice! < variant.price;

                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey50,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 58, height: 58,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.blueGrey100,
                          borderRadius: pw.BorderRadius.circular(6),
                        ),
                        child: img != null
                            ? pw.ClipRRect(
                          horizontalRadius: 6,
                          verticalRadius:   6,
                          child: pw.Image(
                            img, width: 58, height: 58,
                            fit: pw.BoxFit.cover,
                          ),
                        )
                            : pw.Center(
                          child: pw.Text(
                            'No\nImage',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: regular, fontSize: 7,
                              color: PdfColors.blueGrey400,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              p.productName,
                              style: pw.TextStyle(
                                font: bold, fontSize: 11,
                                color: PdfColors.blueGrey900,
                              ),
                            ),
                            if (variant != null &&
                                variant.attributes.isNotEmpty) ...[
                              pw.SizedBox(height: 3),
                              pw.Text(
                                variant.attributes.entries
                                    .map((e) => '${e.key}: ${e.value}')
                                    .join('   |   '),
                                style: pw.TextStyle(
                                  font: regular, fontSize: 8,
                                  color: PdfColors.blueGrey500,
                                ),
                              ),
                            ],
                            pw.SizedBox(height: 6),
                            pw.Row(
                              children: [
                                if (hasDiscount) ...[
                                  pw.Text(
                                    'Rs.${variant!.price.toStringAsFixed(0)}',
                                    style: pw.TextStyle(
                                      font: regular, fontSize: 9,
                                      color: PdfColors.blueGrey400,
                                      decoration:
                                      pw.TextDecoration.lineThrough,
                                    ),
                                  ),
                                  pw.SizedBox(width: 5),
                                ],
                                pw.Text(
                                  'Rs.${unitPrice.toStringAsFixed(0)}',
                                  style: pw.TextStyle(
                                    font: regular, fontSize: 10,
                                    color: hasDiscount
                                        ? PdfColors.green700
                                        : PdfColors.blueGrey700,
                                  ),
                                ),
                                pw.Text(
                                  '  x  ${p.quantity}',
                                  style: pw.TextStyle(
                                    font: regular, fontSize: 10,
                                    color: PdfColors.blueGrey500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.Text(
                        'Rs.${p.total.toStringAsFixed(0)}',
                        style: pw.TextStyle(
                          font: bold, fontSize: 12,
                          color: PdfColors.blue800,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          pw.Container(height: 1, color: PdfColors.green100),

          // ── Address + Order Total footer ──────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            decoration: const pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.only(
                bottomLeft:  pw.Radius.circular(10),
                bottomRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Delivery Address',
                        style: pw.TextStyle(
                          font: bold, fontSize: 9,
                          color: PdfColors.blueGrey500,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        order.address.name,
                        style: pw.TextStyle(
                          font: bold, fontSize: 10,
                          color: PdfColors.blue900,
                        ),
                      ),
                      pw.Text(
                        order.address.phone,
                        style: pw.TextStyle(
                          font: regular, fontSize: 9,
                          color: PdfColors.blueGrey600,
                        ),
                      ),
                      pw.Text(
                        order.address.address,
                        style: pw.TextStyle(
                          font: regular, fontSize: 9,
                          color: PdfColors.blueGrey600,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Order Total',
                      style: pw.TextStyle(
                        font: regular, fontSize: 9,
                        color: PdfColors.blueGrey500,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Rs.${order.totalAmount.toStringAsFixed(0)}',
                      style: pw.TextStyle(
                        font: bold, fontSize: 18,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.Text(
                      '${order.products.length} '
                          '${order.products.length == 1 ? 'item' : 'items'}',
                      style: pw.TextStyle(
                        font: regular, fontSize: 8,
                        color: PdfColors.blueGrey400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}