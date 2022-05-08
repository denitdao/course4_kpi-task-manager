import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:task_manager/core/auth/teacher_auth_required_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/pages/teacher/subject_statistics_page/subject_statistics_cubit.dart';

class SubjectStatisticsPage extends StatefulWidget {
  const SubjectStatisticsPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  _SubjectStatisticsPageState createState() => _SubjectStatisticsPageState();
}

class _SubjectStatisticsPageState
    extends TeacherAuthRequiredState<SubjectStatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SubjectStatisticsCubit>()..loadData(widget.id),
      child: _SubjectOverview(),
    );
  }
}

class _SubjectOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectStatisticsCubit, SubjectStatisticsState>(
      builder: (context, state) {
        if (state.dataStatus == ExternalDataStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Subject statistics'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(state.subject!.title,
                        style: Theme.of(context).textTheme.headline3),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 6),
                    child: _WeeklyPerformanceChart(),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                    child: _LastTaskPerformanceChart(),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Text("lalala"),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WeeklyPerformanceChart extends StatelessWidget {
  const _WeeklyPerformanceChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectStatisticsCubit, SubjectStatisticsState>(
      builder: (context, state) {
        return SfCartesianChart(
          title: ChartTitle(text: 'Week day performance'),
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.percentPattern(),
            rangePadding: ChartRangePadding.round,
            minimum: 0,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          series: <ColumnSeries>[
            ColumnSeries<dynamic, String>(
              dataSource: state.weeklyPerformance,
              borderRadius: BorderRadius.circular(5),
              xValueMapper: (value, _) => value['x'],
              yValueMapper: (value, _) => value['y'],
            ),
          ],
          tooltipBehavior: TooltipBehavior(header: '', enable: true),
        );
      },
    );
  }
}

class _LastTaskPerformanceChart extends StatelessWidget {
  const _LastTaskPerformanceChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectStatisticsCubit, SubjectStatisticsState>(
      builder: (context, state) {
        return SfCartesianChart(
          title: ChartTitle(text: 'Last task completion'),
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.percentPattern(),
            rangePadding: ChartRangePadding.round,
            maximum: 1,
            minimum: 0,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          series: <ColumnSeries>[
            ColumnSeries<dynamic, String>(
              dataSource: state.lastTaskPerformance,
              borderRadius: BorderRadius.circular(5),
              xValueMapper: (value, _) => value['x'],
              yValueMapper: (value, _) => value['y'],
              isTrackVisible: true,
              trackColor: const Color.fromRGBO(224, 226, 229, 1.0),
            ),
          ],
          tooltipBehavior: TooltipBehavior(header: '', enable: true),
        );
      },
    );
  }
}
