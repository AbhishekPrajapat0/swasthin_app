import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../GlobalWidget/globalAlert.dart';
import '../../Models/ChatModel/ChatListModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../controllers/chat controller/ChatController.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ChatController controller = ChatController();
  var loadingIsOn = true;
  var chatEmpty = true;

  ChatListModel chatListModel = ChatListModel();

  @override
  void initState() {
    getMsg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = Get.height;
    var w = Get.width;
    return Container(
      width: w,
      // child: loading(context) ,
      child: loadingIsOn
          ? loading(context)
          : chatEmpty
              ? Center(
                  child: Text("No Converstion"),
                )
              : getList(context),
    );
  }

  Future<void> getMsg() async {
    try {
      var header = getHeader();
      var body = {"staff_id": "7"};
      var uri = Uri.parse(base_url + chatHistoryUrl);
      var response = await post(uri, headers: header, body: body);
      print("getting chat list ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print("chat Details ====> $data");
        chatListModel = ChatListModel.fromJson(data);

        print("chat Details ====> ${chatListModel.chat?.length}");

        setState(() {
          loadingIsOn = false;
          if (chatListModel.chat?.length != 0) {
            chatEmpty = false;
          }
        });
      } else if (response.statusCode == 500) {
        GlobalAlert(
            context,
            "Server Error",
            "The server has encountered an Error, Please Restart the App",
            DialogType.warning,
            onTap: () {});
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      }
    } catch (e) {
      print("error while getting packages list");
    }
  }

  getList(BuildContext context) {
    var h = Get.height;
    var w = Get.width;
    return ListView.builder(
      reverse: true,
      itemCount: chatListModel.chat!.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var msg = chatListModel.chat![index].message;
        var sender = chatListModel.chat![index].sendBy;
        return Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment:
                (sender == "USER" ? Alignment.topRight : Alignment.topLeft),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (sender == "USER" ? userChatColor : kPrimaryBase),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                "$msg",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        );
      },
    );
  }

  loading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
