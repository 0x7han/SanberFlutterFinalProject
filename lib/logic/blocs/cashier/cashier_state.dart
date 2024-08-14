part of 'cashier_bloc.dart';

sealed class CashierState extends Equatable {
  const CashierState();

  @override
  List<Object> get props => [];
}

final class CashierInitial extends CashierState {}

class CashierLoading extends CashierState {}

class CashierLoaded extends CashierState {
  final List<Cashier> datas;
  final String sortColumn;
  final bool sortDescending;
  final int dataCount;

  const CashierLoaded({
    required this.datas,
    required this.sortColumn,
    required this.sortDescending,
    required this.dataCount,
  });

  CashierLoaded copyWith({
    List<Cashier>? datas,
    List<String>? columns,
    String? sortColumn,
    bool? sortDescending,
    int? totalData,
  }) {
    return CashierLoaded(
      datas: datas ?? this.datas,
      sortColumn: sortColumn ?? this.sortColumn,
      sortDescending: sortDescending ?? this.sortDescending,
      dataCount: totalData ?? dataCount,
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

