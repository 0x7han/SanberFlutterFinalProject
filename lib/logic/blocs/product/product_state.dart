part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> datas;
  final String sortColumn;
  final bool sortDescending;
  final int dataCount;

  const ProductsLoaded({
    required this.datas,
    required this.sortColumn,
    required this.sortDescending,
    required this.dataCount,
  });

  ProductsLoaded copyWith({
    List<Product>? datas,
    List<String>? columns,
    String? sortColumn,
    bool? sortDescending,
    int? totalData,
  }) {
    return ProductsLoaded(
      datas: datas ?? this.datas,
      sortColumn: sortColumn ?? this.sortColumn,
      sortDescending: sortDescending ?? this.sortDescending,
      dataCount: totalData ?? this.dataCount,
    );
  }

  @override
  List<Object> get props => [
        datas,
        sortColumn,
        sortDescending,
        dataCount,
      ];
}

