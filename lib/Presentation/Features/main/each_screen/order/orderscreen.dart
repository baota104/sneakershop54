import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/order/order_bloc.dart';
import 'package:sneaker_shop/domains/data_source/remote/firebase/order_firebase.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';
import 'package:sneaker_shop/domains/repository/order_repository.dart';

import '../../../../Widgets/LoadingWidget.dart';
import 'order_event.dart';
import 'orderstate.dart';

class OrderscreenContainer extends StatelessWidget {
  const OrderscreenContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => Orderfirebase()),
        ProxyProvider<Orderfirebase, OrderRepository>(
          update: (context, orderFirebase, _) => OrderRepository(orderFirebase),
        ),
        ProxyProvider<OrderRepository, OrderBloc>(
          update: (context, repository, _) => OrderBloc(repository),
        ),
      ],
      child: Orderscreen(),
    );
  }
}

class Orderscreen extends StatefulWidget {
  const Orderscreen({super.key});

  @override
  State<Orderscreen> createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
  late OrderBloc orderBloc;
  late List<OrderModel> listorder;
  String selectedStatus = 'all'; // Giá trị mặc định
  List<String> allStatuses = ['all', 'pending', 'confirmed', 'shipping', 'completed', 'cancelled'];


  @override
  void initState() {
    // TODO: implement initState
    orderBloc = context.read<OrderBloc>();
    orderBloc.add(FetchListOrders());
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _buildAppBar(),
      body:  Container(
        child: BlocConsumer<OrderBloc, OrderStateBase>(
        bloc: orderBloc,
        listener: (context, state) {
          if (state is FetchListOrderSuccess) {
            setState(() {

              listorder = state.listOrder;
            });
          }
          if(state is UpdateorderSuccess){
            orderBloc.add(FetchListOrders());
            print("ban da huy don hang thanh cong");
          }
        },
        builder: (context, state) {
          print("state receive"+state.toString());
      if (state is FetchListOrderSuccess) {
        print(state.listOrder.length.toString() + "on roi nhe");
        return _buildorderscreen(screenWidth, screenHeight);
      } else if (state is OrderStateLoading) {
        return Center(child: LoadingWidet());
      } else if (state is FetchListOrderError) {
        return Center(child: Text(state.message+"tai sao nhi"));
      } else {
        return Center(child: LoadingWidet());
      }
    },
    ),
    ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        "Orders",
        style: GoogleFonts.raleway(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [

      ],
      backgroundColor: Color(0xFFF7F7F9),
      elevation: 0,
    );
  }
  Widget _buildorderscreen(double screenWidth, double screenHeight) {
    return Column(
      children: [
        buildStatusFilterBar(screenWidth),
        Expanded(
          child: buildOrderListWidget(
            selectedStatus == 'all'
                ? listorder
                : listorder.where((order) => order.status.toLowerCase() == selectedStatus.toLowerCase()).toList(),
            screenWidth,
            screenHeight,
          ),
        ),
      ],
    );
  }

  Widget buildStatusFilterBar(double screenWidth) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allStatuses.length,
        itemBuilder: (context, index) {
          String status = allStatuses[index];
          bool isSelected = status == selectedStatus;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(
                status[0].toUpperCase() + status.substring(1),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey.shade200,
              onSelected: (_) {
                setState(() {
                  selectedStatus = status;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildOrderListWidget(List<OrderModel> listOrder, double screenWidth, double screenHeight) {
    if (listOrder.isEmpty) {
      return Center(
        child: Text(
          "No Orders available",
          style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: listOrder.length,
      itemBuilder: (context, index) {
        return _buildOrderItem(listOrder[index], index, screenWidth, screenHeight);
      },
    );
  }



  Widget _buildOrderItem(OrderModel order, int index, double screenWidth, double screenHeight) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order #${index + 1}",
                      style: GoogleFonts.raleway(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: screenWidth * 0.06,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                Text("Address: ${order.address}", style: GoogleFonts.poppins(fontSize: screenWidth * 0.04)),
                Text("Total: \$${order.totalAmount.toStringAsFixed(2)}", style: GoogleFonts.poppins(fontSize: screenWidth * 0.04)),
                Text("Status: ${order.status}", style: GoogleFonts.poppins(fontSize: screenWidth * 0.04)),

                if (isExpanded) ...[
                  Divider(height: screenHeight * 0.02),
                  Column(
                    children: order.orderDetails.map((detail) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                        child: Row(
                          children: [
                            Image.network(
                              detail.imageUrl,
                              width: screenWidth * 0.15,
                              height: screenWidth * 0.15,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image, color: Colors.grey),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(detail.name,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * 0.04)),
                                  Text("Price: \$${detail.price.toStringAsFixed(2)}",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (order.status.toLowerCase() == 'confirmed')
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                        Center(
                          child: TextButton(
                            onPressed: () => _updateOrderStatus(order.orderId, 'cancelled'),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: Text('Hủy đơn'),
                          ),
                        ),

                    //     TextButton(
                    //       onPressed: () => _updateOrderStatus(order.orderId, 'completed'),
                    //       style: TextButton.styleFrom(foregroundColor: Colors.green),
                    //       child: Text('Đã nhận được hàng'),
                    //     ),
                    //   ],
                    // ),

                ],
              ],
            ),
          ),
        );
      },
    );
  }
  void _updateOrderStatus(String orderId, String newStatus) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận'),
        content: Text(
          newStatus == 'cancelled'
              ? 'Bạn có chắc muốn hủy đơn hàng này không?'
              : 'Bạn đã nhận được hàng?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Không')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Có')),
        ],
      ),
    );

    if (confirm == true) {
      orderBloc.add(UpdateOrderstatus(orderId,newStatus));
    }
  }

}




