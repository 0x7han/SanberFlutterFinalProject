part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCarts extends CartEvent {}

class UpdateCarts extends CartEvent {
  final List<Cart> datas;
  final int dataCount;
  final num totalCartPrice;

  const UpdateCarts(
    this.datas,
    this.dataCount,
    this.totalCartPrice,
  );

  @override
  List<Object> get props => [
        datas,
        dataCount,
        totalCartPrice,
      ];
}

class SearchCarts extends CartEvent {
  final String query;

  const SearchCarts(this.query);

  @override
  List<Object> get props => [query];
}

class AddCart extends CartEvent {
  final Cart data;

  const AddCart(this.data);

  @override
  List<Object> get props => [data];
}

class EditCart extends CartEvent {
  final Cart data;

  const EditCart(this.data);

  @override
  List<Object> get props => [data];
}

class DeleteCart extends CartEvent {
  final Cart data;

  const DeleteCart(this.data);

  @override
  List<Object> get props => [data];
}


class ResetCart extends CartEvent {}