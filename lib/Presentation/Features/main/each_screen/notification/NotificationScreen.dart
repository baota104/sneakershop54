import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  // Danh sách thông báo mẫu (sẽ được thay thế bằng dữ liệu từ API hoặc database sau này)
  final List<NotificationModel> notifications = [
    NotificationModel(
        imageUrl: "assets/images/onboard3.png",
        title: "We Have New Products With Offers",
        timeAgo: "7 min ago",
        oldPrice: "\$364.95",
        newPrice: "\$260.00"),
    NotificationModel(
        imageUrl: "assets/images/onboard3.png",
        title: "We Have New Products With Offers",
        timeAgo: "40 min ago",
        oldPrice: "\$364.95",
        newPrice: "\$260.00"),
    NotificationModel(
        imageUrl: "assets/images/onboard3.png",
        title: "We Have New Products With Offers",
        timeAgo: "40 min ago",
        oldPrice: "\$364.95",
        newPrice: "\$260.00"),
    NotificationModel(
        imageUrl: "assets/images/onboard3.png",
        title: "We Have New Products With Offers",
        timeAgo: "40 min ago",
        oldPrice: "\$364.95",
        newPrice: "\$260.00"),
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
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
      title: Center(
        child: Text(
          "Notifications",
          style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.raleway().fontFamily),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline_outlined, color: Colors.black
          ),
          onPressed: () {},
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  // Danh sách thông báo
  Widget _buildNotificationList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(notifications[index]);
      },
    );
  }

  // Widget hiển thị từng thông báo
  Widget _buildNotificationItem(NotificationModel notification) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Image.asset(notification.imageUrl, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),

          // Nội dung thông báo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
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
        ],
      ),
    );
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
