import 'package:devx/cubits/health_permission_cubit.dart';
import 'package:devx/ui/pages/home/home_page.dart';
import 'package:devx/ui/pages/menu/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Build MainPage");
    context.read<HealthPermissionCubit>().requestPermission();
    return BlocBuilder<HealthPermissionCubit, HealthPermissionState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state)  {
        if (state == HealthPermissionState.GRANTED) {
          return _buildAuthenticated(context);
        } else {
          return _buildUnauthorized(context);
        }
      },
    );
  }

  Widget _buildUnauthorized(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You are now allowed to accessed"),
            ElevatedButton(onPressed: () async {
              // await _handleSignIn();
              final cubit = context.read<HealthPermissionCubit>();
              cubit.requestPermission();
            }, child: Text("Request"))
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticated(BuildContext context) {
    return DefaultTabController(length: 2,
        child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ]
              ),
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home),text: "HOME"),
                  Tab(icon: Icon(Icons.info), text: "ABOUT"),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            body: TabBarView(
                children: getTabViews()),
          ),
        )
    );
  }

  List<Widget> getTabViews() {
    return [
      HomePage(),
      MenuPage(),
    ];
  }
}
