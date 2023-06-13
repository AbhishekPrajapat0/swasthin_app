import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import '../../Models/ChatModel/AllChatModel.dart';
import '../../Models/ChatModel/ChatWithModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../contants/Constants.dart';

class ChatController extends GetxController {
  // final ChatRepository _chatRepository = ChatRepository();

  ChatWithModel chatWithModel = ChatWithModel();
  List<ChatWithModel>? chatWithList;
  var reload = false.obs;
  var reloadStarted = false.obs;

  var firstDataLoad = false.obs;
  var dataNotNull = false.obs;

  reloadChats() async {
    reload.value = true;
    await Future.delayed(Duration(seconds: 6));
    reload.value = false;
    reloadStarted.value = true;
    await Future.delayed(Duration(seconds: 10));
    reloadStarted.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    getChats();
  }

  test() async {
    // await _chatRepository.allChatsList();
  }

  Stream<List<AllChats>> getChats() async* {
    // while (true) {
    //   List<AllChats> allChats = await _chatRepository.allChatsList();
    //   yield allChats;
    // }
  }

  getChatsApi() async {
    try {
      GetStorage box = GetStorage();
      var header = getHeader();
      var url = Uri.parse(base_url + chatWithListUrl);
      final response = await get(url, headers: header);
      print("subscription status  ===> ${response.statusCode}");
      print("subscription status ===> ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // chatWithModel = ChatWithModel.fromJson(data);
        chatWithList = data
            .map<ChatWithModel>((obj) => ChatWithModel.fromJson(obj))
            .toList();
        var count = chatWithList?.length ?? 0;
        box.write(msgCountDashboard, count);
        firstDataLoad.value = true;
        if (chatWithList?.length != 0) {
          dataNotNull.value = true;
        }
        print("count----------- ===> | ${chatWithList?.length} }");
      } else {
        throw Exception();
      }
    } catch (e) {
      print("subscription status error $e");
      throw Exception();
    }
  }
}
