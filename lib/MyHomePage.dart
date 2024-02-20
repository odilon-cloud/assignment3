import 'package:assignment3/ThemeHolder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:assignment3/CalculatorView.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isDarkMode;
  late PageController _pageController;
  int _selectedTabIndex = 0;
  late ConnectivityResult _connectivityResult;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _pageController = PageController(initialPage: _selectedTabIndex);
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
        if (_connectivityResult != ConnectivityResult.none) {
          _showSnackbar('Back online');
        }else {_showSnackbar('device offline');}
      });
    });
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _toggleTheme() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   isDarkMode = !isDarkMode;
    //   prefs.setBool('isDarkMode', isDarkMode);
    // });
    ThemeHolder().changeState(!ThemeHolder().getTheme);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _connectivityResult = connectivityResult;
      if (_connectivityResult == ConnectivityResult.none) {
        _showSnackbar('Offline');
      }
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
          return StreamBuilder<bool>(
            stream: ThemeHolder().getThemeBroadcast(),
            builder: (context, snapshot) {
              return Scaffold(
                backgroundColor: ThemeHolder().getTheme ? Colors.black : Colors.white,
                appBar: AppBar(
                  backgroundColor: ThemeHolder().getTheme ? Colors.black : Colors.white,
                  actions: [
                    Switch(
                      value: ThemeHolder().getTheme,
                      onChanged: (value) {
                        _toggleTheme();
                      },
                    ),
                  ],
                ),
                drawer: Drawer(

                  child: Container(
                    color: ThemeHolder().getTheme ? Colors.black : Colors.white,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                        ),
                        child: Text(
                          'MENU',
                          style: TextStyle(
                            color: ThemeHolder().getTheme ? Colors.white : Colors.black,
                            fontSize: 30),
                        ),
                      ),
                      ListTile(


                        title: Text('HOME',style: TextStyle(
                            color: ThemeHolder().getTheme ? Colors.white : Colors.black,
                            fontSize: 14),),
                        onTap: () {
                          Navigator.pop(context);
                          _onItemTapped(0);
                        },
                      ),
                      ListTile(
                        title: Text('CALCULATOR',style: TextStyle(
                            color: ThemeHolder().getTheme ? Colors.white : Colors.black,
                            fontSize: 14),),
                        onTap: () {
                          Navigator.pop(context);
                          _onItemTapped(1);
                        },
                      ),
                      ListTile(
                        title: Text('ABOUT',style: TextStyle(
                            color: ThemeHolder().getTheme ? Colors.white : Colors.black,
                            fontSize: 14),),
                        onTap: () {
                          Navigator.pop(context);
                          _onItemTapped(2);
                        },
                      ),
                    ],
                  ),),
                ),
                body: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  children: [
                    Center(
                      child: Text(
                        'Home Page',
                        style: TextStyle(
                          color: ThemeHolder().getTheme ? Colors.white : Colors.black,
                          fontSize: 50,
                        ),
                      ),
                    ),
                    CalculatorPage(),
                    AboutPage(),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _selectedTabIndex,
                  onTap: _onItemTapped,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'HOME',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calculate),
                      label: 'Calc',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'About',
                    ),
                  ],
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.grey,
                  backgroundColor: ThemeHolder().getTheme ? Colors.black : Colors.white,
                ),
              );
            }
          );


  }
}

class CalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHolder().getTheme ? Colors.black : Colors.white,
      body: Center(
        child: CalculatorView(),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHolder().getTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text(
          'About Page',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
