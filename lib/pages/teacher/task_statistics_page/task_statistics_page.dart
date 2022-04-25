import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/teacher_auth_required_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/user_task_status.dart';
import 'package:task_manager/pages/teacher/task_edit_page/task_edit_cubit.dart';
import 'package:task_manager/pages/teacher/task_statistics_page/task_statistics_cubit.dart';
import 'package:task_manager/theme/light_color.dart';
import 'package:task_manager/widgets/date_picker.dart';

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
          ),
          primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.percentPattern(),
            rangePadding: ChartRangePadding.round,
          ),
          series: <ChartSeries>[
            LineSeries<dynamic, DateTime>(
              dataSource: state.taskPerformance,
              xValueMapper: (value, _) => value['x'],
              yValueMapper: (value, _) => value['y'],
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
        );
      },
    );
  }
}
