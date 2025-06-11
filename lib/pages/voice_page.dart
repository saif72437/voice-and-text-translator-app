import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class VoicePage extends StatefulWidget {
  // const VoicePage({super.key});

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {

  SpeechToText speech = SpeechToText();
  bool isListening = false;
  String text = "";
  String outputText = "";
  bool isTranslating = false;

  // List<String> languagesName = ['en', 'ur', 'hi', 'pa'];

  // List<String> languagesName = [
  //
  //   "af",
  //   "sq",
  //   "am",
  //   "ar",
  //   "hy",
  //   "az",
  //   "eu",
  //   "be",
  //   "bn",
  //   "bs",
  //   "bg",
  //   "ca",
  //   "ceb",
  //   "ny ",
  //   "zh",
  //   "zh",
  //   "co",
  //   "hr",
  //   "cs",
  //   "da",
  //   "nl",
  //   "en",
  //   "eo",
  //   "et",
  //   "tl",
  //   "fi",
  //   "fr",
  //   "fy",
  //   "gl",
  //   "ka",
  //   "de",
  //   "el",
  //   "gu",
  //   "ht",
  //   "ha",
  //   "ha",
  //   "iw",
  //   "hi",
  //   "hm",
  //   "hu",
  //   "is",
  //   "ig",
  //   "id",
  //   "ga",
  //   "it",
  //   "ja",
  //   "jw",
  //   "kn",
  //   "kk",
  //   "km",
  //   "ko",
  //   "ku",
  //   "ky",
  //   "lo",
  //   "la",
  //   "lv",
  //   "lt",
  //   "lb",
  //   "mk",
  //   "mg",
  //   "ms",
  //   "ml",
  //   "mt",
  //   "mi",
  //   "mr",
  //   "mn",
  //   "my",
  //   "ne",
  //   "no",
  //   "ps",
  //   "fa",
  //   "pl",
  //   "pt",
  //   "pa",
  //   "ro",
  //   "ru",
  //   "sm",
  //   "gd",
  //   "sr",
  //   "st",
  //   "sn",
  //   "sd",
  //   "si",
  //   "sk",
  //   "sl",
  //   "so",
  //   "es",
  //   "su",
  //   "sw",
  //   "sv",
  //   "tg",
  //   "ta",
  //   "te",
  //   "th",
  //   "tr",
  //   "uk",
  //   "ur",
  //   "uz",
  //   "vi",
  //   "cy",
  //   "xh",
  //   "yi",
  //   "yo",
  //   "zu",
  // ];
  List<Map<String, String>> languages = [
    {"code": "af", "name": "Afrikaans"},
    {"code": "sq", "name": "Albanian"},
    {"code": "am", "name": "Amharic"},
    {"code": "ar", "name": "Arabic"},
    {"code": "hy", "name": "Armenian"},
    {"code": "az", "name": "Azerbaijani"},
    {"code": "eu", "name": "Basque"},
    {"code": "be", "name": "Belarusian"},
    {"code": "bn", "name": "Bengali"},
    {"code": "bs", "name": "Bosnian"},
    {"code": "bg", "name": "Bulgarian"},
    {"code": "ca", "name": "Catalan"},
    {"code": "ceb", "name": "Cebuano"},
    {"code": "ny", "name": "Chichewa"},
    {"code": "zh", "name": "Chinese (Simplified)"},
    {"code": "zh-TW", "name": "Chinese (Traditional)"},
    {"code": "co", "name": "Corsican"},
    {"code": "hr", "name": "Croatian"},
    {"code": "cs", "name": "Czech"},
    {"code": "da", "name": "Danish"},
    {"code": "nl", "name": "Dutch"},
    {"code": "en", "name": "English"},
    {"code": "eo", "name": "Esperanto"},
    {"code": "et", "name": "Estonian"},
    {"code": "tl", "name": "Filipino"},
    {"code": "fi", "name": "Finnish"},
    {"code": "fr", "name": "French"},
    {"code": "fy", "name": "Frisian"},
    {"code": "gl", "name": "Galician"},
    {"code": "ka", "name": "Georgian"},
    {"code": "de", "name": "German"},
    {"code": "el", "name": "Greek"},
    {"code": "gu", "name": "Gujarati"},
    {"code": "ht", "name": "Haitian Creole"},
    {"code": "ha", "name": "Hausa"},
    {"code": "haw", "name": "Hawaiian"},
    {"code": "iw", "name": "Hebrew"},
    {"code": "hi", "name": "Hindi"},
    {"code": "hmong", "name": "Hmong"},
    {"code": "hu", "name": "Hungarian"},
    {"code": "is", "name": "Icelandic"},
    {"code": "ig", "name": "Igbo"},
    {"code": "id", "name": "Indonesian"},
    {"code": "ga", "name": "Irish"},
    {"code": "it", "name": "Italian"},
    {"code": "ja", "name": "Japanese"},
    {"code": "jw", "name": "Javanese"},
    {"code": "kn", "name": "Kannada"},
    {"code": "kk", "name": "Kazakh"},
    {"code": "km", "name": "Khmer"},
    {"code": "ko", "name": "Korean"},
    {"code": "ku", "name": "Kurdish (Kurmanji)"},
    {"code": "ky", "name": "Kyrgyz"},
    {"code": "lo", "name": "Lao"},
    {"code": "la", "name": "Latin"},
    {"code": "lv", "name": "Latvian"},
    {"code": "lt", "name": "Lithuanian"},
    {"code": "lb", "name": "Luxembourgish"},
    {"code": "mk", "name": "Macedonian"},
    {"code": "mg", "name": "Malagasy"},
    {"code": "ms", "name": "Malay"},
    {"code": "ml", "name": "Malayalam"},
    {"code": "mt", "name": "Maltese"},
    {"code": "mi", "name": "Maori"},
    {"code": "mr", "name": "Marathi"},
    {"code": "mn", "name": "Mongolian"},
    {"code": "my", "name": "Myanmar (Burmese)"},
    {"code": "ne", "name": "Nepali"},
    {"code": "no", "name": "Norwegian"},
    {"code": "or", "name": "Odia"},
    {"code": "ps", "name": "Pashto"},
    {"code": "fa", "name": "Persian"},
    {"code": "pl", "name": "Polish"},
    {"code": "pt", "name": "Portuguese"},
    {"code": "pa", "name": "Punjabi"},
    {"code": "ro", "name": "Romanian"},
    {"code": "ru", "name": "Russian"},
    {"code": "sm", "name": "Samoan"},
    {"code": "gd", "name": "Scots Gaelic"},
    {"code": "sr", "name": "Serbian"},
    {"code": "st", "name": "Sesotho"},
    {"code": "sn", "name": "Shona"},
    {"code": "sd", "name": "Sindhi"},
    {"code": "si", "name": "Sinhala"},
    {"code": "sk", "name": "Slovak"},
    {"code": "sl", "name": "Slovenian"},
    {"code": "so", "name": "Somali"},
    {"code": "es", "name": "Spanish"},
    {"code": "su", "name": "Sundanese"},
    {"code": "sw", "name": "Swahili"},
    {"code": "sv", "name": "Swedish"},
    {"code": "tg", "name": "Tajik"},
    {"code": "ta", "name": "Tamil"},
    {"code": "te", "name": "Telugu"},
    {"code": "th", "name": "Thai"},
    {"code": "tr", "name": "Turkish"},
    {"code": "tk", "name": "Turkmen"},
    {"code": "uk", "name": "Ukrainian"},
    {"code": "ur", "name": "Urdu"},
    {"code": "ug", "name": "Uyghur"},
    {"code": "uz", "name": "Uzbek"},
    {"code": "vi", "name": "Vietnamese"},
    {"code": "cy", "name": "Welsh"},
    {"code": "xh", "name": "Xhosa"},
    {"code": "yi", "name": "Yiddish"},
    {"code": "yo", "name": "Yoruba"},
    {"code": "zu", "name": "Zulu"},
  ];

  String fromValue = "en";
  String toValue = "ur";

  TextEditingController textController = TextEditingController();
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() {});
    }
  }

  void _translateText() {
    setState(() {
      isTranslating = true;
    });
    if (toValue.isNotEmpty) {
      translator.translate(textController.text, from: fromValue,to: toValue).then((value) {
        setState(() {
          isTranslating =false;
          outputText = value.text;
          // storing in firebase realtime database
          DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
          String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
          String sanitizedId = UniqueKey().toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '-'); // Sanitize the ID
          String translationUniqueId = sanitizedId;

          databaseReference.child('History').child(currentUserUid!).child(translationUniqueId).set({
            'originalText': textController.text,
            'translatedText': value.text,
          });
          // storing data in firebase real time database end here

        });
      }).catchError((error) {
        setState(() {
          isTranslating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Some Translation Error Occur'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Invalid Language Code'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  String getLanguageName(String code) {
    for (var language in languages) {
      if (language["code"] == code) {
        return language["name"]!;
      }
    }
    return "Select Language";
  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!isListening) {
              startListening();
            } else {
              stopListening();
            }
          },
          child: Icon(isListening ? Icons.stop : Icons.mic),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                        Container(
                          width: 100,
                          child: DropdownButton<String>(
                              isExpanded: true,
                            underline: Container(),
                            dropdownColor: Colors.white,
                            focusColor: Colors.transparent,
                            hint: Text(getLanguageName(fromValue)),
                            onChanged: (String? value) {
                              setState(() {
                                fromValue = value!;
                              });
                            },
                            items: languages.map<DropdownMenuItem<String>>((Map<String, String> language) {
                              return DropdownMenuItem<String>(
                                value: language["code"],
                                child: Text(language["name"]!),
                              );
                            }).toList(),
                          ),
                        ),
                      ],),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("To", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                        Container(
                          width: 100,
                          child: DropdownButton<String>(
                            underline: Container(),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            focusColor: Colors.transparent,
                            hint: Text(getLanguageName(toValue)),
                            onChanged: (String? value) {
                              setState(() {
                                toValue = value!;
                              });
                            },
                            items: languages.map<DropdownMenuItem<String>>((Map<String, String> language) {
                              return DropdownMenuItem<String>(
                                value: language["code"],
                                child: Text(language["name"]!),
                              );
                            }).toList(),
                          ),
                        ),
                      ],),



                  ],
                ),
              ),

              SizedBox(height: 20,),

              MyTextField(controller: textController, hintText: "Enter something...", obscureText: false),
              SizedBox(height: 20.0),
              // Text(text),
              // Divider(height: 1, color: Colors.grey,),
              SizedBox(height: 20.0),
              MyButton(onTap: (){
                _translateText();
              }, text: isTranslating ? "Translating...." : "Translate"),

              SizedBox(height: 20.0),

              Divider(height: 1, color: Colors.grey,),
              SizedBox(height: 20.0),

              Text(outputText, style: TextStyle(fontSize: 15), textAlign: TextAlign.center,)

            ],
          ),
        ),
      ),
    );
  }


  void startListening() {
    speech.listen(
      onResult: (result) {
        setState(() {
          text = result.recognizedWords;
          textController.text = text; // Update the text field with the recognized words



        });
      },

    );
    setState(() => isListening = true);
  }
  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }


}
