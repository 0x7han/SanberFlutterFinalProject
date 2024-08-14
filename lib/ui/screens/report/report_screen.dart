import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/helper/property_helper.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/logic/blocs/cashier/cashier_bloc.dart';
import 'package:sanber_flutter_final_project/model/cart.dart';
import 'package:sanber_flutter_final_project/model/cashier.dart';
import 'package:sanber_flutter_final_project/repositories/product_repository.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';
import 'package:sanber_flutter_final_project/ui/widgets/dropdown_button_widget.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late CashierBloc _cashierBloc;
  late ProductRepository _productRepository;
  @override
  void initState() {
    super.initState();
    _cashierBloc = context.read<CashierBloc>();
    _cashierBloc.add(LoadCashiers());

    _productRepository = ProductRepository();
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: BlocBuilder<CashierBloc, CashierState>(
        builder: (context, state) {
          List<String> columns = [
            'Date',
            'Payment',
          ];
          if (state is CashierLoaded) {
            final List<Cashier> cashiers = state.datas;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonWidget(
                        value: state.sortColumn,
                        onChanged: (value) {
                          _cashierBloc.add(SortCashiers(value));
                        },
                        columns: columns,
                      ),
                      Text(
                        'Jumlah data : ${state.dataCount}',
                        style: themeHelper.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cashiers.length,
                      itemBuilder: (_, index) {
                        final List<Cart> carts = cashiers[index].carts;
                        final String dateTime =
                            DateTime.fromMillisecondsSinceEpoch(
                                    cashiers[index].date.millisecondsSinceEpoch)
                                .toString();
                        final int totalPrice =
                            carts.fold(0, (sum, cart) => sum + cart.total);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 2,
                                color: themeHelper.colorScheme.primaryContainer
                                    .withOpacity(0.6),
                              )),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.all(16),
                              title: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.pushNamed(
                                          NamedRouter.paymentStatusScreen,
                                          extra: {
                                            'cashier': cashiers[index],
                                            'isFromPayment': false,
                                          });
                                    },
                                    icon: const Icon(Icons.document_scanner),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dateTime.substring(0, 10),
                                        style:
                                            themeHelper.textTheme.titleMedium,
                                      ),
                                      Text(
                                        dateTime.substring(11, 16),
                                        style: themeHelper.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  const Divider()
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      'Pembayaran : ${cashiers[index].payment}'),
                                  Text(
                                      'Total item : ${cashiers[index].carts.length}'),
                                  Text(
                                      'Total harga : ${PropertyHelper.toIDR(totalPrice.toString())}')
                                ],
                              ),
                              children: List.generate(carts.length, (i) {
                                final num priceItem =
                                    (carts[i].total / carts[i].qty) / 10;

                                return FutureBuilder(
                                    future: _productRepository
                                        .getById(carts[i].productId),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          margin:
                                              const EdgeInsets.fromLTRB(16, 0, 16, 4),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: themeHelper
                                                .colorScheme.primaryContainer
                                                .withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: ListTile(
                                            isThreeLine: true,
                                            title: Text(snapshot.data!.nama),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(snapshot.data!.satuan),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(carts[i]
                                                        .qty
                                                        .toString()),
                                                    const Text(' @ '),
                                                    Text(PropertyHelper.toIDR(
                                                        priceItem.toString())),
                                                  ],
                                                ),
                                                Text(PropertyHelper.toIDR(
                                                    carts[i].total.toString())),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    });
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
