import 'package:myFit/data/repositories/health_repository.dart';
import 'package:myFit/ui/pages/main/main_page.dart';
import 'package:flutter/material.dart';
import 'my_fit.dart';

void main() async {
  runApp(MyFit(healthRepository: HealthRepositoryImpl(),));
}

