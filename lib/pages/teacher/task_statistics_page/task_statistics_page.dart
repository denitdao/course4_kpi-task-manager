import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:task_manager/core/auth/teacher_auth_required_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/teacher/task_statistics_page/task_statistics_cubit.dart';

class TaskStatisticsPage extends StatefulWidget {
  const TaskStatisticsPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  _TaskStatisticsPageState createState() => _TaskStatisticsPageState();
}

class _TaskStatisticsPageState
    extends TeacherAuthRequiredState<TaskStatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TaskStatisticsCubit>()..loadData(widget.id),
      child: _TaskOverview(),
    );
  }
}

class _TaskOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskStatisticsCubit, TaskStatisticsState>(
      builder: (context, state) {
        if (state.dataStatus == ExternalDataStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        List<Widget> students = state.userTaskStatuses
            .map((e) => Row(children: [
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: e.isDone,
                    onChanged: (_) => null,
                  ),
                  Expanded(
                    child: Text(
                      e.firstName + ' ' + e.lastName,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ]))
            .toList();

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Task statistics'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(
                        'Days left: ' +
                            state.task!.dueDate
                                .difference(DateTime.now())
                                .inDays
                                .toString(),
                        style: Theme.of(context).textTheme.headline3),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: _CompletionPerformanceChart(),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _CompletionPerformanceGauge(),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                            child: Text(
                              'Completed by ${state.task!.completedBy}/${state.task!.studentsOverall}',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 12),
                          child: LinearProgressIndicator(
                            value: _findLinearProgress(state.task!),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...students
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _findLinearProgress(Task task) {
    if (task.studentsOverall == 0) {
      return 1;
    }
    return task.completedBy / task.studentsOverall;
  }
}

class _CompletionPerformanceChart extends StatelessWidget {
  const _CompletionPerformanceChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskStatisticsCubit, TaskStatisticsState>(
      builder: (context, state) {
        return SfCartesianChart(
          title: ChartTitle(text: 'Task performance'),
          primaryXAxis: DateTimeAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            rangePadding: ChartRangePadding.round,
            interval: 2,
            plotBands: <PlotBand>[
              PlotBand(
                isVisible: true,
                start: state.task!.startDate.toLocal(),
                end: state.task!.dueDate.toLocal(),
                color: Colors.deepPurple,
                opacity: 0.1,
              ),
            ],
          ),
          primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.percentPattern(),
            rangePadding: ChartRangePadding.round,
            maximum: 1,
            minimum: 0,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          series: <ChartSeries>[
            LineSeries<dynamic, DateTime>(
              dataSource: state.taskPerformance,
              xValueMapper: (value, _) => value['x'],
              yValueMapper: (value, _) => value['y'],
              markerSettings: const MarkerSettings(
                isVisible: true,
                borderWidth: 1,
                width: 4,
                height: 4,
              ),
              trendlines: state.taskPerformance.length <= 1
                  ? null
                  : <Trendline>[
                      Trendline(
                        color: Colors.green,
                        type: TrendlineType.linear,
                        width: 1,
                        dashArray: <double>[5, 5],
                      ),
                    ],
            ),
          ],
          tooltipBehavior: TooltipBehavior(header: '', enable: true),
        );
      },
    );
  }
}

class _CompletionPerformanceGauge extends StatelessWidget {
  const _CompletionPerformanceGauge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskStatisticsCubit, TaskStatisticsState>(
      builder: (context, state) {
        return SfLinearGauge(
          animateAxis: true,
          showLabels: false,
          showTicks: false,
          minimum: 0.0,
          maximum: 100.0,
          orientation: LinearGaugeOrientation.horizontal,
          markerPointers: <LinearMarkerPointer>[
            LinearShapePointer(
                value: _findLinearProgress(state.task!, state.taskPerformance),
                height: 10,
                width: 10,
                position: LinearElementPosition.cross,
                shapeType: LinearShapePointerType.circle),
          ],
          ranges: const <LinearGaugeRange>[
            LinearGaugeRange(
              startValue: 0,
              endValue: 33,
              position: LinearElementPosition.cross,
              color: Colors.redAccent,
            ),
            LinearGaugeRange(
              startValue: 33,
              endValue: 66,
              position: LinearElementPosition.cross,
              color: Colors.orangeAccent,
            ),
            LinearGaugeRange(
              startValue: 66,
              endValue: 100,
              position: LinearElementPosition.cross,
              color: Colors.lightGreen,
            ),
          ],
        );
      },
    );
  }

  double _findLinearProgress(Task task, List<dynamic> dates) {
    if (task.studentsOverall == 0 || dates.isEmpty) {
      return 50;
    }
    var timeRange = task.dueDate.difference(task.startDate);
    var timeLeft = task.dueDate.difference(DateTime.now());

    var timeRatio = timeLeft.inMilliseconds / timeRange.inMilliseconds * 100;
    var taskRatio =
        (task.studentsOverall - task.completedBy) / task.studentsOverall * 100;

    if (timeLeft.inMilliseconds > 0) { // not over
      if (task.studentsOverall == task.completedBy) {
        return 100;
      } else {
        return 75 + timeRatio - taskRatio;
      }
    } else { // over due date
      if (task.studentsOverall == task.completedBy) {
        var timeToLastAfterDeadline = task.dueDate.difference(dates.last['x']);
        var timeLastAfterDeadlineRatio = timeToLastAfterDeadline.inMilliseconds / timeRange.inMilliseconds * -100;

        return 100 - timeLastAfterDeadlineRatio;
      } else {
        return 33 - taskRatio;
      }
    }
  }
}
