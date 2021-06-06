import 'package:flutter/widgets.dart';
import 'package:health/health.dart';

abstract class HealthRepository {
  Future<bool> accessWasGranted();
  Future<List<HealthDataPoint>> fetchData(DateTime startDate, DateTime endDate);
}

class HealthRepositoryImpl implements HealthRepository {
  HealthFactory health = HealthFactory();

  List<HealthDataType> types = [
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
    HealthDataType.MOVE_MINUTES,
  ];
  @override
  Future<bool> accessWasGranted() {
    return health.requestAuthorization(types);
  }

  @override
  Future<List<HealthDataPoint>> fetchData(DateTime startDate, DateTime endDate) async {
    final results = await health.getHealthDataFromTypes(startDate, endDate, types);
    return HealthFactory.removeDuplicates(results);
  }
}