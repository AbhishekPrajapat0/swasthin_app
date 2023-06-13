import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:profanity_filter/profanity_filter.dart';

import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../Models/ChatModel/ChatListModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../controllers/DashboardController.dart';
import '../../controllers/chat controller/ChatController.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = ChatController();
  TextEditingController messagedCon = TextEditingController();

  dynamic arguments = Get.arguments;
  var staffId;
  var loadingIsOn = true;
  var chatEmpty = true;
  var dietitiansName = "Ask Dietitian";

  var times = 0;

  GetStorage box = GetStorage();
  Timer? timer;
  ChatListModel chatListModel = ChatListModel();

  @override
  void initState() {
    getName();
    staffId = arguments[0];
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => getMsg());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appBarWithBack(context, showBack: true, title: "$dietitiansName"),
      body: Stack(
        children: <Widget>[
          Container(
            height: box.read(currentStaffIdForChat).toString() == staffId
                ? h * 0.85
                : h * 1.4,
            padding: EdgeInsets.only(bottom: 30),
            margin: EdgeInsets.only(
                bottom: box.read(currentStaffIdForChat).toString() == staffId
                    ? 20
                    : 0),
            child: ChatList(),
          ),
          box.read(currentStaffIdForChat).toString() == staffId
              ? sendButton(context)
              : Container(),
        ],
      ),
    );
  }

  Future<void> sendMsgToAPI() async {
    try {
      var header = getHeader();
      var body = {"message": "${messagedCon.text}", "staff_id": "$staffId"};
      var uri = Uri.parse(base_url + addChatUrl);
      var response = await post(uri, headers: header, body: body);
      print("sending chat  ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        print("chat added ====> 200 OK ");
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

  ChatList() {
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
        var time = chatListModel.chat![index].time;
        var date = chatListModel.chat![index].date;
        var dietitianName = chatListModel.chat![index].staff!.name;
        var userName = chatListModel.chat![index].user!.name;
        return Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Column(
            children: [
              Align(
                alignment:
                    (sender == "USER" ? Alignment.topRight : Alignment.topLeft),
                child: Column(
                  crossAxisAlignment: sender == "USER"
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: w * 0.3,
                        margin: sender == "USER"
                            ? EdgeInsets.only(right: 10)
                            : EdgeInsets.only(left: 5),
                        // color: kPrimaryBase,
                        child: Text(
                          "${sender == "USER" ? "You" : dietitianName}",
                          style: TextStyle(fontSize: 8),
                          textAlign: sender == "USER"
                              ? TextAlign.end
                              : TextAlign.start,
                        )),
                    SizedBox(
                      height: h * 0.005,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            (sender == "USER" ? userChatColor : kPrimaryBase),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "$msg",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    // Container(
                    //   width: w*0.2,
                    //   color: kPrimaryBase,
                    //     child: Text("$time", style: TextStyle(fontSize: 10),textAlign: sender == "USER" ?TextAlign.end : TextAlign.start,))
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.005,
              ),
              Align(
                alignment:
                    (sender == "USER" ? Alignment.topRight : Alignment.topLeft),
                child: Container(
                    width: w * 0.3,
                    margin: sender == "USER"
                        ? EdgeInsets.only(right: 10)
                        : EdgeInsets.only(left: 5),
                    // color: kPrimaryBase,
                    child: Text(
                      "$time | $date",
                      style: TextStyle(fontSize: 8),
                      textAlign:
                          sender == "USER" ? TextAlign.end : TextAlign.start,
                    )),
              )
            ],
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

  Future<void> getMsg() async {
    try {
      var header = getHeader();
      var body = {"staff_id": "$staffId"};
      var uri = Uri.parse(base_url + chatHistoryUrl);
      var response = await post(uri, headers: header, body: body);
      print("getting chat list ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print("chat Details ====> $data");
        chatListModel = ChatListModel.fromJson(data);

        print("chat Details ====> ${chatListModel.chat?.length}");

        if (times < 1) {
          updateMsgCount();
          times = 1;
        }

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

  sendButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: messagedCon,
                decoration: InputDecoration(
                  hintText: "Write message...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () {
                final RegExp _mobileRegExp = RegExp(r'^\d{10}$');
                final RegExp _emailRegExp = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                final filter = ProfanityFilter();
                //Check for profanity - returns a boolean (true if profanity is present)
                bool hasProfanity = filter.hasProfanity(messagedCon.text);
                print("=========================> $hasProfanity");
                if (hasProfanity) {
                  GlobalAlert(
                      context,
                      "Inappropriate Words",
                      "Please use appropriate words\n your chat is being monitored",
                      DialogType.warning,
                      onTap: () {});
                } else if (_mobileRegExp.hasMatch(messagedCon.text) ||
                    _emailRegExp.hasMatch(messagedCon.text)) {
                  GlobalAlert(
                      context,
                      "Oops!",
                      "You cannot share Mobile Number \nor Email with Dietitian",
                      DialogType.warning,
                      onTap: () {});
                } else {
                  sendMsgToAPI();
                  messagedCon.clear();
                  getMsg();
                }
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateMsgCount() async {
    try {
      var header = getHeader();
      var body = {"staff_id": "$staffId"};
      var uri = Uri.parse(base_url + chatMsgUpdateUrl);
      var response = await post(uri, headers: header, body: body);
      print("updating chat msg ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        // shop Showing Pop on dashboard chat
        Get.put(DashboardController());
        Get.find<DashboardController>().showMsgPop.value = false;
        //
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
    } catch (e) {}
  }

  Future<void> getName() async {
    dietitiansName = await box.read(dietitianName).toString();
  }
}
