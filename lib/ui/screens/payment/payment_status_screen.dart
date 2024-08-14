import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:sanber_flutter_final_project/helper/local_notification_helper.dart';
import 'package:sanber_flutter_final_project/helper/property_helper.dart';
import 'package:sanber_flutter_final_project/model/cart.dart';
import 'package:sanber_flutter_final_project/model/cashier.dart';
import 'package:sanber_flutter_final_project/model/product.dart';
import 'package:sanber_flutter_final_project/repositories/product_repository.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';
import 'package:sanber_flutter_final_project/ui/widgets/ink_well_button_widget.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PaymentStatusScreen extends StatefulWidget {
  final bool isFromPayment;
  final Cashier cashier;
  const PaymentStatusScreen({super.key, this.isFromPayment = true, required this.cashier});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  late ProductRepository _productRepository;

  List<Map<String, dynamic>> cartsJoinProducts = [];
  pw.Document pdf = pw.Document();

  @override
  void initState() {
    super.initState();
    _productRepository = ProductRepository();
    if(widget.isFromPayment) {
      LocalNotificationHelper.sendLocalNotification(1, 'Transaksi berhasil 😁');
    }
    _cartsJoinProductsGenerate().then((_) => _generatePdf());
  }



  Future<void> _cartsJoinProductsGenerate() async {
    for (Cart cart in widget.cashier.carts) {
      Product product = await _productRepository.getById(cart.productId);
      cartsJoinProducts.add({
        'nama': product.nama,
        'satuan': product.satuan,
        'qty': cart.qty,
        'total': cart.total,
      });
    }
    setState(() {});
  }

  Future<void> _generatePdf() async {
    final int totalPrice =
        widget.cashier.carts.fold(0, (sum, cart) => sum + cart.total);
    pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          final String dateTime = DateTime.fromMillisecondsSinceEpoch(
                  widget.cashier.date.millisecondsSinceEpoch)
              .toString();
          final String cashierId = dateTime
              .replaceAll('-', '')
              .replaceAll('.', '')
              .replaceAll(':', '')
              .replaceAll(' ', '');
          return pw.Center(
            child: pw.Column(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 16, bottom: 32),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("ID Order"),
                            pw.Text(cashierId),
                          ]),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Tanggal"),
                            pw.Text(dateTime.substring(0, 10)),
                          ]),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Jam"),
                            pw.Text(dateTime.substring(11, 16)),
                          ]),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Payment"),
                            pw.Text(widget.cashier.payment),
                          ]),
                      pw.Divider(),
                      pw.ListView.builder(
                          itemBuilder: (_, index) {
                            final num priceItem = (cartsJoinProducts[index]
                                        ['total'] /
                                    cartsJoinProducts[index]['qty']) /
                                10;
                            return pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 4),
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text(
                                              "${cartsJoinProducts[index]['nama']}"),
                                          pw.Text(
                                              "${cartsJoinProducts[index]['satuan']}"),
                                        ]),
                                    pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text(
                                              "Qty : ${cartsJoinProducts[index]['qty']}"),
                                          pw.Text(
                                              "@ ${PropertyHelper.toIDR(priceItem.toString())}"),
                                        ]),
                                    pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.SizedBox(),
                                          pw.Text(
                                              PropertyHelper.toIDR(cartsJoinProducts[index]['total'].toString())),
                                        ]),
                                  ]),
                            );
                          },
                          itemCount: cartsJoinProducts.length),
                      pw.Divider(),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total'),
                            pw.Text(
                                PropertyHelper.toIDR(totalPrice.toString())),
                          ]),
                    ]),
              ),
              pw.Text('Terimakasih telah menggunakan Aplikasi Rei POS :)', textAlign: pw.TextAlign.center),
            ]),
          );
        },
      ),
    );

    setState(() {});
  }

  Future<String> _savePdfToDownloads(String fileName) async {
    try {
      final Directory? directory = await getDownloadsDirectory();
      final String? path = directory?.path;

      final String filePath = '$path/$fileName.pdf';

      final File file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return 'PDF berhasil disimpan di : $filePath';
    } catch (e) {
      throw Exception('asdasd');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.isFromPayment,
        title: !widget.isFromPayment ? const Text('Kembali') : null,
      ),
      body: Container(
        padding:  EdgeInsets.fromLTRB(32, 0, 32, widget.isFromPayment ? 150 : 32),
        child: PdfPreview(
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          build: (format) => pdf.save(),
        ),
      ),
      bottomSheet: widget.isFromPayment ? Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWellButtonWidget.primary(
                label: 'Selesai',
                onTap: () {
                  context.goNamed(NamedRouter.cashierScreen);
                }),
          ],
        ),
      ) : null,
    );
  }
}
