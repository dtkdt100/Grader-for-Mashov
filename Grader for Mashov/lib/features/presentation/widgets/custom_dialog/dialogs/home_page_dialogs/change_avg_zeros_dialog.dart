import '../../../../../../utilities/phone/shared_preferences_utilities.dart';

import '../../custom_dialog.dart';

enum Avg { yes, no }

class InfoForChange {String title; String description; InfoForChange(this.title, this.description);}

class ChangeAvgZerosDialog extends CustomDialog<InfoForChange> {
  ChangeAvgZerosDialog() : super(dialog);

  static List<String> names = ['כן', 'לא'];

  static Avg _avg = SharedPreferencesUtilities.removeZeros ? Avg.yes : Avg.no;

  static Widget dialog(BuildContext context, {InfoForChange? value}) {
    if (value != null && value.title.contains('נוחכות')) {
      _avg = SharedPreferencesUtilities.removeInClass ? Avg.yes : Avg.no;
    } else {
      _avg = SharedPreferencesUtilities.removeZeros ? Avg.yes : Avg.no;
    }
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                value!.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              value.description,
              style: const TextStyle(fontSize: 15),),
            const SizedBox(height: 10,),
            Column(
                children: List.generate(names.length, (index) {
                  Avg? wawa() {
                    switch (index) {
                      case (0):
                        return Avg.yes;
                      case (1):
                        return Avg.no;
                    }
                    return null;
                  }

                  return RadioListTile<Avg>(
                    activeColor: const Color(0xFF03a9f4),
                    title: Text(
                      names[index],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    value: wawa()!,
                    groupValue: _avg,
                    onChanged: (Avg? value) {
                      setState(() {
                        _avg = value!;
                      });
                    },
                  );
                })),
            Theme(
              data: ThemeData(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 8,
                      child: SizedBox(
                        height: 40,
                        child: TextButton(
                          child: const Text(
                            'ביטול',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 8,
                      child: SizedBox(
                        height: 40,
                        child: TextButton(
                          child: const Text(
                            'אישור',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () =>
                              Navigator.pop(context, _avg == Avg.yes),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
