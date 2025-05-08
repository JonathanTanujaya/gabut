import 'package:flutter/material.dart';
import 'package:try2/gas/models/gas_log.dart';
import 'package:try2/gas/service/gas_log_service.dart';

class GasHomeController extends ChangeNotifier {
  final GasLogService service;
  final formKey = GlobalKey<FormState>();
  final distanceController = TextEditingController();
  final costController = TextEditingController();
  final odometerController = TextEditingController();
  final volumeController = TextEditingController();
  bool showAddForm = false;

  GasHomeController(this.service);

  void toggleAddForm() {
    showAddForm = !showAddForm;
    if (!showAddForm) {
      _clearForm();
    } else {
      // Pre-fill with the last odometer reading if available
      final logs = service.getLogs();
      if (logs.isNotEmpty) {
        odometerController.text = logs.first.odometer.toString();
      }
    }
    notifyListeners();
  }

  Future<void> saveLog() async {
    if (formKey.currentState!.validate()) {
      final distance = double.parse(distanceController.text);
      final cost = double.parse(costController.text);
      final odometer = double.parse(odometerController.text);
      final volume = double.parse(volumeController.text);

      final kmPerLiter = distance / volume;

      final log = GasLog(
        date: DateTime.now(),
        distance: distance,
        cost: cost,
        odometer: odometer,
        volume: volume,
        kmPerLiter: kmPerLiter,
      );

      await service.addLog(log);
      toggleAddForm();
      notifyListeners();
    }
  }

  Future<void> deleteLog(int index) async {
    await service.deleteLog(index);
    notifyListeners();
  }

  void _clearForm() {
    distanceController.clear();
    costController.clear();
    odometerController.clear();
    volumeController.clear();
  }

  @override
  void dispose() {
    distanceController.dispose();
    costController.dispose();
    odometerController.dispose();
    volumeController.dispose();
    super.dispose();
  }
}