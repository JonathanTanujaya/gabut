import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:try2/gas/screen/beranda_controller.dart'; // Fixed the import path
import 'package:try2/gas/utils/formatters.dart';
import 'package:try2/gas/screen/gas_stats_screen.dart';
import 'package:try2/gas/widgets/empty_state.dart';
import 'package:try2/gas/widgets/log_item.dart';
import 'package:try2/gas/widgets/stat_card.dart';

class GasHomeScreen extends StatelessWidget {
  const GasHomeScreen({super.key});

  void _showDeleteDialog(
      BuildContext context, GasHomeController controller, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Hapus Catatan"),
        content: const Text("Apakah Anda yakin ingin menghapus catatan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
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
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GasHomeController>(
      builder: (context, controller, child) {
        final logs = controller.service.getLogs();
        final (totalDistance, totalCost, avgEfficiency) =
            controller.service.calculateStats();
        
        // Get the latest odometer if available
        final latestOdometer = logs.isNotEmpty ? logs.first.odometer : 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Catatan Bensin"),
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics_outlined),
                onPressed: () {
                  if (logs.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tidak ada data untuk ditampilkan."),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
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
          body: Column(
            children: [
              // Dashboard area with gradients
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1A1A1A),
                      const Color(0xFF121212),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard title
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dashboard Bensin",
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: const Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Add new entry button
                          OutlinedButton.icon(
                            onPressed: () => controller.toggleAddForm(),
                            icon: Icon(
                              controller.showAddForm ? Icons.close : Icons.add,
                              color: const Color(0xFFD4AF37),
                            ),
                            label: Text(
                              controller.showAddForm ? "Tutup" : "Tambah Catatan",
                              style: const TextStyle(color: Color(0xFFD4AF37)),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFD4AF37)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Odometer Card
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF2A2A2A),
                            const Color(0xFF222222),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.speed,
                                color: const Color(0xFFD4AF37),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Odometer Terakhir",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${latestOdometer.toStringAsFixed(0)}",
                                style: TextStyle(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "km",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: Text(
                          "Tambahkan catatan bensin untuk melihat statistik",
                          style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
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
                color: const Color(0xFF1A1A1A),
                padding: EdgeInsets.all(controller.showAddForm ? 16 : 0),
                child: controller.showAddForm
                    ? Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Tambah Catatan Baru",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.odometerController, // Assume you'll add this
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Odometer (km)',
                                      prefixIcon: Icon(Icons.speed),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Odometer tidak boleh kosong';
                                      }
                                      if (double.tryParse(value) == null ||
                                          double.parse(value) <= 0) {
                                        return 'Masukkan angka yang valid';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.distanceController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Jarak Tempuh (km)',
                                      prefixIcon: Icon(Icons.straighten),
                                    ),
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
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.volumeController, // Assume you'll add this
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Volume (L)',
                                      prefixIcon: Icon(Icons.local_gas_station),
                                    ),
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
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.costController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Biaya Isi (Rp)',
                                      prefixIcon: Icon(Icons.attach_money),
                                    ),
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
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => controller.toggleAddForm(),
                                  icon: const Icon(Icons.close),
                                  label: const Text("Batal"),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      await controller.saveLog();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Catatan bensin berhasil disimpan!"),
                                          backgroundColor: Color(0xFF2E7D32),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    } catch (e) {
                                      // Handle error jika diperlukan
                                    }
                                  },
                                  icon: const Icon(Icons.save),
                                  label: const Text("Simpan"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              
              // Divider
              const Divider(height: 1),
              
              // Logs list
              Expanded(
                child: logs.isEmpty
                    ? const EmptyState()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              "Riwayat Catatan",
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: const Color(0xFFD4AF37),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: logs.length,
                              itemBuilder: (_, index) {
                                return LogItem(
                                  log: logs[index],
                                  onDelete: () =>
                                      _showDeleteDialog(context, controller, index),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}