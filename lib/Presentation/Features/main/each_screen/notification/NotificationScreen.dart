import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
    NotificationModel(
      imageUrl: "assets/images/onboard3.png",
      title: "Special Sale on Your Favorite Items",
      timeAgo: "1 hour ago",
      oldPrice: "\$500.00",
      newPrice: "\$350.00",
    ),
    NotificationModel(
      imageUrl: "assets/images/onboard3.png",
      title: "Special Sale on Your Favorite Items",
      timeAgo: "1 hour ago",
      oldPrice: "\$500.00",
      newPrice: "\$350.00",
    ),
    NotificationModel(
      imageUrl: "assets/images/onboard3.png",
      title: "Special Sale on Your Favorite Items",
      timeAgo: "1 hour ago",
      oldPrice: "\$500.00",
      newPrice: "\$350.00",
    ),
    NotificationModel(
      imageUrl: "assets/images/onboard3.png",
      title: "Special Sale on Your Favorite Items",
      timeAgo: "1 hour ago",
      oldPrice: "\$500.00",
      newPrice: "\$350.00",
    ),
    NotificationModel(
      imageUrl: "assets/images/onboard3.png",
      title: "Special Sale on Your Favorite Items",
      timeAgo: "1 hour ago",
      oldPrice: "\$500.00",
      newPrice: "\$350.00",
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Color(0xFFF7F7F9),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Recent",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(child: _buildNotificationList(screenWidth, screenHeight)),
          ],
        ),
      ),
    );
  }

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
        GestureDetector(
          onTap: () => _clearNotifications(),
          child: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(Icons.delete_outline_rounded, size: 30),
          ),
        )
      ],
      backgroundColor: Color(0xFFF7F7F9),
      elevation: 0,
    );
  }

  Widget _buildNotificationList(double screenWidth, double screenHeight) {
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          "No notifications available",
          style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(notifications[index], index, screenWidth, screenHeight);
      },
    );
  }

  Widget _buildNotificationItem(NotificationModel notification, int index, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFFF7F7F9),
            ),
            child: Image.asset(
              notification.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.image, color: Colors.grey, size: screenWidth * 0.1),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: GoogleFonts.raleway(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Row(
                  children: [
                    Text(
                      notification.oldPrice,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black54,
                        decoration: TextDecoration.lineThrough,
                        fontFamily: GoogleFonts.raleway().fontFamily,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      notification.newPrice,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: GoogleFonts.raleway().fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Column(
            children: [
              Text(
                notification.timeAgo,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black,
                  fontFamily: GoogleFonts.raleway().fontFamily,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: screenWidth * 0.045, color: Color(0xFF707B81)),
                onPressed: () => _removeNotification(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  void _clearNotifications() {
    setState(() {
      notifications.clear();
    });
  }
}

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
