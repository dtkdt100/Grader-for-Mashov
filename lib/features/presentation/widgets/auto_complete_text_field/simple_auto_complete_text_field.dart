import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auto_complete_text_field.dart';

class SimpleAutoCompleteTextField extends AutoCompleteTextField<String> {
  final StringCallback? textChanged;
  final StringCallback textSubmitted;
  final int minLength;
  final ValueSetter<bool>? onFocusChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const SimpleAutoCompleteTextField(
      {TextStyle? style,
        InputDecoration decoration = const InputDecoration(),
        this.onFocusChanged,
        this.textChanged,
        required this.textSubmitted,
        this.minLength = 1,
        this.controller,
        this.focusNode,
        TextInputType keyboardType: TextInputType.text,
        required GlobalKey<AutoCompleteTextFieldState<String>> key,
        required List<String> suggestions,
        int suggestionsAmount = 5,
        bool submitOnSuggestionTap = true,
        bool clearOnSubmit = true,
        TextInputAction textInputAction = TextInputAction.done,
        TextCapitalization textCapitalization = TextCapitalization.sentences})
      : super(
      style: style,
      decoration: decoration,
      textChanged: textChanged,
      textSubmitted: textSubmitted,
      itemSubmitted: textSubmitted,
      keyboardType: keyboardType,
      key: key,
      suggestions: suggestions,
      itemBuilder: null,
      itemSorter: null,
      itemFilter: null,
      suggestionsAmount: suggestionsAmount,
      submitOnSuggestionTap: submitOnSuggestionTap,
      clearOnSubmit: clearOnSubmit,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => AutoCompleteTextFieldState<String>(
      suggestions,
      textChanged,
      textSubmitted,
      onFocusChanged,
      itemSubmitted, (context, item) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Text(item));
  }, (a, b) {
    return a.compareTo(b);
  }, (item, query) {
    if (item.startsWith(query)) {
      return item.startsWith(query);
    } else {
      for (int i = 0; i < item.length; i++) {
        if (item.substring(i).startsWith(query)) {
          return item.substring(i).startsWith(query);
        }
      }
    }
    return item.startsWith(query);
  },
      suggestionsAmount,
      submitOnSuggestionTap,
      clearOnSubmit,
      minLength,
      [],
      textCapitalization,
      decoration,
      style,
      keyboardType,
      textInputAction,
      controller,
      focusNode);
}