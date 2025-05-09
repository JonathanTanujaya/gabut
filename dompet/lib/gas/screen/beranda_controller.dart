import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:try2/gas/models/gas_log.dart';
import 'package:try2/gas/service/gas_log_service.dart';

class GasHomeController extends ChangeNotifier {
  final GasLogService service;
  final formKey = GlobalKey<FormState>();
  final distanceController = TextEditingController();
  final costController = TextEditingController();
  final volumeController = TextEditingController();
  bool showAddForm = false;
  double? initialOdometer;

  GasHomeController(this.service) {
    loadInitialOdometer();
  }

  Future<void> loadInitialOdometer() async {
    final box = await Hive.openBox('settings');
    initialOdometer = box.get('initialOdometer');
    notifyListeners();
  }

  Future<void> setInitialOdometer(double value) async {
    final box = await Hive.openBox('settings');
    await box.put('initialOdometer', value);
    initialOdometer = value;
    notifyListeners();
  }

  void toggleAddForm() {
    showAddForm = !showAddForm;
    if (!showAddForm) {
      _clearForm();
    }
    notifyListeners();
  }

  Future<void> saveLog() async {
    if (formKey.currentState!.validate()) {
      final distance = double.parse(distanceController.text);
      final cost = double.parse(costController.text);
      final volume = double.parse(volumeController.text);
      final odometer = (initialOdometer ?? 0) + distance;
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
    volumeController.clear();
  }

  @override
  void dispose() {
    distanceController.dispose();
    costController.dispose();
    volumeController.dispose();
    super.dispose();
  }
}