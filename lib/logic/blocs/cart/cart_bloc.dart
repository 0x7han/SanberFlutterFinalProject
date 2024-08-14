import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sanber_flutter_final_project/model/cart.dart';
import 'package:sanber_flutter_final_project/repositories/cart_repository.dart';
import 'package:sanber_flutter_final_project/repositories/product_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository = CartRepository();
  final ProductRepository _productRepository = ProductRepository();

  StreamSubscription<List<Cart>>? _cartSubscription;

  List<Cart> cart = [];
  CartBloc() : super(CartLoading()) {
    on<LoadCarts>((event, emit) async {
      _cartSubscription?.cancel();

      _cartSubscription = _cartRepository.get().listen((datas) async {
        final int totalData = await _cartRepository.dataCount();
        final num totalCartPrice = await _calculateTotalCartPrice(datas);
        cart = datas;
        add(UpdateCarts(datas, totalData, totalCartPrice));
      });
      await _cartRepository.sink();
    });

    on<UpdateCarts>((event, emit) {
      emit(CartLoaded(
        datas: event.datas,
        dataCount: event.dataCount,
        totalCartPrice: event.totalCartPrice,
      ));
    });

    on<AddCart>((event, emit) async {
      await _cartRepository.post(event.data);
    });

    on<EditCart>((event, emit) async {
      await _cartRepository.patch(event.data);
    });

    on<DeleteCart>((event, emit) async {
      await _cartRepository.drop(event.data);
    });

    on<ResetCart>((event, emit) async {
      await _cartRepository.reset();
      add(LoadCarts());
    });
  }

  Future<num> _calculateTotalCartPrice(List<Cart> carts) async {
    num total = 0;
    final List<Cart> cartsCopy = List.from(carts);

    for (var cart in cartsCopy) {
      final product = await _productRepository.getById(cart.productId);
      total += product.harga * cart.qty;
    }
    return total;
  }

  @override
  Future<void> close() {
    _cartRepository.dispose();
    _cartSubscription?.cancel();
    return super.close();
  }
}
