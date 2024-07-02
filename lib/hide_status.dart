import 'package:flutter/services.dart';

Future showStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

Future hideStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
