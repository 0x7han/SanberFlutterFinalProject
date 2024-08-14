import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/helper/property_helper.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/logic/blocs/cart/cart_bloc.dart';
import 'package:sanber_flutter_final_project/model/cart.dart';
import 'package:sanber_flutter_final_project/model/product.dart';
import 'package:sanber_flutter_final_project/repositories/product_repository.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';
import 'package:sanber_flutter_final_project/ui/widgets/ink_well_button_widget.dart';

class CartScren extends StatefulWidget {
  const CartScren({super.key});

  @override
  State<CartScren> createState() => _CartScrenState();
}

class _CartScrenState extends State<CartScren> {
  late CartBloc _cartBloc;
  late ProductRepository _productRepository;

  @override
  void initState() {
    super.initState();

    _cartBloc = context.read<CartBloc>();
    _cartBloc.add(LoadCarts());

    _productRepository = ProductRepository();
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            final List<Cart> carts = state.datas;

            if (carts.isNotEmpty) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  child: ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (_, index) {
                      final Cart cart = carts[index];
                      return FutureBuilder<Product>(
                        future: _productRepository.getById(cart.productId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final Product product = snapshot.data!;
                            final num itemTotalPrice = product.harga * cart.qty;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: themeHelper
                                          .colorScheme.primaryContainer),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.network(
                                            product.imgSrc,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.nama,
                                              style: themeHelper
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                      color: themeHelper
                                                          .colorScheme.onSurface
                                                          .withOpacity(0.6)),
                                            ),
                                            Text(
                                              PropertyHelper.toIDR(
                                                  product.harga.toString()),
                                              style: themeHelper
                                                  .textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: themeHelper
                                                          .colorScheme
                                                          .onSurfaceVariant),
                                            ),
                                            Text('Stok : ${product.stok}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: themeHelper
                                          .colorScheme.onSurfaceVariant
                                          .withOpacity(0.2),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total : ${PropertyHelper.toIDR(itemTotalPrice.toString())}',
                                            style: themeHelper
                                                .textTheme.bodyMedium,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: themeHelper
                                                    .colorScheme.onSurface
                                                    .withOpacity(0.2),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    if (cart.qty > 1) {
                                                      cart.qty -= 1;
                                                      cart.total = product.harga * cart.qty;
                                                      _cartBloc
                                                          .add(EditCart(cart));
                                                    } else {
                                                      _cartBloc.add(
                                                          DeleteCart(cart));
                                                    }
                                                  },
                                                  icon: Icon(cart.qty == 1
                                                      ? Icons.delete
                                                      : Icons.remove),
                                                ),
                                                Text(cart.qty.toString()),
                                                IconButton(
                                                  onPressed: () {
                                                    if (cart.qty <
                                                        product.stok) {
                                                      cart.qty += 1;
                                                      cart.total = product.harga * cart.qty;
                                                      _cartBloc
                                                          .add(EditCart(cart));
                                                    }
                                                  },
                                                  icon: const Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                bottomSheet: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${PropertyHelper.toIDR(state.totalCartPrice.toString())}',
                        style: themeHelper.textTheme.titleMedium,
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      Expanded(
                        child: InkWellButtonWidget.primary(
                          label: 'Pilih metode pembayaran',
                          onTap: () {
                            context.pushNamed(NamedRouter.paymentScreen);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Belum ada data'),
              );
            }
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
