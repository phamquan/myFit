import 'package:devx/data/repositories/health_repository.dart';
import 'package:devx/ui/pages/home/home_page_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            HomePageCubit(healthRepository: context.read<HealthRepository>()),
        child: Scaffold(
            appBar: AppBar(title: Text("MyFit")), body: _HomePageView()));
  }
}

class _HomePageView extends StatelessWidget {
  _HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(builder: (context, state) {
      return Column(
        children: [
          _buildDatePicker(context),
          Expanded(child: _buildContent(context)),
        ],
      );
    });
  }

  Widget _buildContent(BuildContext context) {
    final cubit = context.read<HomePageCubit>();
    final dataState = cubit.state.dataState;
    switch (dataState) {
      case HomePageDataState.DATA_NOT_FETCHED:
        return _buildError(dataState.toString());
      case HomePageDataState.FETCHING_DATA:
        return _buildError(dataState.toString());
      case HomePageDataState.DATA_READY:
        return _buildCharts(context);
      case HomePageDataState.NO_DATA:
        return _buildError("YOU HAVE NO DATA IN THIS TIME");
      case HomePageDataState.AUTH_NOT_GRANTED:
        return _buildError(dataState.toString());
      case HomePageDataState.INITIAL:
        context.read<HomePageCubit>().fetchData();
        return _buildBusy("LOADING DATA");
    }
  }

  Widget _buildBusy(String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        const SizedBox(height: 16.0),
        Text(content)
      ],
    );
  }

  Widget _buildError(String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.warning),
        const SizedBox(height: 16.0),
        Text(content)
      ],
    );
  }

  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  Widget _buildDatePicker(BuildContext context) {
    final state = context
        .read<HomePageCubit>()
        .state;
    final startDate = dateFormat.format(state.startDate);
    final endDate = dateFormat.format(state.endDate);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  final startDate = state.startDate.subtract(Duration(days: 7));
                  final endDate = state.endDate.subtract(Duration(days: 7));
                  context.read<HomePageCubit>().updateRange(startDate, endDate);
                }),
            Text("From $startDate - $endDate"),
            IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  final startDate = state.startDate.add(Duration(days: 7));
                  final endDate = state.endDate.add(Duration(days: 7));
                  context.read<HomePageCubit>().updateRange(startDate, endDate);
                }),
          ],
        )
      ],
    );
  }

  Widget _buildCharts(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(height: 50),
            child: TabBar(
                labelColor: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                tabs: [
                  Tab(text: "MOVE MINUTES"),
                  Tab(text: "STEPS"),
                  Tab(text: "BMI"),
                ]),
          ),
          Expanded(
            child: Container(
              child: TabBarView(children: [
                _buildMoveMinutes(context),
                Container(
                  child: Text("SORRY. THE PLUGIN IS IN BUG-FIXED"),
                ),
                Container(
                  child: Text("SORRY. THE PLUGIN IS IN BUG-FIXED"),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMoveMinutes(BuildContext context) {
    final cubit = context.read<HomePageCubit>();
    final data = cubit.state.healthDataList.where((element) => element.type == HealthDataType.MOVE_MINUTES).toList();
    debugPrint('[_buildMoveMinutes]: Filter MOVE_MINUTES ${data.length}');

    final domain = List.generate(7, (index) => cubit.state.startDate.add(Duration(days: index)));
    final values = data.groupFoldBy<int, num>((element) => element.dateFrom.day, (previous, element) => (previous ?? 0) + element.value);
    final measure = domain.asMap().entries.map((entry) {
      int idx = entry.key;
      int val = entry.value.day;
      return BarChartGroupData(
        x: idx,
        barRods: [
          BarChartRodData(y: values[val]?.toDouble() ?? 0, colors: [Colors.lightBlueAccent, Colors.greenAccent])
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    debugPrint('[_buildMoveMinutes]: Drawing $values');
    debugPrint('domain: $domain');

    final maxY = values.isNotEmpty ? values.values.max.toDouble() * 1.1 : 20.0;

    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipMargin: 8,
                getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                    ) {
                  return BarTooltipItem(
                    rod.y.round().toString(),
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                margin: 20,
                getTitles: (double value) {
                  final i = value.toInt();
                  return domain[i].day.toString();
                },
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: measure
          ),
        ),
      ),
    );
  }

}
