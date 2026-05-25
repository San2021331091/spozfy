import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spozfy/app.dart';
import 'package:spozfy/services/notification_service.dart';
import 'package:spozfy/services/startup_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await NotificationService.init();

  await StartAppService.initialize();

  runApp(const MyApp());
}