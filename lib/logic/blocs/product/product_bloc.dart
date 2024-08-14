import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sanber_flutter_final_project/model/product.dart';
import 'package:sanber_flutter_final_project/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription<List<Product>>? _productSubscription;
  String _sortColumn = 'nama';
  bool _sortDescending = false;

  ProductBloc({ProductRepository? productRepository})
      : _productRepository = productRepository ?? ProductRepository(),
        super(ProductLoading()) {
    on<LoadProducts>((event, emit) {
      _productSubscription?.cancel();

      _productSubscription = _productRepository
          .get(
              sortColumn: _sortColumn,
              descending: _sortDescending,)
          .listen((datas) async {
        final totalData = await _productRepository.dataCount();

        
        add(UpdateProducts(datas, totalData));
      });
    });

    on<UpdateProducts>((event, emit) {
      emit(ProductsLoaded(
        datas: event.datas,
        sortColumn: _sortColumn,
        sortDescending: _sortDescending,
        dataCount: event.dataCount,
      ));
    });

    on<SearchProducts>((event, emit) async {
      emit(ProductLoading());
      final datas = await _productRepository.getByQuery(event.query);
      emit(ProductsLoaded(
        datas: datas,
        sortColumn: _sortColumn,
        sortDescending: _sortDescending,
        dataCount: datas.length,
      ));
    });


    on<AddProduct>((event, emit) async {
      await _productRepository.post(event.data);
    });

    on<EditProduct>((event, emit) async {
      await _productRepository.patch(event.data);
    });

    on<DeleteProduct>((event, emit) async {
      await _productRepository.drop(event.data);
    });

    on<SortProducts>((event, emit) {
      _sortColumn = event.sortColumn;
      _sortDescending = !_sortDescending;
      add(LoadProducts());
    });
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}
