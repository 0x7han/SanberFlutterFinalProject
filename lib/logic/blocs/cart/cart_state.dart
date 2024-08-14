part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Cart> datas;
  final int dataCount;
  final num totalCartPrice;

  const CartLoaded({
    required this.datas,
    required this.dataCount,
    required this.totalCartPrice,
  });

  CartLoaded copyWith({
    List<Cart>? datas,
    int? dataCount,
    num? totalCartPrice,
  }) {
    return CartLoaded(
      datas: datas ?? this.datas,
      dataCount: dataCount ?? this.dataCount,
      totalCartPrice: totalCartPrice ?? this.totalCartPrice,
    );
  }

  @override
  List<Object> get props => [
        datas,
        dataCount,
        totalCartPrice,
      ];
}