import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:try2/gas/models/gas_log.dart';
import 'package:try2/theme.dart';

import 'package:try2/gas/screen/beranda.dart';
import 'package:try2/dompet/screens/home_screen.dart';
import 'package:try2/gas/screen/beranda_controller.dart';
import 'package:try2/gas/service/gas_log_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(GasLogAdapter());
  await Hive.openBox<GasLog>('gas_logs');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => GasLogService()),
        ChangeNotifierProxyProvider<GasLogService, GasHomeController>(
          create: (context) => GasHomeController(context.read<GasLogService>()),
          update: (context, service, controller) =>
              controller ?? GasHomeController(service),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Dompet Premium',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.theme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const GasHomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Dompet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station),
            label: 'Bensin',
          ),
        ],
      ),
    );
  }
}