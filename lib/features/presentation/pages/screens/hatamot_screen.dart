import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/mashov_api.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/base_screen.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';

class HatamotScreen extends StatefulWidget {
  final int indexPag;
  const HatamotScreen(this.indexPag, {Key? key}) : super(key: key);

  @override
  _HatamotScreenState createState() => _HatamotScreenState();
}

class _HatamotScreenState extends BaseScreen<HatamotScreen> {
  List<Hatama>? value;

  @override
  int get from => widget.indexPag;

  @override
  String get title => 'התאמות';

  @override
  Widget? get body => value == null ? null : value!.isEmpty ? const Padding(
      padding: EdgeInsets.all(12),
      child: Center(child: Text('אין נתונים'))) : Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: List.generate(value!.length, (index){
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(value![index].name, style: const TextStyle(fontSize: 22),),
      );
    }),
  );

  @override
  Future<void> getMashovData() async {
    value = await MashovUtilities.getHatamot();
    setState(() {});
  }

  @override
  void reload() {
    value = null;
    setState(() {});
    getMashovData();
  }
}
