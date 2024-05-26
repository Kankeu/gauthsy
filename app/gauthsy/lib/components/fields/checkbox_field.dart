part of fields;

class CheckboxField extends StatelessWidget {
  final bool value;
  final String label;
  final Function validator;
  final ValueChanged<bool> onChanged;

  CheckboxField({
    @required this.value,
    @required this.label,
    @required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
        validator: validator,
        onSaved: onChanged,
        initialValue: value,
        builder: (
            FormFieldState<bool> state,
            ) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        NeumorphicCheckbox(
                            style: NeumorphicCheckboxStyle(),
                            onChanged: (value) {
                              state.setValue(value);
                              onChanged(value);
                            },
                            value: value),
                        SizedBox(width: 10),
                        Container(
                          width: MediaQuery.of(context).size.width*.55,
                            child: Text(label, overflow: TextOverflow.clip)),
                      ],
                    )),
                if (state.hasError)
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
                    child: Text(state.errorText,
                        style: TextStyle(
                            fontSize: 12, color: UIData.colors.error)),
                  ),
              ]);
        });
  }
}
