import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spozfy/services/cricket_service.dart';
import 'package:spozfy/services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final CricketService _service = CricketService();

  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: GoogleFonts.acme(fontSize: 20),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _service.getRecentMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No notifications",
                style: GoogleFonts.aBeeZee(fontSize: 18),
              ),
            );
          }

          final notifications = snapshot.data!.take(5).toList();

          // 🔥 SEND SYSTEM NOTIFICATIONS ONLY ONCE
          if (!_sent) {
            _sent = true;
            NotificationService.showLatestThree(snapshot.data!);
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];

              return ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(
                  item['name'] ?? "Match Update",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.acme(fontSize: 16),
                ),
                subtitle: Text(
                  item['status'] ?? "No status",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.acme(fontSize: 16),
                ),
                trailing: Text(
                  item['date']?.toString() ?? "",
                  style: GoogleFonts.acme(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}