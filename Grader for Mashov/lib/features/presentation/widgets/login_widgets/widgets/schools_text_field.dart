import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/login/school.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/auto_complete_text_field/auto_complete_text_field.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/auto_complete_text_field/simple_auto_complete_text_field.dart';

class SchoolTextField extends StatefulWidget {
  final List<School> schools;
  final VoidCallback onSelected;


  const SchoolTextField({Key? key, required this.schools, required this.onSelected}) : super(key: key);

  @override
  SchoolTextFieldState createState() => SchoolTextFieldState();
}

class SchoolTextFieldState extends State<SchoolTextField> {
  TextEditingController textControllerSchool = TextEditingController();

  School? selectedSchool;
  int? year;

  FocusNode focusNode = FocusNode();

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  void setSchool(School? school, int? year) {
    setState(() {
      selectedSchool = school;
      textControllerSchool.text = school == null ? '' : school.name;
      widget.onSelected();
      this.year = year;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SimpleAutoCompleteTextField(
          suggestionsAmount: 100,
          controller: textControllerSchool,
          key: key,
          keyboardType: TextInputType.text,
          focusNode: focusNode,
          decoration: InputDecoration(
              hintText: 'בחר ביה"ס',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    textControllerSchool.text = "";
                    selectedSchool = null;
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              )),
          suggestions: widget.schools.map((e) => e.name).toList(),
          clearOnSubmit: false,
          textSubmitted: (text) => setState(() {
            if (text != "") {
              selectedSchool = widget.schools.singleWhere((element) => element.name == text);
              widget.onSelected();
              selectedSchool!.years.sort((a, b) => b.compareTo(a));
              year = selectedSchool!.years.first;
              setState(() {

              });
            }
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
          child: DropdownButtonFormField(
            hint: const Text('בחר שנה'),
            decoration: InputDecoration(
              enabled: selectedSchool == null ? false : true,
              enabledBorder:
              const UnderlineInputBorder(borderSide: BorderSide()),
            ),
            items: selectedSchool == null
                ? null
                : List.generate(selectedSchool!.years.length, (index) {
              return DropdownMenuItem(
                  value: selectedSchool!.years[index],
                  child: Row(
                    children: <Widget>[
                      index == 0
                          ? const Text(
                        'השנה הנוכחית - ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      )
                          : const SizedBox(),
                      Text('${selectedSchool!.years[index]}',
                          style: TextStyle(
                              fontWeight: index == 0
                                  ? FontWeight.bold
                                  : FontWeight.w400)),
                    ],
                  ));
            }),
            onChanged: (int? newValue) {
              setState(() => year = newValue);
            },
            value: year,
          ),
        ),
      ],
    );
  }
}
