import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Danh sách thông báo mẫu
  List<NotificationModel> notifications = [
    NotificationModel(
      imageUrl: "assets/images/onboard3.png",
      title: "We Have New Products With Offers",
      timeAgo: "7 min ago",
      oldPrice: "\$364.95",
      newPrice: "\$260.00",
    ),
    NotificationModel(
      imageUrl: "assets/images/onboard3.png",
      title: "Limited Time Offer Just for You",
      timeAgo: "40 min ago",
      oldPrice: "\$250.00",
      newPrice: "\$199.00",
    ),
    NotificationModel(
      imageUrl: "assets/images/onboard3.png",
      title: "Special Sale on Your Favorite Items",
      timeAgo: "1 hour ago",
      oldPrice: "\$500.00",
      newPrice: "\$350.00",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(child: _buildNotificationList()),
          ],
        ),
      ),
    );
  }

  // AppBar của màn hình
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        "Notifications",
        style: GoogleFonts.raleway(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline_outlined, color: Colors.black),
          onPressed: _clearNotifications, // Xóa tất cả thông báo
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  // Danh sách thông báo
  Widget _buildNotificationList() {
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          "No notifications available",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(notifications[index], index);
      },
    );
  }

  // Widget hiển thị từng thông báo
  Widget _buildNotificationItem(NotificationModel notification, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm với kiểm tra lỗi
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Image.asset(
              notification.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.image, color: Colors.grey),
            ),
          ),
          SizedBox(width: 10),

          // Nội dung thông báo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      notification.oldPrice,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      notification.newPrice,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Thời gian thông báo
          Text(
            notification.timeAgo,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          // Nút xóa từng thông báo
          IconButton(
            icon: Icon(Icons.close, size: 18, color: Colors.grey),
            onPressed: () => _removeNotification(index),
          ),
        ],
      ),
    );
  }

  // Xóa một thông báo
  void _removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  // Xóa tất cả thông báo
  void _clearNotifications() {
    setState(() {
      notifications.clear();
    });
  }
}

// Model thông báo
class NotificationModel {
  final String imageUrl;
  final String title;
  final String timeAgo;
  final String oldPrice;
  final String newPrice;

  NotificationModel({
    required this.imageUrl,
    required this.title,
    required this.timeAgo,
    required this.oldPrice,
    required this.newPrice,
  });
}
