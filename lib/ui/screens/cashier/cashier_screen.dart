import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/helper/pop_up_helper.dart';
import 'package:sanber_flutter_final_project/helper/property_helper.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/logic/blocs/cart/cart_bloc.dart';
import 'package:sanber_flutter_final_project/logic/blocs/product/product_bloc.dart';
import 'package:sanber_flutter_final_project/model/cart.dart';
import 'package:sanber_flutter_final_project/model/product.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';
import 'package:sanber_flutter_final_project/ui/widgets/dropdown_button_widget.dart';
import 'package:sanber_flutter_final_project/ui/widgets/text_field_search_widget.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  late CartBloc _cartBloc;
  late ProductBloc _productBloc;

  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _cartBloc = context.read<CartBloc>();

    _cartBloc.add(LoadCarts());

    _productBloc = context.read<ProductBloc>();
    _productBloc.add(LoadProducts());

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashier'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState is CartLoaded) {
                return Badge(
                  label: Text(cartState.dataCount.toString()),
                  child: IconButton(
                    onPressed: () {
                      context.pushNamed(NamedRouter.cartScreen);
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFieldSearchWidget(
                textEditingController: _searchController,
                onEditingComplete: () {
                  _productBloc.add(SearchProducts(_searchController.text));
                },
                onRefresh: () {
                  _productBloc.add(LoadProducts());
                }),
          ),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProductsLoaded) {
                final List<Product> products = state.datas;
                List<String> columns = ['Nama', 'Satuan', 'Harga', 'Stok'];
                if (products.isNotEmpty) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonWidget(
                            value: state.sortColumn,
                            onChanged: (value) {
                              _productBloc.add(SortProducts(value));
                            },
                            columns: columns,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      onTap: () {
                                        final Product product = products[index];
                                        PopUpHelper.modalBottom(context,
                                            title: product.nama,
                                            content: product.description);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              color: themeHelper.colorScheme
                                                  .primaryContainer),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image.network(
                                                  products[index].imgSrc,
                                                  fit: BoxFit.cover,
                                                )),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        products[index].nama,
                                                        style: themeHelper
                                                            .textTheme
                                                            .titleMedium,
                                                      ),
                                                      Text(products[index]
                                                          .satuan),
                                                      Text(
                                                        PropertyHelper.toIDR(
                                                            products[index]
                                                                .harga
                                                                .toString()),
                                                        style: themeHelper
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: themeHelper
                                                                    .colorScheme
                                                                    .onSurfaceVariant),
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton.filledTonal(
                                                      iconSize: 20,
                                                      onPressed: () {
                                                        final cartState =
                                                            _cartBloc.state;

                                                        if (cartState
                                                            is CartLoaded) {
                                                          final int
                                                              existingIndex =
                                                              cartState
                                                                  .datas
                                                                  .indexWhere((item) =>
                                                                      item.productId ==
                                                                      products[
                                                                              index]
                                                                          .id);
                                                          if (existingIndex ==
                                                              -1) {
                                                            if (products[index]
                                                                    .stok >
                                                                0) {
                                                              _cartBloc.add(
                                                                AddCart(Cart(
                                                                    productId:
                                                                        products[index]
                                                                            .id,
                                                                    qty: 1,
                                                                    total: products[
                                                                            index]
                                                                        .harga)),
                                                              );
                                                              PopUpHelper.snackbar(
                                                                  context,
                                                                  message:
                                                                      'Berhasil ditambahkan ke keranjang');
                                                            } else {
                                                              PopUpHelper.snackbar(
                                                                  context,
                                                                  message:
                                                                      'Stok barang habis');
                                                            }
                                                          } else {
                                                            PopUpHelper.snackbar(
                                                                context,
                                                                message:
                                                                    'Produk sudah ada di keranjang');
                                                          }
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
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
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
