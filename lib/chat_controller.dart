import 'package:get/get.dart';
import 'package:tamagotchi_gpt/db_helper.dart';

class ChatController extends GetxController {
  var messages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  void loadMessages() async {
    var loadedMessages = await DatabaseHelper.instance.getMessages();
    print(loadedMessages);
    messages.assignAll(loadedMessages);
  }

  void addMessage(Map<String, dynamic> message) async {
    await DatabaseHelper.instance.addMessage(message);
    loadMessages();
  }

  List<String> getMyMessagesText() {
    return messages.where((msg) => msg['isSentByMe'] == true).map((msg) => msg['text'] as String).toList();
  }

  List<String> getReceivedMessagesText() {
    return messages.where((msg) => msg['isSentByMe'] == false).map((msg) => msg['text'] as String).toList();
  }

  void clearAllMessages() async {
    final clear = await Get.defaultDialog(
        title: 'Apagar mensagens',
        middleText: 'Toda a conversa será apagada permanentemente',
        onCancel: () {},
        textCancel: 'Cancelar',
        onConfirm: () {
          Get.back(result: true);
        },
        textConfirm: 'Apagar');
    if (clear == true) {
      await DatabaseHelper.instance.clearMessages();
      messages.clear();
    }
  }
}
