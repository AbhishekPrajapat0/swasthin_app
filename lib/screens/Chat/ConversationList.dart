import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../contants/colors.dart';

import '../../Models/ChatModel/AllChatModel.dart';
import '../../controllers/chat controller/ChatController.dart';

class ConversationList extends StatefulWidget {
  final String name;
  final String messageText;
  final String time;
  final String date;
  final bool isMessageRead;
  final String bookingId;
  final int pendingMessage;
  final int customerId;

  ConversationList(
      {required this.name,
      required this.messageText,
      required this.time,
      required this.date,
      required this.bookingId,
      required this.isMessageRead,
      required this.pendingMessage,
      required this.customerId});

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => ChatDetailPage(), arguments: [
        //   {
        //     "name": widget.name,
        //     "customer_id": widget.customerId,
        //     "status": true
        //   }
        // ]);
      },
      child: Container(
        height: 70,
        width: Get.width,
        decoration: BoxDecoration(
            color: widget.pendingMessage <= 0
                ? kPrimaryRed
                : Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: mainColor, width: 1),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffB4B4B4).withOpacity(0.5),
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                  blurRadius: 4)
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Name: " + widget.name,
                          style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryWhite,
                              fontFamily: "PoppinsRegular"),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        SizedBox(
                          width: Get.width * 0.5,
                          child: Text(
                            widget.messageText.length > 70
                                ? '${widget.messageText.substring(0, 70)}...'
                                : widget.messageText,
                            style: TextStyle(
                                fontSize: 14,
                                color: kPrimaryWhite,
                                fontFamily: "PoppinsRegular"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.pendingMessage > 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.time,
                          style: TextStyle(
                              fontSize: 12,
                              color: kPrimaryWhite,
                              fontFamily: "PoppinsRegular"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Date: " + widget.date,
                          style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryWhite,
                              fontFamily: "PoppinsRegular"),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: mainColor,
                          child: Text(
                            widget.pendingMessage.toString(),
                            style: TextStyle(
                                fontFamily: "PoppinsRegular",
                                color: kPrimaryWhite,
                                fontSize: 10),
                          ),
                        )
                      ],
                    )
                  : Text(
                      widget.time,
                      style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryWhite,
                          fontFamily: "PoppinsRegular"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.reloadChats();
      },
      child: Scaffold(
          backgroundColor: kPrimaryWhite,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kPrimaryWhite,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: const Text("Chat",
                style: TextStyle(
                    fontFamily: 'PoppinsMedium', color: secondaryColor)),
          ),
          body: Obx(
            () => (controller.reload == false)
                ? Container(
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: StreamBuilder(
                        stream: controller.getChats(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<AllChats>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 16),
                                itemBuilder: (context, index) {
                                  AllChats allChats = snapshot.data![index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, bottom: 8),
                                    child: ConversationList(
                                      bookingId: "1111",
                                      name: allChats.user!.name!,
                                      messageText:
                                          (allChats.recentMessage != null)
                                              ? allChats.recentMessage!.message!
                                              : "",
                                      time: allChats.time!,
                                      date: allChats.date!,
                                      isMessageRead: false,
                                      customerId:
                                          allChats.recentMessage!.userId!,
                                      pendingMessage: allChats.readCount!,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text("No Conversations"),
                              );
                            }
                          } else if (!snapshot.hasData) {
                            return (controller.reloadStarted == false)
                                ? Center(
                                    child: TextButton(
                                      onPressed: () {
                                        controller.reloadChats();
                                      },
                                      child: Text("Refresh chats"),
                                    ),
                                  )
                                : Center(
                                    child: Text("Getting chats...."),
                                  );
                          } else if (snapshot.hasError) {
                            return controller.reloadStarted == false
                                ? Center(
                                    child: InkWell(
                                        onTap: () {
                                          controller.reloadChats();
                                        },
                                        child: Container(
                                            child: Text("Refresh chats"))),
                                  )
                                : Center(
                                    child: Text("Getting chats..."),
                                  );
                          } else if (snapshot.connectionState ==
                              ConnectionState.none) {
                            return Center(
                              child: Text("Network error"),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          )),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
