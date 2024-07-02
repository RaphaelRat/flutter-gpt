import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:tamagotchi_gpt/api.dart';
import 'package:tamagotchi_gpt/chat_controller.dart';
import 'package:tamagotchi_gpt/db_helper.dart';
import 'package:tamagotchi_gpt/hide_status.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    // final minhasMsg = <String>[].obs;
    // final chatMsg = <String>[].obs;
    final FocusNode focusNode = FocusNode();
    final showApi = false.obs;

    final chatController = Get.put(ChatController());

    void sendMessage() async {
      // showApi.value = false;
      final msg = textController.text;

      final asd = chatController.messages.where((p0) => p0['isSentByMe'] == 1).toList();

      final aaa = asd.map((e) => e['text'] as String).toList();

      final ddd = chatController.messages.where((p0) => p0['isSentByMe'] == 0).toList();

      final fff = ddd.map((e) => e['text'] as String).toList();

      chatController.addMessage({'text': msg, 'isSentByMe': true, 'timestamp': DateTime.now().toString()});
      // minhasMsg.add(textController.text);
      textController.clear();
      focusNode.requestFocus();
      String response = await fetchChatGPTResponse(msg, 'MINHA CHAVE', minhasMsg: aaa, suaMsg: fff);
      // chatMsg.add(response);
      chatController.addMessage({'text': response, 'isSentByMe': false, 'timestamp': DateTime.now().toString()});
    }

    showStatusBar();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showApi.value = false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.white,
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
                onPressed: chatController.clearAllMessages,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ))
          ],
          title: const Text(
            'Nickelfox Mario',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Obx(
                    () => Column(
                      children: List.generate(chatController.messages.length, (index) {
                        var message = chatController.messages[index];
                        bool isChat = message['isSentByMe'] == 0;
                        return Message(
                          title: message['text'],
                          isChat: isChat,
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: SafeArea(
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTap: () {
                            showApi.value = true;
                          },
                          onSubmitted: (_) => sendMessage(),
                          textInputAction: TextInputAction.send,
                          textCapitalization: TextCapitalization.sentences,
                          controller: textController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: "Digite sua mensagem aqui",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                      ),
                      if (showApi.value) ...{
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: sendMessage,
                          child: const Text("Enviar"),
                        ),
                      }
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  const Message({
    super.key,
    this.title,
    this.isChat = false,
  });

  final String? title;
  final bool isChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16, left: isChat ? 0 : 80, right: isChat ? 80 : 0, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isChat
            ? [
                CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.asset('assets/images/xau.png', repeat: ImageRepeat.noRepeat),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title ?? '',
                    overflow: TextOverflow.visible,
                  ),
                ),
              ]
            : [
                Expanded(
                  child: Text(
                    title ?? '',
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.person_2_outlined),
              ],
      ),
    );
  }
}
