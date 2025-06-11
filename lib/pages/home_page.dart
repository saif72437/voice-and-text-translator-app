import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:voice_and_text_translator/pages/history_page.dart';
import 'package:voice_and_text_translator/pages/profile_page.dart';
import 'package:voice_and_text_translator/pages/voice_page.dart';

class HomePage extends StatefulWidget {
  // const HomePage({
  //   // super.key
  // });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  List<Widget> _widgetOptions = <Widget>[
    // Container(
    //   width: double.infinity,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Text("Home Page", style: optionStyle),
    //     ],
    //   ),
    // ),
    VoicePage(),
    // Container(
    //   width: double.infinity,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Text("Voice Page", style: optionStyle),
    //     ],
    //   ),
    // ),
    // Container(
    //   width: double.infinity,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Text("History Page", style: optionStyle),
    //     ],
    //   ),
    // ),
    HistoryPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar :  Container(
        color: Colors.grey.shade900,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
              backgroundColor: Colors.grey.shade900,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 8,
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(icon: Icons.home,
                  text: "Home",
                ),
                // GButton(icon: Icons.mic,
                //   text: "Voice",
                // ),
                // GButton(icon: Icons.history,
                //   text: "History",
                // ),
                GButton(icon: Icons.history,
                  text: "History",
                ),
                GButton(icon: Icons.person,
                  text: "Profile",
                ),

              ],
            selectedIndex: _selectedIndex,
            onTabChange: (index){
                setState(() {
                  _selectedIndex = index;
                });
            },
          ),
        ),
      ),
      body: _widgetOptions[_selectedIndex],

    );
  }
}

