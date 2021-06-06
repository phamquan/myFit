import 'package:devx/cubits/health_permission_cubit.dart';
import 'package:devx/data/repositories/health_repository.dart';
import 'package:devx/ui/pages/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFit extends StatelessWidget {
  final HealthRepository healthRepository;

  const MyFit({Key? key, required this.healthRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [RepositoryProvider.value(value: healthRepository)],
        child: const MyFitView());
  }
}

class MyFitView extends StatelessWidget {
  const MyFitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: BlocProvider(
          create: (context) => HealthPermissionCubit(
              healthRepository: context.read<HealthRepository>()),
          child: MainPage()),
    );
  }
}
