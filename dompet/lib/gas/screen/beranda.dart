import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:try2/gas/utils/formatters.dart';
import 'package:try2/gas/screen/gas_stats_screen.dart';

import 'package:try2/gas/models/gas_log.dart';
import 'package:try2/gas/service/gas_log_service.dart';

import 'package:try2/gas/widgets/empty_state.dart';
import 'package:try2/gas/widgets/log_item.dart';
import 'package:try2/gas/widgets/stat_card.dart';

class GasHomeScreen extends StatefulWidget {
  const GasHomeScreen({super.key});

  @override
  State<GasHomeScreen> createState() => _GasHomeScreenState();
}

class _GasHomeScreenState extends State<GasHomeScreen> {
  final _distanceController = TextEditingController();
  final _costController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pricePerLiter = 13500.0;
  bool _showAddForm = false;

  @override
  void dispose() {
    _distanceController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _saveLog(GasLogService service) {
    if (_formKey.currentState!.validate()) {
      final distance = double.tryParse(_distanceController.text) ?? 0;
      final cost = double.tryParse(_costController.text) ?? 0;

      if (distance > 0 && cost > 0) {
        final liters = cost / _pricePerLiter;
        final kmPerLiter = distance / liters;

        final log = GasLog(
          date: DateTime.now(),
          distanceKm: distance,
          cost: cost,
          fuelLiters: liters,
          kmPerLiter: kmPerLiter,
        );

        service.addLog(log).then((_) {
          _distanceController.clear();
          _costController.clear();
          setState(() => _showAddForm = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Catatan bensin berhasil disimpan!"),
              backgroundColor: Color(0xFF2E7D32),
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      }
    }
  }

  void _deleteLog(GasLogService service, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hapus Catatan"),
            content: const Text(
              "Apakah Anda yakin ingin menghapus catatan ini?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  service.deleteLog(index).then((_) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Catatan berhasil dihapus"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  });
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<GasLogService>(context);
    final (totalDistance, totalCost, avgEfficiency) = service.calculateStats();
    final logs = service.getLogs();

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
                  builder: (context) => GasStatsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          if (logs.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "Total Jarak",
                      value: "${totalDistance.toStringAsFixed(0)} km",
                      icon: Icons.route,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: "Total Biaya",
                      value: Formatters.currency.format(totalCost),
                      icon: Icons.account_balance_wallet,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: "Rata-rata",
                      value: "${avgEfficiency.toStringAsFixed(1)} km/L",
                      icon: Icons.speed,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Add Form
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showAddForm ? null : 0,
            color: Colors.grey[100],
            padding: EdgeInsets.all(_showAddForm ? 16 : 0),
            child:
                _showAddForm
                    ? Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Tambah Catatan Baru",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _distanceController,
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
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _costController,
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
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  setState(() => _showAddForm = false);
                                },
                                icon: const Icon(Icons.close),
                                label: const Text("Batal"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () => _saveLog(service),
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

          // Logs List
          Expanded(
            child:
                logs.isEmpty
                    ? const EmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: logs.length,
                      itemBuilder: (_, index) {
                        return LogItem(
                          log: logs[index],
                          onDelete: () => _deleteLog(service, index),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _showAddForm = !_showAddForm);
          if (_showAddForm) {
            _distanceController.clear();
            _costController.clear();
          }
        },
        backgroundColor: const Color(0xFF2E7D32),
        child: Icon(_showAddForm ? Icons.close : Icons.add),
      ),
    );
  }
}
