import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';
import 'package:sanber_flutter_final_project/ui/widgets/ink_well_button_widget.dart';

final List<Map<String, dynamic>> eWalletPayment = [
  {
    'asset': 'assets/images/dana.png',
    'label': 'Dana',
  },
  {
    'asset': 'assets/images/ovo.png',
    'label': 'Ovo',
  },
  {
    'asset': 'assets/images/gopay.png',
    'label': 'Gopay',
  },
];

final List<Map<String, dynamic>> bankTransferPayment = [
  {
    'asset': 'assets/images/bca.png',
    'label': 'BCA',
  },
  {
    'asset': 'assets/images/bri.png',
    'label': 'BRI',
  },
  {
    'asset': 'assets/images/mandiri.png',
    'label': 'Mandiri',
  },
];

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Direct'),
            const SizedBox(
              height: 8,
            ),
            InkWellButtonWidget.outlined(context,
                prefix: SizedBox(
                    width: 32,
                    child: Text(
                      'Rp',
                      style: themeHelper.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
                label: 'Cash', onTap: () {
              final Map<String, dynamic> data = {'label': 'Cash'};
              context.pushNamed(NamedRouter.paymentDetailScreen, extra: data);
            }),
            const SizedBox(
              height: 16,
            ),
            const Text('E-wallet'),
            const SizedBox(
              height: 8,
            ),
            ...List.generate(
              eWalletPayment.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWellButtonWidget.outlined(context,
                      prefix: SizedBox(
                          width: 32,
                          child: Image.asset(
                            eWalletPayment[index]['asset'],
                            fit: BoxFit.cover,
                          )),
                      label: eWalletPayment[index]['label'], onTap: () {
                                                eWalletPayment[index].addAll({'key' :'eWallet'});
                    context.pushNamed(NamedRouter.paymentDetailScreen,
                        extra: eWalletPayment[index]);
                  }),
                );
              },
            ),
            const SizedBox(
              height: 8,
            ),
            const Text('Bank transfer'),
            const SizedBox(
              height: 8,
            ),
            ...List.generate(
              bankTransferPayment.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWellButtonWidget.outlined(context,
                      prefix: SizedBox(
                          width: 32,
                          child: Image.asset(
                            bankTransferPayment[index]['asset'],
                            fit: BoxFit.cover,
                          )),
                      label: bankTransferPayment[index]['label'], onTap: () {
                        bankTransferPayment[index].addAll({'key' :'bank'});
                    context.pushNamed(NamedRouter.paymentDetailScreen,
                        extra: bankTransferPayment[index]);
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
