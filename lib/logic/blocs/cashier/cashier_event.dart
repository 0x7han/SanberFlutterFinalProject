part of 'cashier_bloc.dart';

sealed class CashierEvent extends Equatable {
  const CashierEvent();

  @override
  List<Object> get props => [];
}

class LoadCashiers extends CashierEvent {}

class UpdateCashiers extends CashierEvent {
  final List<Cashier> datas;
  final int totalData;

  const UpdateCashiers(
    this.datas,
    this.totalData,
  );

  @override
  List<Object> get props => [
        datas,
        totalData,
      ];
}

class SearchCashiers extends CashierEvent {
  final String query;

  const SearchCashiers(this.query);

  @override
  List<Object> get props => [query];
}

class AddCashier extends CashierEvent {
  final Cashier data;

  const AddCashier(this.data);

  @override
  List<Object> get props => [data];
}

class EditCashier extends CashierEvent {
  final Cashier data;

  const EditCashier(this.data);

  @override
  List<Object> get props => [data];
}

class DeleteCashier extends CashierEvent {
  final Cashier data;

  const DeleteCashier(this.data);

  @override
  List<Object> get props => [data];
}

class SortCashiers extends CashierEvent {
  final String sortColumn;

  const SortCashiers(
    this.sortColumn,
  );

  @override
  List<Object> get props => [sortColumn];
}
