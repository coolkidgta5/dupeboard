import 'package:flutter/material.dart';
import 'add_dupe.dart';
import 'dupe_list.dart';
import 'dupeboard.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List<Widget> _children = [
    Dupeboard(),
    DupeList(),
    Settings(),
  ];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Dupeboard',
          style: TextStyle(color: Colors.black),
        ),
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: Color(0xF4FFFFFF),
        elevation: 0,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey[800],
        elevation: 8.0,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Transform.rotate(
              angle: 90 * 3.14159 / 180,
              child: Icon(
                Icons.whatshot,
              ),
            ),
            title: new Text('Dupeboard'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            title: new Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDupeSheet(),
        label: Text('Add New'),
        icon: Icon(Icons.add),
        elevation: 2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _showAddDupeSheet() async {
    final result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            child: AddDupe(),
          );
        });
    print(result);

    scaffoldKey.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text("$result"),
        duration: Duration(seconds: 2),
      ));
  }
}
