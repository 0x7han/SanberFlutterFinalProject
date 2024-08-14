part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class UpdateProducts extends ProductEvent {
  final List<Product> datas;
  final int dataCount;


  const UpdateProducts(this.datas, this.dataCount,);

  @override
  List<Object> get props => [datas, dataCount,];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

class AddProduct extends ProductEvent {
  final Product data;

  const AddProduct(this.data);

  @override
  List<Object> get props => [data];
}

class EditProduct extends ProductEvent {
  final Product data;

  const EditProduct(this.data);

  @override
  List<Object> get props => [data];
}

class DeleteProduct extends ProductEvent {
  final Product data;

  const DeleteProduct(this.data);

  @override
  List<Object> get props => [data];
}

class SortProducts extends ProductEvent {
  final String sortColumn;

  const SortProducts(
    this.sortColumn,
  );

  @override
  List<Object> get props => [sortColumn];
}

