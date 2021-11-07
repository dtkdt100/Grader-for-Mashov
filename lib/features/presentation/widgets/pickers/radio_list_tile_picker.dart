import 'package:flutter/material.dart';

class RadioListTilePicker extends StatefulWidget {
  const RadioListTilePicker({Key? key, required this.titles, this.trueFirstIndex = 0}) : super(key: key);

  final List<String> titles;
  final int trueFirstIndex;

  @override
  RadioListTilePickerState createState() => RadioListTilePickerState();
}

class RadioListTilePickerState extends State<RadioListTilePicker> {
  late List<bool> selected;

  @override
  void initState() {
    selected = List.generate(widget.titles.length, (index) => false);
    selected[widget.trueFirstIndex] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
          widget.titles.length,
          (index) => RadioListTile<bool>(
                activeColor: const Color(0xFF03a9f4),
                title: Text(
                  widget.titles[index],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onChanged: (bool? value) {
                  if (!value!) {
                    selected[selected.indexOf(true)] = false;
                    selected[index] = true;
                  }
                  //selected[selected.indexOf(value!)] = !value;

                  setState(() {

                  });
                },
                groupValue: true,
                value: selected[index],
              )),
    );
  }

  String currentTitle() => widget.titles[selected.indexOf(true)];
}
