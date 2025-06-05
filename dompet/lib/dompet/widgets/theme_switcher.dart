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

  // Method untuk mendapatkan warna sekunder berdasarkan index tema
  Color _getSecondaryColor(int index) {
    final List<Color> secondaryColors = [
      Color(0xFFD4AF37), // Gold untuk Dark Gold
      Color(0xFFFF6B6B), // Coral untuk Midnight Blue
      Color(0xFF00D4FF), // Electric Blue untuk Deep Purple
      Color(0xFFFFC107), // Amber untuk Forest Green
      Color(0xFFE91E63), // Rose Pink untuk Rose Gold
    ];
    return index < secondaryColors.length ? secondaryColors[index] : Colors.grey;
  }

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
        name: 'Midnight Blue',
        icon: Icons.water,
        color: const Color(0xFF1A237E),
        description: 'Dark theme with coral accents',
      ),
      ThemeOption(
        name: 'Deep Purple',
        icon: Icons.auto_awesome,
        color: const Color(0xFF2D1B69),
        description: 'Dark theme with electric blue accents',
      ),
      ThemeOption(
        name: 'Forest Green',
        icon: Icons.eco,
        color: const Color(0xFF1B5E20),
        description: 'Dark theme with amber accents',
      ),
      ThemeOption(
        name: 'Rose Gold',
        icon: Icons.favorite,
        color: const Color(0xFF37474F),
        description: 'Dark theme with rose pink accents',
      ),
    ];    return Dialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).dialogBackgroundColor,
              Theme.of(context).dialogBackgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Pilih Tema',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),            ...List.generate(themeOptions.length, (index) {
              final theme = themeOptions[index];
              final currentTheme = Theme.of(context);              return Tooltip(
                message: '${theme.name}: ${theme.description}',
                child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.color.withOpacity(0.3),
                        theme.color.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: themeProvider.currentThemeIndex == index
                        ? Border.all(color: currentTheme.colorScheme.secondary, width: 2)
                        : Border.all(color: theme.color.withOpacity(0.5), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: theme.color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          theme.icon,
                          color: theme.color,
                          size: 20,
                        ),
                        // Badge untuk tema aktif
                        if (themeProvider.currentThemeIndex == index)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: currentTheme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        theme.name,
                        style: TextStyle(
                          color: currentTheme.colorScheme.onSurface,
                          fontWeight: themeProvider.currentThemeIndex == index 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    // Preview warna sekunder tema
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _getSecondaryColor(index),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: currentTheme.colorScheme.outline.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  theme.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: currentTheme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                selected: themeProvider.currentThemeIndex == index,
                selectedTileColor: currentTheme.colorScheme.secondary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),                onTap: () {
                  // Change theme directly to the selected index
                  themeProvider.setTheme(index);
                  Navigator.pop(context);
                },
              ),
            );
            }),
          ],
        ),
      ),
    ));
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