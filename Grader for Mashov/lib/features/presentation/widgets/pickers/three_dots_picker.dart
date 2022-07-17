import 'package:flutter/material.dart';

class ThreeDotsPicker extends StatelessWidget {
  final List<String> children;
  final Function(int selected) selected;

  const ThreeDotsPicker({Key? key, this.children = const [], required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'פתח תפריט',
      onSelected: selected,
      itemBuilder: (context) {
        return List.generate(children.length, (index){
          return PopupMenuItem(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            height: 30,
            value: index,
            child: Text(children[index]),
          );
        });
      },
    );
  }
}
