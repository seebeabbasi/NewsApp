import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                child: Icon(Icons.person, size: 60, color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              const SizedBox(height: 16),
              const Text(
                "williams",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "williams@example.com",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Dark Mode"),
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                subtitle: Text("Notifications, preferences, and more"),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.help_outline),
                title: Text("Help & Support"),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}