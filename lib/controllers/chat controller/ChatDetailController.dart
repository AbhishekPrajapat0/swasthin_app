import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Models/ChatModel/ChatListModel.dart';

class ChatDetailController extends GetxController{
  TextEditingController messageTextController = TextEditingController();
  // final ChatRepository _chatRepository = ChatRepository();
  ScrollController scrollController = ScrollController();
  var showButton = false.obs;


  @override
  void onInit() async {
    super.onInit();
    scrollController.addListener(() {
      if(scrollController.offset > 70){
        showButton.value = true;
        update();
      }else{
        showButton.value = false;
        update();
      }
    });
  }


  @override
  void onClose() {
    super.onClose();
    messageTextController.dispose();
    scrollController.dispose();
  }

  void updateMessageRead(int customerId) async{
    try{
      var data ={
        "user_id" : customerId
      };
      // await _chatRepository.updateMessageRead(data);
    }
    catch(e){
      print(e.toString());
      // Get.showSnackbar(Ui.errorSnackBar(message: Global.getApiMessage(e)));
    }
  }

  Stream<List<Chat>> getMessages(int customerId) async*{
   print("getMessage running");
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      // List<Chat> messages = await _chatRepository.getMessageList(customerId: customerId);
      // yield messages;
    }

  }

  sendMessage({required int userId, required String message}) async {
    // var response = await _chatRepository.sendMessage(
    //     userId: userId,
    //     message: message);
    // print(response["success"]);
    scrollController.animateTo(0.0, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

}