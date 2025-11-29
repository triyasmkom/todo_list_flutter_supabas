import 'package:flutter/material.dart';

class TextFieldSubmit extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  const TextFieldSubmit({super.key, required this.onSubmit});

  @override
  State<TextFieldSubmit> createState() => _TextFieldSubmitState();
}

class _TextFieldSubmitState extends State<TextFieldSubmit> {
  final _controller = TextEditingController();
  bool _submitted = false;

  void _submit() {
    setState(() => _submitted = true);
    if (_errorText == null) {
      widget.onSubmit(_controller.value.text);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  String? get _errorText {
    final text = _controller.value.text;
    if (text.isEmpty) {
      return " Can't Be Empty";
    }

    if (text.length < 4) {
      return 'Too short';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, TextEditingValue value, __) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  errorText: _submitted ? _errorText : null,
                ),
                onChanged: (_) => setState(() => {}),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _controller.value.text.isNotEmpty ? _submit : null,
                child: Text(
                  'Submit',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
