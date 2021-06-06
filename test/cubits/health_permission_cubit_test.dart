import 'package:bloc_test/bloc_test.dart';
import 'package:myFit/cubits/health_permission_cubit.dart';
import 'package:myFit/data/repositories/health_repository.dart';
import 'package:myFit/ui/pages/home/home_page_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// class MockHealthRepository extends Mock implements HealthRepository {}

@GenerateMocks([HealthRepository])
void main() {
  group("Heath Permission Cubit Grant", () {
    var healthRepository = MockHealthRepository();
    when(healthRepository.accessWasGranted()).thenAnswer((_) async => Future.value(true));

    blocTest<HealthPermissionCubit, HealthPermissionState>(
        'should call accessWasGranted when requesting requestPermission',
        wait: Duration(milliseconds: 2000),
        build: () => HealthPermissionCubit(healthRepository: healthRepository),
        act: (bloc) =>
            bloc.requestPermission(),
        verify: (bloc) {
          verify(healthRepository.accessWasGranted()).called(1);
        });
  });
}