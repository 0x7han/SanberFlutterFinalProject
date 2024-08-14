import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:sanber_flutter_final_project/helper/pop_up_helper.dart';
import 'package:sanber_flutter_final_project/helper/property_helper.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/logic/blocs/cart/cart_bloc.dart';

import 'package:sanber_flutter_final_project/model/cart.dart';
import 'package:sanber_flutter_final_project/model/cashier.dart';
import 'package:sanber_flutter_final_project/model/product.dart';
import 'package:sanber_flutter_final_project/repositories/cashier_repository.dart';
import 'package:sanber_flutter_final_project/repositories/product_repository.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';
import 'package:sanber_flutter_final_project/ui/widgets/ink_well_button_widget.dart';

class PaymentActionScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const PaymentActionScreen({super.key, required this.data});

  @override
  State<PaymentActionScreen> createState() => _PaymentActionScreenState();
}

class _PaymentActionScreenState extends State<PaymentActionScreen> {
  late CartBloc _cartBloc;
  late ProductRepository _productRepository;
  late CashierRepository _cashierRepository;

  @override
  void initState() {
    super.initState();
    _cartBloc = context.read<CartBloc>();

    _productRepository = ProductRepository();
    _cashierRepository = CashierRepository();
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.fromLTRB(32, 0, 32, 240),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: themeHelper.colorScheme.onSurface.withOpacity(0.15))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Column(
                children: [
                  widget.data['label'] == 'Cash'
                      ? Text(
                          'Cash',
                          style: themeHelper.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      : SizedBox(
                          width: 128,
                          child: Image.asset(
                            widget.data['asset'],
                          ),
                        ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoaded) {
                  final num totalPrice = state.totalCartPrice;
                  return widget.data['key'] == null
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Total'),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    PropertyHelper.toIDR(totalPrice.toString()),
                                    style: themeHelper.textTheme.titleLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text:
                                      'Silahkan bayar sebanyak total nominal langsung secara ',
                                  style: themeHelper.textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: widget.data['label'],
                                      style: themeHelper.textTheme.bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                          ],
                        )
                      : widget.data['key'] == 'eWallet'
                          ? Column(
                              children: [
                                Container(
                                  width: 256,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Image.asset(
                                    'assets/images/dummy-qr.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Total'),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        PropertyHelper.toIDR(
                                            totalPrice.toString()),
                                        style: themeHelper.textTheme.titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text:
                                          'Silahkan scan kode QR diatas untuk melakukan pembayaran melalui ',
                                      style: themeHelper.textTheme.bodyMedium,
                                      children: [
                                        TextSpan(
                                          text: widget.data['label'],
                                          style: themeHelper
                                              .textTheme.bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Nomor VA'),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '82170193810291',
                                        style: themeHelper.textTheme.titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Total'),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        PropertyHelper.toIDR(
                                            totalPrice.toString()),
                                        style: themeHelper.textTheme.titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text:
                                          'Silahkan transfer sebanyak total nominal melalui nomor Virtual Account diatas untuk melakukan pembayaran ',
                                      style: themeHelper.textTheme.bodyMedium,
                                      children: [
                                        TextSpan(
                                          text: widget.data['label'],
                                          style: themeHelper
                                              .textTheme.bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                ),
                              ],
                            );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWellButtonWidget.primary(
                label: 'Konfirmasi',
                onTap: () {
                  PopUpHelper.dialog(context,
                      dialogState: DialogState.confirmation,
                      content: 'Apakah anda sudah menerima pembayaran?',
                      onContinue: () async {
                    final Cashier cashier = await _cashierRepository.post(
                        Cashier(
                            date: Timestamp.fromDate(DateTime.now()),
                            payment: widget.data['label'],
                            carts: _cartBloc.cart));

                    for (Cart cart in _cartBloc.cart) {
                      Product product =
                          await _productRepository.getById(cart.productId);
                      product.stok -= cart.qty;
                      _productRepository.patch(product);
                    }
                    if (context.mounted) {
                      context.goNamed(NamedRouter.paymentStatusScreen, extra: {
                        'cashier': cashier,
                        'isFromPayment': true,
                      });
                    }
                    _cartBloc.add(ResetCart());
                  });
                }),
            const SizedBox(
              height: 16,
            ),
            InkWellButtonWidget.secondary(
                label: 'Batalkan pesanan',
                onTap: () {
                  PopUpHelper.dialog(context,
                      dialogState: DialogState.confirmation,
                      content: 'Apakah anda yakin ingin membatalkan pesanan?',
                      onContinue: () {
                    _cartBloc.add(ResetCart());
                    context.goNamed(NamedRouter.cashierScreen);
                  });
                }),
          ],
        ),
      ),
    );
  }
}
