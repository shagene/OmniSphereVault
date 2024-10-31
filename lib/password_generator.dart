import 'package:flutter/material.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  @override
  _PasswordGeneratorScreenState createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  double _passwordLength = 16;
  bool _useUppercase = true;
  bool _useLowercase = true;
  bool _useNumbers = true;
  bool _useSpecialChars = true;
  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Generator'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generated Password',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _generatedPassword,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    // Implement copy functionality
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Password Length: ${_passwordLength.round()}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Slider(
              value: _passwordLength,
              min: 8,
              max: 64,
              divisions: 56,
              onChanged: (value) {
                setState(() {
                  _passwordLength = value;
                });
                _generatePassword();
              },
            ),
            _buildToggle('Uppercase Letters', _useUppercase, (value) {
              setState(() {
                _useUppercase = value!;
              });
              _generatePassword();
            }),
            _buildToggle('Lowercase Letters', _useLowercase, (value) {
              setState(() {
                _useLowercase = value!;
              });
              _generatePassword();
            }),
            _buildToggle('Numbers', _useNumbers, (value) {
              setState(() {
                _useNumbers = value!;
              });
              _generatePassword();
            }),
            _buildToggle('Special Characters', _useSpecialChars, (value) {
              setState(() {
                _useSpecialChars = value!;
              });
              _generatePassword();
            }),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Regenerate Password'),
              onPressed: _generatePassword,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _generatePassword() {
    // Implement password generation logic here
    setState(() {
      _generatedPassword = 'GeneratedP@ssw0rd';
    });
  }
}