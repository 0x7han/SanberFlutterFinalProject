import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/helper/local_notification_helper.dart';
import 'package:sanber_flutter_final_project/helper/property_helper.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';
import 'package:sanber_flutter_final_project/logic/blocs/product/product_bloc.dart';
import 'package:sanber_flutter_final_project/model/product.dart';
import 'package:sanber_flutter_final_project/routes/named_router.dart';
import 'package:sanber_flutter_final_project/ui/widgets/dropdown_button_widget.dart';
import 'package:sanber_flutter_final_project/ui/widgets/text_field_search_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductBloc _productBloc;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _productBloc = context.read<ProductBloc>();
    _productBloc.add(LoadProducts());

    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productsState = _productBloc.state;
      if (productsState is ProductsLoaded) {
        final List<Product> products = productsState.datas;
        for (int i = 0; i < products.length; i++) {
          if (products[i].stok < 5) {
            LocalNotificationHelper.sendLocalNotification(
              i,
              'Product ${products[i].nama} hampir habis nih, ayo restock lagi',
            );
          }
        }
      }
    });
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
        title: const Text('Product'),
        actions: [
          Text(
            'Jumlah data : ${_productBloc.state is ProductsLoaded ? (_productBloc.state as ProductsLoaded).dataCount : 0}',
            style: themeHelper.textTheme.bodySmall,
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
                            height: 16,
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
                                        context.pushNamed(
                                            NamedRouter.productEditScreen,
                                            extra: product);
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
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    products[index].nama,
                                                    style: themeHelper
                                                        .textTheme.titleMedium,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        PropertyHelper.toIDR(
                                                            products[index]
                                                                .harga
                                                                .toString()),
                                                        style: themeHelper
                                                            .textTheme
                                                            .labelLarge!
                                                            .copyWith(
                                                                color: themeHelper
                                                                    .colorScheme
                                                                    .onSurfaceVariant),
                                                      ),
                                                      const Text(' / '),
                                                      Text(products[index]
                                                          .satuan),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    'Stok : ${products[index].stok}',
                                                    style: themeHelper
                                                        .textTheme.labelLarge!
                                                        .copyWith(
                                                            color: themeHelper
                                                                .colorScheme
                                                                .onSurface
                                                                .withOpacity(
                                                                    0.6)),
                                                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(NamedRouter.productAddScreen);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
