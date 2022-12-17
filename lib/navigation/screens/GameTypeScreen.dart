import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matka/modal/LoginModal.dart';
import 'package:matka/navigation/screens/GameDetailScreen.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/providers/user_provider.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class GameTypeScreen extends StatefulWidget {
  Map<String, dynamic> data;
  bool available;

  GameTypeScreen(this.data, {bool this.available});

  @override
  _GameTypeScreenState createState() =>
      _GameTypeScreenState(available: available);
}

class _GameTypeScreenState extends State<GameTypeScreen> {
  double width = 100;
  bool available;

  _GameTypeScreenState({bool this.available});
  // ignore: non_constant_identifier_names
  var GetOpenTime;
  // ignore: non_constant_identifier_names
  var GetCloseTime;
  @override
  void initState() {
    super.initState();
    GetOpenClosetime();
  }

//-------------------------------------//
// ignore: non_constant_identifier_names
  void GetOpenClosetime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      GetCloseTime = prefs.getString('CloseTime');
      GetOpenTime = prefs.getString('OpenTime');
    });
  }

//-------------------------------------//
  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) {
//      txtMobile.text = "9909906512";
//      txtMobile.text = "9925155594";
//      txtPassword.text = "123456";
    }
    return new Scaffold(
        // appBar: CU.getAppbar("Game Type"),
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
//        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.black])),
          child: ListView(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    getGameTypeCell(
                        image: "assets/singledigit.png",
                        title: "Single Digit",
                        type: 1),
                    getGameTypeCell(
                        image: "assets/jodidigit.png",
                        title: "Jodi Digit",
                        type: 2),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    getGameTypeCell(
                        image: "assets/singlepana.png",
                        title: "Single Pana",
                        type: 3),
                    getGameTypeCell(
                        image: "assets/doublepana.png",
                        title: "Double Pana",
                        type: 4),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    getGameTypeCell(
                        image: "assets/triplepana.png",
                        title: "Triple Pana",
                        type: 5),
                    getGameTypeCell(
                        image: "assets/half_sangam1_new.jpeg",
                        title: "Half Sangam",
                        type: 6),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    getGameTypeCell(
                        image: "assets/half_sangam2_new.jpeg",
                        title: "Half Sangam 2",
                        type: 8),
                    getGameTypeCell(
                        image: "assets/fullsangam.png",
                        title: "Full Sangam",
                        type: 7),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              CU.getContactDesign(),
            ],
          ),
        ));
  }

  _buildAppBar() {
    if (MainScreenState.userInfo != null) {
      // ignore: non_constant_identifier_names, deprecated_member_use
      List<Widget> actions = List<Widget>();
      LoginModal loginModal;
      if (MainScreenState.userInfo != null) {
        LoginModal.fromJson(MainScreenState.userInfo);
      }
      if (loginModal != null) {
        actions.add(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    CU.launchURL("whatsapp://send?phone=91" +
                        CU.MobileNo +
                        "&text=hi, Play matka with us.");
                  },
                  icon: Image.asset(
                    "assets/whatsapp.png",
                    color: Colors.white,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome '" + loginModal.clientname != null
                          ? loginModal.clientname.toString()
                          : "" + "'",
                      style: new TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
//      gradient: LinearGradient(colors: primaryGradientColor),
      title: MainScreenState.resJson != null
          ? MainScreenState.resJson["walletamount"] != null
              ? Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Game Type',
                              style: new TextStyle(color: Colors.white)),
                          Text(widget.data[CS.gamename],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Points : " +
                            Provider.of<UserProvider>(context)
                                .resJson["walletamount"]
                                .toString(),
                        style: new TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    )
                  ],
                )
              : CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Game Type'),
                Text(widget.data[CS.gamename],
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  getGameTypeCell({title = "", image: "assets/logo.png", type: 1}) {
    return InkWell(
      onTap: () {
        // ignore: non_constant_identifier_names
        var Cell = <String, dynamic>{
          CS.title: title,
          CS.type: type,
          CS.gameid: widget.data[CS.gameid]
        };
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => GameDetailScreen(
                      Cell,
                      available: available,
                      type: type,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: width,
        alignment: Alignment.center,
        width: width,
        color: Colors.white,
        child: Image.asset(
          image,
        ),
      ),
    );
  }
}
