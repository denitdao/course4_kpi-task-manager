import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/pages/teacher/subjects_page/subject_list_cubit.dart';
import 'package:task_manager/pages/teacher/subjects_page/subject_list_page.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectListCubit, SubjectListState>(
      buildWhen: (previous, current) => previous.groups != current.groups,
      builder: (context, state) {
        List<Widget> groupTiles = [];
        String? selectedGroup = state.groupId;

        for (var group in state.groups) {
          groupTiles.add(
            ListTile(
              title: Text(group.title),
              selected:
                  (selectedGroup == null) ? false : group.id == selectedGroup,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectListPage(
                      groupId: group.id,
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
                        title: const Text('All subjects'),
                        selected: selectedGroup == null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubjectListPage(),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      ...groupTiles,
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
