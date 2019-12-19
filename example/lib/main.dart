
import 'package:example_flutter/Theme/theme.dart';
import 'package:example_flutter/login.dart';
import 'package:example_flutter/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'database.dart';

void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  Database.buildConnection();
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    
    home: SplashScreen(),
    theme: CustomTheme.themdata,
  ));
}

