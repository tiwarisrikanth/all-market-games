import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
import 'package:url_launcher/url_launcher.dart';

import 'WithdrowalScreen.dart';

class WithdrowalListScreen extends StatefulWidget {
  @override
  _WithdrowalListScreenState createState() => _WithdrowalListScreenState();
}

class _WithdrowalListScreenState extends State<WithdrowalListScreen> {
  List<dynamic> lstdata;
  Map<String, dynamic> resJson;

  @override
  void initState() {
    super.initState();
    //callService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = (await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          WithdrowalScreen()))) ??
              false;
          if (res) callService();
        },
        child: Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
      body: new SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.black])),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(12.0),
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      CS.AppNmae,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Minimum Withdraw - 1000 Rs Withdraw करने के लिए Admin sir को WhatsApp पर रिक्वेस्ट भेजीए और आपका Google pay या Phone pe का QR Code भेज दिजीए. ताकि आपका पेमेंट हर दिन रात 10pm to 12pm किया जाएगा. ( Sunday Close ).",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            launchURL("tel:" + "919022421815");
                          },
                          icon: Container(
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            launchURL("whatsapp://send?phone=91" +
                                "9022421815" +
                                "&text=hi");
                          },
                          icon: Image.asset(
                            "assets/whatsapp.png",
                            height: 40,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void launchURL(url) async {
    log(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getlistDesign(item) {
    return Card(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.asset(
                item[CS.WithdrawMode] == "Google Pay"
                    ? "assets/googlepay.png"
                    : item[CS.WithdrawMode] == "Paytm"
                        ? "assets/paytm.png"
                        : "assets/phonepay.png",
                height: 60,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(item[CS.MobileNo],
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text("Amount : " + item[CS.Amount].toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              color: item[CS.ApproveStatus] == "Approve"
                  ? Colors.green
                  : item[CS.ApproveStatus] == "Pending"
                      ? Colors.amber
                      : Colors.red,
              child: Text(
                item[CS.ApproveStatus],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> callService() async {
    Map<String, dynamic> body = <String, dynamic>{
//      CS.token: await CU.getToken(),
    };
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context,
          body: body,
          apiUrl: CS.lstclientwithdraw +
              MainScreenState.userInfo[k_clientid].toString(),
          callMethod: CallMethod.Get);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      lstdata = resJson[CS.lstclientwithdrawlistdata];
      setState(() {});
//      CU.showToast(context, resJson[CS.message], backgroundColor: Colors.green);
//      Navigator.of(context).pop();
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }
}
