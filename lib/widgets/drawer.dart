import 'package:flutter/material.dart';
import 'package:task_manager/constants/supabase_constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                children: [
                  ListTile(
                    selected: true,
                    title: const Text('Today'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/today");
                    },
                  ),
                  ListTile(
                    title: const Text('This week'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/this_week");
                    },
                  ),
                  ListTile(
                    title: const Text('All tasks'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/all");
                    },
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    title: const Text('All subjects'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/subjects");
                    },
                  ),
                  ListTile(
                    title: const Text('Create task'),
                    onTap: () {
                      Navigator.pushNamed(context, "/task_create");
                    },
                  ),
                  ListTile(
                    title: const Text('Edit task'),
                    onTap: () {
                      Navigator.pushNamed(context, "/task_edit");
                    },
                  ),
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
  }
}
