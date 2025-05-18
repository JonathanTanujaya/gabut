import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.palette),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const ThemeSwitcherDialog(),
        );
      },
    );
  }
}

class ThemeSwitcherDialog extends StatelessWidget {
  const ThemeSwitcherDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final List<ThemeOption> themeOptions = [
      ThemeOption(
        name: 'Dark Gold',
        icon: Icons.nights_stay,
        color: const Color(0xFFD4AF37),
        description: 'Dark theme with gold accents',
      ),
      ThemeOption(
        name: 'Navy Blue',
        icon: Icons.brightness_5,
        color: const Color(0xFF0A386B),
        description: 'Light theme with navy and red accents',
      ),
      ThemeOption(
        name: 'Purple Teal',
        icon: Icons.spa,
        color: const Color(0xFF6A1B9A),
        description: 'Light theme with purple and teal accents',
      ),
      ThemeOption(
        name: 'Teal Orange',
        icon: Icons.wb_twilight,
        color: const Color(0xFF009688),
        description: 'Light theme with teal and orange accents',
      ),
      ThemeOption(
        name: 'Dark Emerald',
        icon: Icons.forest,
        color: const Color(0xFF006D5B),
        description: 'Dark theme with emerald and silver accents',
      ),
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Tema',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(themeOptions.length, (index) {
              final theme = themeOptions[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    theme.icon,
                    color: theme.color,
                  ),
                ),
                title: Text(theme.name),
                subtitle: Text(
                  theme.description,
                  style: TextStyle(fontSize: 12),
                ),
                selected: themeProvider.theme.primaryColor == theme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () {
                  // Change theme
                  while (themeProvider.theme.primaryColor != theme.color) {
                    themeProvider.nextTheme();
                  }
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ThemeOption {
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  ThemeOption({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
} 