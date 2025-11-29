import 'package:flutter/material.dart';

class TextFormFieldSubmit extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  const TextFormFieldSubmit({super.key, required this.onSubmit});

  @override
  State<TextFormFieldSubmit> createState() => _TextFormFieldSubmitState();
}

class _TextFormFieldSubmitState extends State<TextFormFieldSubmit> {
  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  // Declare a variable to kep track of the input text
  String _name = '';

  // use this to keep track of when the form is submitted
  bool _submitted = false;

  void _submit() {
    // set this variable to true when we try to submit
    setState(() {
      _submitted = true;
    });

    // validate all the form field
    if (_formKey.currentState!.validate()) {
      // on success, notify the parent widget
      widget.onSubmit(_name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "enter your name"),
            autovalidateMode:
                _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Cant be empty";
              }
              if (text.length < 4) {
                return "Too short";
              }

              return null;
            },
            // update the state variable when the text changes
            onChanged: (text) => setState(() => _name = text),
          ),

          SizedBox(height: 16),
          ElevatedButton(
            // only enable the button if the text is not empty
            onPressed: _name.isNotEmpty ? _submit : null,
            child: Text(
              'Submit',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
