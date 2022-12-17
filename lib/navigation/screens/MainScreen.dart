import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matka/PaymentScreen.dart';
import 'package:matka/navigation/screens/ChartScreen.dart';
import 'package:matka/navigation/screens/HomeScreen.dart';
import 'package:matka/navigation/screens/ProfileScreen.dart';
import 'package:matka/providers/user_provider.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddBalanceScreen.dart';
import 'GameRatesScreen.dart';
import 'GameTicketScreen.dart';
import 'WebViewScreen.dart';
import 'WithdrowalListScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  MainScreenState mainScreen;
  static Map<String, dynamic> resJson;
  // ignore: non_constant_identifier_names
  static int BottomCurrentPage = 0;
  static Map<String, dynamic> userInfo;
  PackageInfo packageInfo;
  // ignore: deprecated_member_use
  List<Widget> drawerOptions = new List<Widget>();
  static int _selectedDrawerFragmentIndex = 0;

  @override
  void initState() {
    super.initState();
    mainScreen = this;
    loadMenu();
    callService();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      // ignore: unnecessary_statements
      drawerOptions;
    });
    return Scaffold(
      appBar: CU.getAppbar(
        context,
        _selectedDrawerFragmentIndex == 0
            ? "Home"
            : _selectedDrawerFragmentIndex == 1
                ? "Payment Method"
                : _selectedDrawerFragmentIndex == 2
                    ? "Withdraw"
                    : "Profile",
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                CS.AppNmae,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                CU.email,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: Image.asset('assets/logo.png'),
            ),
            (drawerOptions == null)
                ? Container()
                : Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 0),
                      children: drawerOptions,
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Text(
                packageInfo?.version ?? "",
                style: TextStyle(
                    color: CU.primaryColor, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: GetBottomNavigation(),
      body: resJson == null
          ? Container()
          : onSelectRedirectScreen(
              setState: setState,
              context: context,
              Screen: _selectedDrawerFragmentIndex,
              data: null,
              isFragment: true),
    );
  }

// ignore: non_constant_identifier_names
  static Widget onSelectRedirectScreen(
      {setState,
      @required context,
      // ignore: non_constant_identifier_names
      @required Screen,
      data,
      isFragment = false}) {
    log('Screen =>1 ' + Screen.toString());

    switch (Screen.toString()) {
      case "0": //My Courses
        if (isFragment) {
          return HomeScreen(resJson[CS.lstgamedata], userInfo);
        } else {
          _selectedDrawerFragmentIndex = int.parse(Screen.toString());
          setState(() {});
        }
        break;
      case "1": //Home
        if (isFragment) {
          return WalletHomePage();
        } else {
          _selectedDrawerFragmentIndex = int.parse(Screen.toString());
          setState(() {});
        }
        break;
      case "2": //Home
        if (isFragment) {
          return WithdrowalListScreen();
        } else {
          _selectedDrawerFragmentIndex = int.parse(Screen.toString());
          setState(() {});
        }
        break;
      case "3": //Activities Tracker
        return ProfileScreen.bottom();
        break;
      case "4": //Home
      case "ProfileScreen": //Home
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ProfileScreen()));
        break; //Home
      case "GameRatesScreen": //Home
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => GameRatesScreen()));
        break;
      case "TermsOfUse": //Home
        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddMoney()));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WebViewPage("Terms Of Use",
                    "http://matka.flomiz.com/TermsofUse.aspx")));
        break;
      case "GameHistoryScreen": //Home
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => GameTicketScreen()));
        break;
      case "Chart": //Home
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChartScreen(resJson[CS.lstgamedata], userInfo)));
        break;
      case "AddBalanceScreen": //Home
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AddBalanceScreen()));
        break;
      case "BalanceListScreen": //Home
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AddBalanceScreen()));
        break;
      case "5": //Home
//        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SubjectScreen(data)));
        break;
      case "Share":
        CU.ShareText(
            "One place for your all matka App \nAndroid: https://play.google.com/store/apps/details?id=com.pkGames.matka");
        break;
      case "Rate":
        RateMyAppBuilder(
          builder: (context) => MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Rate my app !'),
              ),
              body: Center(child: Text('This is my beautiful app !')),
            ),
          ),
          onInitialized: (context, rateMyApp) {
            // Called when Rate my app has been initialized.
            // See the example project on Github for more info.
          },
        );
        break;
      case "100": //Logout
//        SchedulerBinding.instance.addPostFrameCallback((_) {
        CU.logout(context);
//        });
        break;
      default:
//        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ComeingSoonScreen()));
        break;
    }
    return null;
  }

  Future<void> callService() async {
    Map<String, dynamic> body = <String, dynamic>{};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mno = "0";
    if (prefs.containsKey("mno")) {
      mno = prefs.getString("mno");
    }

    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context,
          body: body,
          apiUrl: CS.homeScreen + mno,
          isShowPogressDilog: true,
          callMethod: CallMethod.Get);
      Provider.of<UserProvider>(context, listen: false).updateResJson(resJson);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }

    if (resJson[CS.status].toString() == StatusCode.Success) {
      log(resJson.toString());
      setState(() {});
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CU.showDiloag(context, resJson[CS.message]);
          });
    }
  }

// ignore: non_constant_identifier_names
  GetBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedDrawerFragmentIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (position) {
        switch (position) {
          case 0:
            _selectedDrawerFragmentIndex = position;
            setState(() {});
            break;
          case 1:
          case 2:
          case 3:
            if (CU.IsLogin(context: context, action: true))
              setState(() {
                _selectedDrawerFragmentIndex = position;
              });
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                return ui.Gradient.linear(
                  Offset(4.0, 24.0),
                  Offset(24.0, 4.0),
                  [
                    Colors.blue[200],
                    Colors.red,
                  ],
                );
              },
              child: Icon(Icons.account_balance_wallet)),
          label: 'Add Points',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          label: 'Withdraw',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Future<void> loadMenu() async {
    userInfo = await CU.getUserInfo();
    packageInfo = await PackageInfo.fromPlatform();
    List<dynamic> menuList =
        jsonDecode(await rootBundle.loadString('assets/dataModal/menu.json'));
    setState(() {
      //log("====================================2=========");
      log(userInfo.toString());
      //log("====================================2=========");
      _selectedDrawerFragmentIndex = 0;
      drawerOptions = GetMenuItems(menuList);
    });

//    setState(() {});
  }

// ignore: non_constant_identifier_names
  GetMenuItems(menuList) {
    //log(menuList.toString());
    // ignore: deprecated_member_use
    if (menuList == null) return List<Widget>();
    List<dynamic> menu = menuList;
    // ignore: deprecated_member_use
    List<Widget> drawerOptions = List<Widget>();
    for (int i = 0; i < menu.length; i++) {
      drawerOptions.add(GetMenuItem(menu[i], i));
    }
    return drawerOptions;
  }

// ignore: non_constant_identifier_names
  GetMenuItem(menuItem, i) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onSelectRedirectScreen(
              setState: setState,
              context: context,
              Screen: menuItem[CS.redirectScreen],
              data: menuItem);
        },
        child: Column(
          children: <Widget>[
            (menuItem[CS.subMenuList] == null ||
                    menuItem[CS.subMenuList].length == 0)
                ? Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
                    child: Row(
                      children: <Widget>[
                        CU.loadImage(
                            url: menuItem[CS.image],
                            height: 22.0,
                            color: Colors.blue),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            menuItem[CS.menuName],
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.fromLTRB(24, 4, 16, 0),
                    child: ExpandablePanel(
                      header: Row(
                        children: <Widget>[
                          CU.loadImage(
                              url: menuItem[CS.image],
                              height: 22.0,
                              color: Colors.blue),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              menuItem[CS.menuName],
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      // headerAlignment: ExpandablePanelHeaderAlignment.center,
                      expanded: Column(
                        children: GetMenuItems(menuItem[CS.subMenuList]),
                      ),
                      collapsed: null,
                      // tapHeaderToExpand: true,
                      //hasIcon: true,
                      //iconColor: Colors.blue,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
