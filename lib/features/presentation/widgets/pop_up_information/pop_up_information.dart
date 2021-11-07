import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
import 'package:measured_size/measured_size.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class PopUpInformation extends StatefulWidget {
  const PopUpInformation({Key? key, required this.child, this.informationChild})
      : super(key: key);

  final Widget? informationChild;
  final Widget child;

  @override
  _PopUpInformationState createState() => _PopUpInformationState();
}

class _PopUpInformationState extends State<PopUpInformation> {
  final ValueNotifier<double> height = ValueNotifier<double>(0.0);
  double realHeight = 0.0;
  OverlayEntry? _popupDialog;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onLongPress: () {
        Vibrate.feedback(FeedbackType.selection);
        _popupDialog = _createPopupDialog();
        Overlay.of(context)!.insert(_popupDialog!);
      },
      onLongPressEnd: (details) {
        _popupDialog?.remove();
        height.value = 0;
      },
    );
  }

  OverlayEntry _createPopupDialog() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Visibility(
              maintainState: true,
              visible: false,
              child: widget.informationChild == null
                  ? const SizedBox()
                  : MeasuredSize(
                  onChange: (Size size) {
                    setState(() {
                      realHeight = size.height;
                    });
                    Future.delayed(const Duration(milliseconds: 10), () {
                      height.value = realHeight + 10;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.informationChild!,
                    ],
                  )),
            ),
            AnimatedDialog(
              child: _createPopupContent(),
            ),
          ],
        );
      },
    );
  }

  Widget _createPopupContent() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: ValueListenableBuilder<double>(
            valueListenable: height,
            builder: (BuildContext context, double value, Widget? child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: value,
                color: SharedPreferencesUtilities.themes.backgroundColor,
                child: SingleChildScrollView(
                  child: widget.informationChild ?? const SizedBox(),
                ),
              );
            },
          ),
        ),
      );
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
