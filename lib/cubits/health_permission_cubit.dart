import 'package:bloc/bloc.dart';
import 'package:devx/data/repositories/health_repository.dart';
import 'package:flutter/cupertino.dart';

class HealthPermissionCubit extends Cubit<HealthPermissionState> {
  final HealthRepository healthRepository;

  HealthPermissionCubit({required this.healthRepository}) : super(HealthPermissionState.INITIAL);

  void requestPermission() {
    healthRepository.accessWasGranted().then((granted) {
      debugPrint(granted.toString());
      if (granted) emit(HealthPermissionState.GRANTED);
      else emit(HealthPermissionState.DENY);
    }).catchError((error) {
      emit(HealthPermissionState.INITIAL);
    });
  }
}

enum HealthPermissionState {
  GRANTED,
  DENY,
  INITIAL
}