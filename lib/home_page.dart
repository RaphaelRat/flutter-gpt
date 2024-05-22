import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tamagotchi_gpt/api.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final minhasMsg = <String>[].obs;
    final chatMsg = <String>[].obs;
    final FocusNode focusNode = FocusNode();

    void sendMessage() async {
      minhasMsg.add(controller.text);
      final msg = controller.text;
      controller.clear();
      focusNode.requestFocus();
      chatMsg.add(await fetchChatGPTResponse(msg));
    }

    return Scaffold(
      backgroundColor: Colors.green.withOpacity(0.95),
      appBar: AppBar(
        backgroundColor: Colors.green.withOpacity(0.95),
        title: const Text('Tamagotchi-gpt'),
        actions: [
          IconButton(
              onPressed: () {
                minhasMsg.clear();
                chatMsg.clear();
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          color: Colors.green,
          width: 720,
          child: Column(
            children: [
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: minhasMsg.length + chatMsg.length,
                      itemBuilder: (context, index) {
                        int indexMinhasMsg = index ~/ 2;
                        int indexChatMsg = index ~/ 2;

                        if (index % 2 == 0) {
                          return ListTile(
                            title: Text(minhasMsg[indexMinhasMsg]),
                            tileColor: Colors.blue[100],
                            trailing: const Icon(Icons.person),
                          );
                        } else {
                          return ListTile(
                            title: Text(chatMsg[indexChatMsg]),
                            tileColor: Colors.green[100],
                            leading: const Icon(Icons.person_outline),
                          );
                        }
                      },
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (_) => sendMessage(),
                      textInputAction: TextInputAction.send,
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "Digite sua mensagem aqui",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: sendMessage,
                    child: const Text("Enviar"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
