import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:try2/gas/service/cache_log_service.dart';
import '../models/gas_log.dart';


class GasLogService extends ChangeNotifier {
  late final Box<GasLog> _gasBox;
  GasLogCache _cache = GasLogCache.fromLogs([]);

  GasLogService() {
    _init();
  }

  Future<void> _init() async {
    _gasBox = Hive.box<GasLog>('gas_logs');
    _updateCache();
  }

  List<GasLog> getLogs() => _cache.logs;

  GasLogCache get cache => _cache;

  Future<void> addLog(GasLog log) async {
    await _gasBox.add(log);
    _updateCache();
    notifyListeners();
  }

  Future<void> deleteLog(int index) async {
    final key = _gasBox.keyAt(_gasBox.length - 1 - index);
    await _gasBox.delete(key);
    _updateCache();
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _gasBox.clear();
    _updateCache();
    notifyListeners();
  }

  void _updateCache() {
    final rawLogs = _gasBox.values.toList();
    _cache = GasLogCache.fromLogs(rawLogs);
  }

  // Jika masih ingin tuple, bisa juga dipakai:
  (double, double, double) calculateStats() {
    return (
      _cache.totalDistance,
      _cache.totalCost,
      _cache.averageEfficiency,
    );
  }
}
