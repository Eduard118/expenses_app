import 'package:expensesapp/models/transaction.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationService {
  /*static final NotificationService _notificationService = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();*/

  Future<void> init(/*Future<dynamic> Function(*//*int, String?, String?, String?)? onDidReceive*/);
  Future selectNotification(String? payload);
  void showNotification(TransactionModel transactionModel, String notificationMessage);

}