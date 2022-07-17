import 'package:flutter/cupertino.dart';

class ShowPlayerInfo extends StatelessWidget {
  final Map<String, dynamic> info;

  const ShowPlayerInfo(this.info, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle styleTitle = const TextStyle(fontWeight: FontWeight.bold);
    TextStyle styleContent = const TextStyle(letterSpacing: 0.7);


    List<String> keys = List<String>.from(
        Map<String, dynamic>.from(info['avgByAgeGroup']).keys);
    return Column(
      children: [
        Row(
          children: [const Text('שם: '), Text(info['name'], style: styleTitle,)],
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          children: [const Text('בית ספר: '), Text(info['school'], style: styleTitle,)],
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text('שכבת גיל', style: styleContent,),
                const SizedBox(height: 10,),
                buildColumn('', keys, text: true)
              ],
            ),
            Column(
              children: [
                Text('ממוצע', style: styleContent,),
                const SizedBox(height: 20,),
                buildColumn('avg', keys)
              ],
            ),
            Column(
              children: [
                Text('מיקום', style: styleContent,),
                const SizedBox(height: 20,),
                buildColumn('place', keys)
              ],
            ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: const [
        //     Text('שכבת גיל'),
        //     Text('ממוצע'),
        //     Text('מיקום')
        //   ],
        // ),
        // Column(
        //   children: List.generate(info['avgByAgeGroup'].length, (index) {
        //     List<String> keys = List<String>.from(Map<String, dynamic>.from(info['avgByAgeGroup']).keys);
        //     return Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         Text(keys[index]),
        //         Text(info['avgByAgeGroup'][keys[index]]['avg'].toString()),
        //         Text(info['avgByAgeGroup'][keys[index]]['place'].toString()),
        //       ],
        //     );
        //   }),
        // )
      ],
    );
  }

  Widget buildColumn(String key, List<String> keys, {bool text = false}) => Column(
        children: List.generate(info['avgByAgeGroup'].length,
            (index) => Column(
              children: [
                Text(text ? keys[index] : info['avgByAgeGroup'][keys[index]][key].toString()),
                SizedBox(height: text ? 5 : 8,)
              ],
            )),
      );
}
