import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> fetchChatGPTResponse(String prompt) async {
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer <MINHA-CHAVE>'},
    body: jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
      'max_tokens': 250,
      'temperature': 0,
      'top_p': 1,
    }),
  );

  if (response.statusCode == 200) {
    var data = json.decode(utf8.decode(response.bodyBytes));
    return data['choices'][0]['message']['content'];
  } else {
    if (kDebugMode) {
      print(response.body);
    }
    return 'Erro';
  }
}
