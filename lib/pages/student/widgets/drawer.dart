import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/pages/student/tasks_page/task_list_cubit.dart';
import 'package:task_manager/pages/student/tasks_page/task_list_page.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListCubit, TaskListState>(
      buildWhen: (previous, current) => previous.subjects != current.subjects,
      builder: (context, state) {
        List<Widget> subjectTiles = [];

        for (var subject in state.subjects) {
          subjectTiles.add(
            ListTile(
              title: Text(subject.title),
              selected: subject.id == state.subjectId,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskListPage(
                      pageTitle: subject.title + ' Tasks',
                      subjectId: subject.id,
                    ),
                  ),
                );
              },
            ),
          );
        }

        return SafeArea(
          child: Drawer(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    children: [
                      ListTile(
                        title: const Text('Today'),
                        selected: state.range == 1,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskListPage(
                                pageTitle: 'Today',
                                range: 1,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('This week'),
                        selected: state.range == 7,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskListPage(
                                pageTitle: 'This week',
                                range: 7,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('All tasks'),
                        selected:
                            state.range == null && state.subjectId == null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskListPage(
                                pageTitle: 'All tasks',
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      ...subjectTiles,
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pushNamed(context, "/settings");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
