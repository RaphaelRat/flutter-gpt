// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tamagotchi_gpt/api.dart';
import 'package:tamagotchi_gpt/chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final apiController = TextEditingController();
    final minhasMsg = <String>[].obs;
    final chatMsg = <String>[].obs;
    final FocusNode focusNode = FocusNode();
    final showApi = false.obs;

    void sendMessage() async {
      showApi.value = false;
      minhasMsg.add(textController.text);
      final msg = textController.text;
      textController.clear();
      focusNode.requestFocus();
      chatMsg.add(await fetchChatGPTResponse(msg, 'MINHA CHAVE', minhasMsg: minhasMsg, suaMsg: chatMsg));
    }

    Matrix4 moveMatrix(double dx) => Matrix4.translationValues(dx, 0, 0);
    final transformationController = TransformationController();

    transformationController.value *= moveMatrix(-40);

    Timer? timer;
    int durationSeconds = 10;
    double stepX = -400;

    void animateBackground(double totalDistance, int seconds) {
      return;
      final double stepDistance = totalDistance / (seconds * 20);
      int steps = 0;
      final int totalSteps = seconds * 20;

      timer?.cancel();
      timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        transformationController.value *= Matrix4.translationValues(stepDistance, 0, 0);
        steps++;
        if (steps >= totalSteps) {
          timer.cancel();
          if (totalDistance == stepX || totalDistance == 400.0) {
            animateBackground(totalDistance == 400.0 ? stepX : -stepX, durationSeconds);
          }
        }
      });
    }

    animateBackground(stepX, durationSeconds);
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: transformationController,
            scaleEnabled: false,
            panEnabled: false,
            minScale: 0.5,
            maxScale: 2.0,
            constrained: false,
            child: SvgPicture.asset(
              'assets/images/noite-quarto.svg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 2,
              height: MediaQuery.of(context).size.height + 30,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Container(
                  padding: EdgeInsets.all(16),
                  width: 260,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Nickelfox Mario',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Collect coins, earn rewards, and unlock surprises in a pixelated world.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      GestureDetector(
                          onTap: () async {
                            // timer?.cancel();
                            Get.to(() => ChatPage());
                            // transformationController.value = moveMatrix(-40);

                            // await Future.delayed(Duration(seconds: 1));
                            // animateBackground(stepX, durationSeconds);
                          },
                          child: Container(
                              color: Colors.black,
                              height: 32,
                              child: Center(
                                child: Text(
                                  'Let\'s chat',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))),
                      if (false) ...{
                        SingleChildScrollView(
                          child: Column(
                            children: List.generate(minhasMsg.length + chatMsg.length, (index) {
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
                            }),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onSubmitted: (_) => sendMessage(),
                                textInputAction: TextInputAction.send,
                                controller: textController,
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
                        // Obx(() => showApi.value
                        //     ? Container(
                        //         margin: const EdgeInsets.only(top: 16),
                        //         width: 300,
                        //         child: TextField(
                        //           textInputAction: TextInputAction.send,
                        //           controller: apiController,
                        //           decoration: InputDecoration(
                        //             hintText: "API KEY",
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(8.0),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : Container()),
                        const SizedBox(height: 16),
                      },
                    ],
                  )),
                ),

                Container(
                  margin: EdgeInsets.all(32),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  width: 200,
                  child: Image.asset(
                    'assets/images/deitado.gif',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                if (false)
                  Container(
                    height: 400,
                    margin: EdgeInsets.only(top: 32),
                    width: double.infinity,
                    color: Colors.amber,
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
                                controller: textController,
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
                        Obx(() => showApi.value
                            ? Container(
                                margin: const EdgeInsets.only(top: 16),
                                width: 300,
                                child: TextField(
                                  textInputAction: TextInputAction.send,
                                  controller: apiController,
                                  decoration: InputDecoration(
                                    hintText: "API KEY",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              )
                            : Container()),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                // IconButton(
                //   icon: Icon(
                //     Icons.arrow_right,
                //     size: 40,
                //     color: Colors.red,
                //   ),
                //   onPressed: () {
                //     transformationController.value *= moveMatrix(20);
                //     print(transformationController.value);
                //   },
                // ),
                // IconButton(
                //   icon: Icon(
                //     Icons.arrow_left,
                //     size: 40,
                //     color: Colors.red,
                //   ),
                //   onPressed: () {
                //     transformationController.value *= moveMatrix(-20);
                //     print(transformationController.value);
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
