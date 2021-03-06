import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/data/animation/material_ink_splash.dart';
import 'features/presentation/pages/first_pages/loading_page.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grader',
      builder: (context, widget) => Directionality(
        textDirection: TextDirection.rtl,
        child: ScrollConfiguration(
            behavior: const ScrollBehaviorModified(), child: widget!),
      ),
      navigatorKey: navigatorKey,
      home: Theme(
          data: Theme.of(context)
              .copyWith(splashFactory: MaterialInkSplash.splashFactory),
          child: const LoadingPage()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}
