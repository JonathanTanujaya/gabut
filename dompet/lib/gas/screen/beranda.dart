import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:try2/gas/screen/beranda_controller.dart';
import 'package:try2/gas/utils/formatters.dart';
import 'package:try2/gas/screen/gas_stats_screen.dart';
import 'package:try2/gas/widgets/empty_state.dart';
import 'package:try2/gas/widgets/log_item.dart';
import 'package:try2/gas/widgets/stat_card.dart';
import 'package:try2/theme.dart';


class GasHomeScreen extends StatelessWidget {
  const GasHomeScreen({super.key});

  void _showDeleteDialog(
    BuildContext context,
    GasHomeController controller,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Hapus Catatan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Apakah Anda yakin ingin menghapus catatan ini?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Hapus"),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        controller.deleteLog(index).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Catatan berhasil dihapus"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          );
        });
      }
    });
  }

  void _showInitialOdometerDialog(
    BuildContext context,
    GasHomeController controller,
  ) {
    final TextEditingController inputController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Masukkan Odometer Awal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: inputController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Contoh: 12000',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD4AF37)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFF292929),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(inputController.text);
              if (value != null && value > 0) {
                controller.setInitialOdometer(value);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GasHomeController>(
      builder: (context, controller, child) {
        final logs = controller.service.getLogs();
        final (totalDistance, totalCost, avgEfficiency) =
            controller.service.calculateStats();

        // Hitung total jarak tempuh dari semua log
        final totalLogDistance = logs.fold<double>(0, (sum, log) => sum + log.distance);
        // Odometer awal dari input user (hanya bisa diisi sekali)
        final initialOdometer = controller.initialOdometer ?? 0;
        // Odometer terakhir = odometer awal + total jarak tempuh
        final latestOdometer = initialOdometer + totalLogDistance;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                context.watch<ThemeProvider>().themeIcon,
                color: context.watch<ThemeProvider>().themeIconColor,
              ),
              tooltip: 'Ganti Tema',
              onPressed: () => context.read<ThemeProvider>().nextTheme(),
            ),
            title: const Text(
              "Catatan Bensin", 
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics_outlined, color: Color(0xFFD4AF37)),
                onPressed: () {
                  if (logs.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tidak ada data untuk ditampilkan."),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GasStatsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Dashboard area with gradients
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF1A1A1A), Color(0xFF121212)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tombol set odometer awal jika belum diisi
                                if (controller.initialOdometer == null) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.speed),
                                      label: const Text('Set Odometer Awal'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFD4AF37),
                                        foregroundColor: Colors.black,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                      onPressed: () => _showInitialOdometerDialog(context, controller),
                                    ),
                                  ),
                                ],

                                // Dashboard title
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Dashboard Bensin",
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          color: const Color(0xFFD4AF37),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      // Add new entry button
                                      ElevatedButton.icon(
                                        onPressed: () => controller.toggleAddForm(),
                                        icon: Icon(
                                          controller.showAddForm ? Icons.close : Icons.add,
                                          color: Colors.black,
                                        ),
                                        label: Text(
                                          controller.showAddForm ? "Tutup" : "Tambah Catatan",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFD4AF37),
                                          foregroundColor: Colors.black,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Odometer Card
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF2A2A2A),
                                        Color(0xFF1E1E1E),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.speed,
                                            color: Color(0xFFD4AF37),
                                            size: 26,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Odometer Terakhir",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${latestOdometer.toStringAsFixed(0)}",
                                                style: const TextStyle(
                                                  color: Color(0xFFD4AF37),
                                                  fontSize: 38,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "km",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Stats Cards
                                if (logs.isNotEmpty) ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: StatCard(
                                          title: "Total Jarak",
                                          value: "${totalDistance.toStringAsFixed(0)} km",
                                          icon: Icons.route,
                                          color: const Color(0xFFD4AF37),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: StatCard(
                                          title: "Total Biaya",
                                          value: Formatters.currency.format(totalCost),
                                          icon: Icons.account_balance_wallet,
                                          color: const Color(0xFFD4AF37),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: StatCard(
                                          title: "Rata-rata",
                                          value: "${avgEfficiency.toStringAsFixed(1)} km/L",
                                          icon: Icons.local_gas_station,
                                          color: const Color(0xFFD4AF37),
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  // Empty state for stats
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          color: Colors.white38,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          "Tambahkan catatan bensin untuk melihat statistik",
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Add form
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: controller.showAddForm ? null : 0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(controller.showAddForm ? 20 : 0),
                            child: controller.showAddForm
                                ? Form(
                                    key: controller.formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "Tambah Catatan Baru",
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFFD4AF37),
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Icon(Icons.straighten, color: Color(0xFFD4AF37)),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: TextFormField(
                                                controller: controller.distanceController,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'Jarak Tempuh (km)',
                                                  labelStyle: const TextStyle(color: Colors.white70),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(color: Colors.red),
                                                  ),
                                                  filled: true,
                                                  fillColor: const Color(0xFF222222),
                                                ),
                                                style: const TextStyle(color: Colors.white),
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Jarak tidak boleh kosong';
                                                  }
                                                  if (double.tryParse(value) == null ||
                                                      double.parse(value) <= 0) {
                                                    return 'Masukkan jarak yang valid';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: controller.volumeController,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'Volume (L)',
                                                  labelStyle: const TextStyle(color: Colors.white70),
                                                  prefixIcon: const Icon(Icons.local_gas_station, color: Color(0xFFD4AF37)),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(color: Colors.red),
                                                  ),
                                                  filled: true,
                                                  fillColor: const Color(0xFF222222),
                                                ),
                                                style: const TextStyle(color: Colors.white),
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Volume tidak boleh kosong';
                                                  }
                                                  if (double.tryParse(value) == null ||
                                                      double.parse(value) <= 0) {
                                                    return 'Masukkan volume yang valid';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: TextFormField(
                                                controller: controller.costController,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'Biaya Isi (Rp)',
                                                  labelStyle: const TextStyle(color: Colors.white70),
                                                  prefixIcon: const Icon(Icons.attach_money, color: Color(0xFFD4AF37)),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(color: Colors.red),
                                                  ),
                                                  filled: true,
                                                  fillColor: const Color(0xFF222222),
                                                ),
                                                style: const TextStyle(color: Colors.white),
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Biaya tidak boleh kosong';
                                                  }
                                                  if (double.tryParse(value) == null ||
                                                      double.parse(value) <= 0) {
                                                    return 'Masukkan biaya yang valid';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () => controller.toggleAddForm(),
                                              icon: const Icon(Icons.close),
                                              label: const Text("Batal"),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.grey[400],
                                                side: BorderSide(color: Colors.grey[600]!),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                try {
                                                  await controller.saveLog();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Catatan bensin berhasil disimpan!",
                                                      ),
                                                      backgroundColor: Color(0xFF2E7D32),
                                                      behavior: SnackBarBehavior.floating,
                                                      margin: EdgeInsets.all(12),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  // Handle error jika diperlukan
                                                }
                                              },
                                              icon: const Icon(Icons.save),
                                              label: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFD4AF37),
                                                foregroundColor: Colors.black,
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          // Divider
                          const Divider(height: 1, color: Color(0xFF333333)),

                          // Logs list
                          SizedBox(
                            height: constraints.maxHeight - 400, // 400 bisa disesuaikan sesuai tinggi dashboard+form+divider
                            child: logs.isEmpty
                                ? const EmptyState()
                                : Container(
                                    color: const Color(0xFF121212),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.history,
                                                color: Color(0xFFD4AF37),
                                                size: 22,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Riwayat Catatan",
                                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                      color: const Color(0xFFD4AF37),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1A1A1A),
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                            margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                            child: ListView.builder(
                                              padding: const EdgeInsets.all(8),
                                              itemCount: logs.length,
                                              itemBuilder: (_, index) {
                                                return LogItem(
                                                  log: logs[index],
                                                  onDelete: () => _showDeleteDialog(
                                                    context,
                                                    controller,
                                                    index,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}