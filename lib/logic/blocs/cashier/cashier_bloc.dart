import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanber_flutter_final_project/model/cashier.dart';
import 'package:sanber_flutter_final_project/repositories/cashier_repository.dart';

part 'cashier_event.dart';
part 'cashier_state.dart';

class CashierBloc extends Bloc<CashierEvent, CashierState> {
  final CashierRepository _cashierRepository;
  StreamSubscription<List<Cashier>>? _cashierSubscription;
  String _sortColumn = 'date';
  bool _sortDescending = false;

  CashierBloc({CashierRepository? cashierRepository})
      : _cashierRepository = cashierRepository ?? CashierRepository(),
        super(CashierLoading()) {
    on<LoadCashiers>((event, emit) {
      _cashierSubscription?.cancel();

      _cashierSubscription = _cashierRepository
          .get(
        sortColumn: _sortColumn,
        descending: _sortDescending,
      )
          .listen((datas) async {
        final int totalData = await _cashierRepository.dataCount();
        add(UpdateCashiers(datas, totalData));
      });
    });

    on<UpdateCashiers>((event, emit) {
      emit(CashierLoaded(
        datas: event.datas,
        sortColumn: _sortColumn,
        sortDescending: _sortDescending,
        dataCount: event.totalData,
      ));
    });

    on<SearchCashiers>((event, emit) async {
      emit(CashierLoading());
      final datas = await _cashierRepository.getByQuery(event.query);
      emit(CashierLoaded(
        datas: datas,
        sortColumn: _sortColumn,
        sortDescending: _sortDescending,
        dataCount: datas.length,
      ));
    });

    on<AddCashier>((event, emit) async {
      await _cashierRepository.post(event.data);
    });

    on<EditCashier>((event, emit) async {
      await _cashierRepository.patch(event.data);
    });

    on<DeleteCashier>((event, emit) async {
      await _cashierRepository.drop(event.data);
    });

    on<SortCashiers>((event, emit) {
      _sortColumn = event.sortColumn;
      _sortDescending = !_sortDescending;
      add(LoadCashiers());
    });
  }

  @override
  Future<void> close() {
    _cashierSubscription?.cancel();
    return super.close();
  }
}
