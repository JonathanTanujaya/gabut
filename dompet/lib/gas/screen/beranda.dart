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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Hapus Catatan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          "Apakah Anda yakin ingin menghapus catatan ini?",
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.secondary,
            ),
            child: const Text("Batal"),
          ),          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
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
        controller.deleteLog(index).then((_) {          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Catatan berhasil dihapus"),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(12),
              shape: const RoundedRectangleBorder(
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
    final theme = Theme.of(context);
    final TextEditingController inputController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Masukkan Odometer Awal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: TextField(
          controller: inputController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Contoh: 12000',
            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
          ),
        ),        actions: [
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(inputController.text);
              if (value != null && value > 0) {
                controller.setInitialOdometer(value);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
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
    final theme = Theme.of(context);
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
        final latestOdometer = initialOdometer + totalLogDistance;        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                context.watch<ThemeProvider>().themeIcon,
                color: context.watch<ThemeProvider>().themeIconColor,
              ),
              tooltip: 'Ganti Tema',
              onPressed: () => context.read<ThemeProvider>().nextTheme(),
            ),
            title: Text(
              "Catatan Bensin", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.analytics_outlined, 
                  color: theme.colorScheme.secondary,
                ),                onPressed: () {
                  if (logs.isEmpty) {                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Tidak ada data untuk ditampilkan."),
                        backgroundColor: theme.colorScheme.tertiary,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(12),
                        shape: const RoundedRectangleBorder(
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
                        children: [                          // Dashboard area with gradients
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  theme.scaffoldBackgroundColor,
                                  theme.scaffoldBackgroundColor.withOpacity(0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [                                // Tombol set odometer awal jika belum diisi
                                if (controller.initialOdometer == null) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.speed),
                                      label: const Text('Set Odometer Awal'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.colorScheme.secondary,
                                        foregroundColor: theme.colorScheme.onSecondary,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                      onPressed: () => _showInitialOdometerDialog(context, controller),
                                    ),
                                  ),
                                ],                                // Dashboard title
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Dashboard Bensin",
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      // Add new entry button
                                      ElevatedButton.icon(
                                        onPressed: () => controller.toggleAddForm(),
                                        icon: Icon(
                                          controller.showAddForm ? Icons.close : Icons.add,
                                          color: theme.colorScheme.onSecondary,
                                        ),
                                        label: Text(
                                          controller.showAddForm ? "Tutup" : "Tambah Catatan",
                                          style: TextStyle(
                                            color: theme.colorScheme.onSecondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: theme.colorScheme.secondary,
                                          foregroundColor: theme.colorScheme.onSecondary,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),                                // Odometer Card
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        theme.colorScheme.surface,
                                        theme.colorScheme.surface.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.shadowColor.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: theme.colorScheme.outline.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.speed,
                                            color: theme.colorScheme.secondary,
                                            size: 26,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Odometer Terakhir",
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface.withOpacity(0.7),
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
                                                style: TextStyle(
                                                  color: theme.colorScheme.secondary,
                                                  fontSize: 38,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "km",
                                                style: TextStyle(
                                                  color: theme.colorScheme.onSurface,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),                                // Stats Cards
                                if (logs.isNotEmpty) ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: StatCard(
                                          title: "Total Jarak",
                                          value: "${totalDistance.toStringAsFixed(0)} km",
                                          icon: Icons.route,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: StatCard(
                                          title: "Total Biaya",
                                          value: Formatters.currency.format(totalCost),
                                          icon: Icons.account_balance_wallet,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: StatCard(
                                          title: "Rata-rata",
                                          value: "${avgEfficiency.toStringAsFixed(1)} km/L",
                                          icon: Icons.local_gas_station,
                                          color: theme.colorScheme.secondary,
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
                                        Icon(
                                          Icons.info_outline,
                                          color: theme.colorScheme.onSurface.withOpacity(0.38),
                                          size: 32,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "Tambahkan catatan bensin untuk melihat statistik",
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface.withOpacity(0.54),
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
                          ),                          // Add form
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: controller.showAddForm ? null : 0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.2),
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
                                                color: theme.colorScheme.secondary,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Icon(Icons.straighten, color: theme.colorScheme.secondary),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: TextFormField(
                                                controller: controller.distanceController,
                                                keyboardType: TextInputType.number,                                                decoration: InputDecoration(
                                                  labelText: 'Jarak Tempuh (km)',
                                                  labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: theme.colorScheme.error),
                                                  ),
                                                  filled: true,
                                                  fillColor: theme.colorScheme.surfaceVariant,
                                                ),
                                                style: TextStyle(color: theme.colorScheme.onSurface),
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
                                        const SizedBox(height: 16),                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: controller.volumeController,
                                                keyboardType: TextInputType.number,                                                decoration: InputDecoration(
                                                  labelText: 'Volume (L)',
                                                  labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                                                  prefixIcon: Icon(Icons.local_gas_station, color: theme.colorScheme.secondary),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: theme.colorScheme.error),
                                                  ),
                                                  filled: true,
                                                  fillColor: theme.colorScheme.surfaceVariant,
                                                ),
                                                style: TextStyle(color: theme.colorScheme.onSurface),
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
                                            const SizedBox(width: 16),                                            Expanded(
                                              child: TextFormField(
                                                controller: controller.costController,
                                                keyboardType: TextInputType.number,                                                decoration: InputDecoration(
                                                  labelText: 'Biaya Isi (Rp)',
                                                  labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                                                  prefixIcon: Icon(Icons.attach_money, color: theme.colorScheme.secondary),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: theme.colorScheme.secondary),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: theme.colorScheme.error),
                                                  ),
                                                  filled: true,
                                                  fillColor: theme.colorScheme.surfaceVariant,
                                                ),
                                                style: TextStyle(color: theme.colorScheme.onSurface),
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
                                        const SizedBox(height: 24),                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () => controller.toggleAddForm(),
                                              icon: const Icon(Icons.close),
                                              label: const Text("Batal"),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: theme.colorScheme.onSurface.withOpacity(0.7),
                                                side: BorderSide(color: theme.colorScheme.outline),
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
                                                  await controller.saveLog();                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Catatan bensin berhasil disimpan!",
                                                      ),
                                                      backgroundColor: theme.colorScheme.secondary,
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
                                                backgroundColor: theme.colorScheme.secondary,
                                                foregroundColor: theme.colorScheme.onSecondary,
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
                          ),                          // Divider
                          Divider(height: 1, color: theme.colorScheme.outline.withOpacity(0.3)),

                          // Logs list
                          SizedBox(
                            height: constraints.maxHeight - 400, // 400 bisa disesuaikan sesuai tinggi dashboard+form+divider
                            child: logs.isEmpty
                                ? const EmptyState()
                                : Container(
                                    color: theme.scaffoldBackgroundColor,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.history,
                                                color: theme.colorScheme.secondary,
                                                size: 22,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Riwayat Catatan",
                                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                      color: theme.colorScheme.secondary,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.surface,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: theme.shadowColor.withOpacity(0.2),
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