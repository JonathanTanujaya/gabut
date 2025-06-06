import 'package:home_widget/home_widget.dart';

class WidgetService {
  /// Update saldo reimburse ke widget home
  static Future<void> updateReimburseSaldo(int saldo) async {
    await HomeWidget.saveWidgetData<int>('saldo_reimburse', saldo);
    await HomeWidget.updateWidget(
      name: 'DompetWidgetProvider',
      iOSName: 'DompetWidget',
    );
  }

  /// Update odometer dan efisiensi ke widget home
  static Future<void> updateOdometer(int odometer, double efficiency) async {
    await HomeWidget.saveWidgetData<int>('odometer', odometer);
    await HomeWidget.saveWidgetData<double>('efficiency', efficiency);
    await HomeWidget.updateWidget(
      name: 'GasWidgetProvider',
      iOSName: 'GasWidget',
    );
  }
}
