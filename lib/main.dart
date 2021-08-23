import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/data/animation/material_ink_splash.dart';
import 'features/presentation/pages/loading_page.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grader',
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Theme(
            data: Theme.of(context)
                .copyWith(splashFactory: MaterialInkSplash.splashFactory),
            child: const LoadingPage()),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
