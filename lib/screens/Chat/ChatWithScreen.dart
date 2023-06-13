import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/chat controller/ChatController.dart';
import 'ChatScreen.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatController controller = Get.put(ChatController());

  Timer? timer;

  @override
  void initState() {
    initTask();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => initTask());

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
                style:
                    TextStyle(fontFamily: 'PoppinsMedium', color: mainColor)),
          ),
          body: Obx(() => controller.firstDataLoad.value
              ? controller.dataNotNull.value
                  ? listOfDietitian(context)
                  : Center(
                      child: Text("You have no Conversation"),
                    )
              : Center(child: CircularProgressIndicator()))),
    );
  }

  Future<void> initTask() async {
    // controller.firstDataLoad.value = false;
    await controller.getChatsApi();
    print("data =====> ${controller.chatWithList?.length}");
  }

  listOfDietitian(BuildContext context) {
    var h = Get.height;
    var w = Get.width;

    return ListView.builder(
      reverse: true,
      itemCount: controller.chatWithList!.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var data = controller.chatWithList![index];
        var name = "${data.staff!.name} ${data.staff!.lastName!}";
        var lastMsg = data.recentMessage!.message;
        var sendBy = data.recentMessage!.sendBy == "DIETITIAN"
            ? data.staff!.name
            : "You";
        var times = data.recentMessage!.time!.split(":");
        var time = times[0] + ":" + times[1];
        var messageCount = controller.chatWithList![index].readcount;
        return InkWell(
          onTap: () {
            Get.to(() => ChatScreen(), arguments: [data.staffId.toString()]);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            // height: h*0.2,
            width: w * 0.9,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                  colors: [
                    mainColor,
                    secondaryColor,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name",
                      style: TextStyle(color: Colors.white, fontSize: w * 0.05),
                    ),
                    SizedBox(
                      height: w * 0.01,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          chatIcon,
                          height: w * 0.05,
                          width: w * 0.05,
                          color: kPrimaryWhite,
                        ),
                        SizedBox(
                          width: w * 0.02,
                        ),
                        Container(
                            width: w * 0.5,
                            child: Text(
                              "$sendBy : $lastMsg",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white, fontSize: w * 0.03),
                            )),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "$time",
                      style: TextStyle(color: Colors.white, fontSize: w * 0.03),
                    ),

                    // show count only when count is not null or 0
                    messageCount == null || messageCount < 1
                        ? Container()
                        : CircleAvatar(
                            child: Text(
                              "$messageCount",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: w * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: kPrimaryWhite,
                            radius: w * 0.03,
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
