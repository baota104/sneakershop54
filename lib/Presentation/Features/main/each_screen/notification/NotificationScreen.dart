import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/notification/Notification_bloc.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/notification/Notification_event.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/notification/Notification_state.dart';
import 'package:sneaker_shop/Presentation/Widgets/LoadingWidget.dart';
import 'package:sneaker_shop/domains/data_source/remote/firebase/notifycation_firebase.dart';
import 'package:sneaker_shop/domains/repository/notifycation_repository.dart';

import '../../../../../domains/model/NotificationModel.dart';
class NotificationscreenContainer extends StatelessWidget {
  const NotificationscreenContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => NotificationFirebase()),
        ProxyProvider<NotificationFirebase, NotificationRepository>(
          update: (context, notiFirebase, _) => NotificationRepository(notiFirebase),
        ),
        ProxyProvider<NotificationRepository, NotificationBloc>(
          update: (context, repository, _) => NotificationBloc(repository),
        ),
      ],
      child: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationBloc notibloc;
  late List<NotificationModel> notifications;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notibloc = context.read<NotificationBloc>();
    notibloc.add(FetchListNotification());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<NotificationBloc, NotiStateBase>(
        bloc: notibloc,
        listener: (context, state) {
        if(state is FetchListNotiSuccess){
          notifications = state.listNotification;
        }
        if (state is DeletenotificationSuccess) {
          notibloc.add(FetchListNotification());
        }
      },
  builder: (context, state) {
    if(state is NotiStateLoading){
      return Center(child: LoadingWidet());
    }
    else if(state is FetchListNotiSuccess){
      return _buildNotificationList(screenWidth, screenHeight);
    }
    else{
      print("fetch noti error");
    }
   return Container();
  },
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
            child: Image.network(
              notification.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.image, color: Colors.grey, size: screenWidth * 0.1),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
                child:Text(
                  notification.message,
                  style: GoogleFonts.raleway(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Column(
            children: [
              Text(
                timeAgo(notification.time),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black54,
                  fontFamily: GoogleFonts.raleway().fontFamily,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: screenWidth * 0.045, color: Color(0xFF707B81)),
                onPressed: () => _removeNotification(index),
              ),
            ],
          )
        ],
      ),
    );
  }
  String timeAgo(DateTime notificationTime) {
    final now = DateTime.now();
    final difference = now.difference(notificationTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute ago';
    } else {
      return 'now';
    }
  }

  void _removeNotification(int index) {
    final id = notifications[index].notificationId;
    if(id.isNotEmpty){
      setState(() {
        notifications.removeAt(index);
      });
      notibloc.add(DeleteNotification(id));
    }
    else{
      print("id rỗng");
    }
  }

  void _clearNotifications() async {
    for (var notification in notifications) {
      notibloc.add(DeleteNotification(notification.notificationId));
    }
    setState(() {
      notifications.clear();
    });
  }

}


