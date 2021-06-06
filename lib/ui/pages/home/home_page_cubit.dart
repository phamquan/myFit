import 'package:bloc/bloc.dart';
import 'package:devx/data/repositories/health_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:health/health.dart';

final now = DateTime.now().add(Duration(days: 1));
final before7 = now.subtract(Duration(days: 7));

class HomePageCubit extends Cubit<HomePageState> {
  final HealthRepository healthRepository;

  HomePageCubit({required this.healthRepository})
      : super(
      HomePageState(
          startDate: DateTime(before7.year, before7.month, before7.day),
          endDate: DateTime(now.year, now.month, now.day).subtract(Duration(seconds: 1))));

  void fetchData() {
    final endDate = state.endDate;
    final startDate = state.startDate;
    debugPrint("request fetchData $startDate - $endDate");
    healthRepository.fetchData(startDate, endDate).then((results) {
      debugPrint('Result of $startDate to $endDate: ${results}');
      final newState = this.state.copyWith(
          healthDataList: results, dataState: HomePageDataState.DATA_READY);
      emit(newState);
    }).catchError((error) {
      emit(this.state.copyWith(dataState: HomePageDataState.NO_DATA));
      debugPrint(error.toString());
    });
  }

  void updateRange(DateTime startDate, DateTime endDate) {
    debugPrint("request updateRange $startDate - $endDate");
    final newState = state.copyWith(startDate: startDate, endDate: endDate, dataState: HomePageDataState.INITIAL);
    emit(newState);
  }
}

class HomePageState extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final HomePageDataState dataState;
  final List<HealthDataPoint> healthDataList;

  HomePageState({this.dataState = HomePageDataState.INITIAL,
    this.healthDataList = const [],
    required this.startDate, required this.endDate
  });

  @override
  List<Object?> get props => [dataState];

  HomePageState copyWith({HomePageDataState? dataState,
    List<HealthDataPoint>? healthDataList,
    DateTime? startDate,
    DateTime? endDate}) {
    return HomePageState(
        dataState: dataState ?? this.dataState,
        healthDataList: healthDataList ?? this.healthDataList,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate);
  }
}

enum HomePageDataState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  INITIAL
}
