import 'package:flutter/cupertino.dart';

class TextFieldLabel extends StatelessWidget {
  String text;
   TextFieldLabel( {
     // super.key,
     required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(text)
        ],
      ),
    );
  }
}
