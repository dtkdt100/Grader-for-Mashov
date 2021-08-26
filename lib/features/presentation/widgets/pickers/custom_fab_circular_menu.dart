import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/data/material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/card_design.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';
import 'fab_circular_menu.dart';

class CustomFabCircularMenu extends StatefulWidget {
  final GlobalKey? fabKey;
  final List<CustomFabItem> items;

  const CustomFabCircularMenu({Key? key, required this.items, this.fabKey}) : super(key: key);

  @override
  State<CustomFabCircularMenu> createState() => _CustomFabCircularMenuState();
}

class _CustomFabCircularMenuState extends State<CustomFabCircularMenu> {
  double fabElevation = 5.0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SharedPreferencesUtilities.themes.themeData,
      child: FabCircularMenu(
          alignment: Alignment.bottomCenter,
          fabElevation: fabElevation,
          ringDiameter: 200,
          ringWidth: 68,
          fabOpenColor: const Color(0xffff6d00).withOpacity(SharedPreferencesUtilities.themes.opacity),
          fabOpenIcon: const Icon(MdiIcons.sortVariant, color: Colors.white,),
          fabCloseIcon: const Icon(MdiIcons.close, color: Colors.white,),
          fabCloseColor: CardDesign.seeMoreColor.withOpacity(SharedPreferencesUtilities.themes.opacity),
          ringColor: CardDesign.seeMoreColor.withOpacity(SharedPreferencesUtilities.themes.opacity),
          children: List.generate(widget.items.length, (index) => IconButton(
            icon: Icon(widget.items[index].iconData, color: Colors.white,),
            onPressed: widget.items[index].onTap,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
          )),
        onDisplayChange: (b){
            setState(() {
              if (b) {
                fabElevation = 0.0;
              } else {
                fabElevation = 5.0;
              }
            });
        },
      ),
    );
  }
}

class CustomFabItem {
  final IconData iconData;
  final VoidCallback onTap;

  CustomFabItem({
    required this.onTap,
    required this.iconData,
  });
}
