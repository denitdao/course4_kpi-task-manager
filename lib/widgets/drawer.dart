import 'package:flutter/material.dart';
import 'package:task_manager/constants/supabase_constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }
  }

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
                    title: const Text('All'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/all");
                    },
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    title: const Text('Subject List'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/subjects");
                    },
                  ),
                  ListTile(
                    title: const Text('Subject Tasks'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/subject_tasks");
                    },
                  ),
                  ListTile(
                    title: const Text('Some'),
                    onTap: () {
                      Navigator.pushNamed(context, "/some");
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
                  ListTile(
                    title: const Text('Create subject'),
                    onTap: () {
                      Navigator.pushNamed(context, "/subject_create");
                    },
                  ),
                  ListTile(
                    title: const Text('Edit subject'),
                    onTap: () {
                      Navigator.pushNamed(context, "/subject_edit");
                    },
                  ),
                  ListTile(
                    title: const Text('Log out'),
                    onTap: () => _signOut(context),
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
