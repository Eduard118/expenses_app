import 'package:expensesapp/models/transaction.dart';
import 'package:expensesapp/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationServiceImpl extends NotificationService {

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    var onDidReceiveLocalNotification;
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    var flutterLocalNotificationsPlugin;
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }


  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here
  }
  void showNotification(TransactionModel transactionModel, String notificationMessage){

  }
}

