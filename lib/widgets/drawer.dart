import 'package:flutter/material.dart';

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
                    title: const Text('Subject 1'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Subject 2'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Subject 3'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Subject 3'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Subject 3'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Subject 3'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Subject 3'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Subject 3'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Some'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/some");
                    },
                  ),
                  ListTile(
                    title: const Text('Some'),
                    onTap: () {
                      Navigator.pushNamed(context, "/some");
                    },
                  ),
                  ListTile(
                    title: const Text('Log out'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/login");
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
