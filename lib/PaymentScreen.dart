import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:matka/modal/ClientPaymentModal.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
// import 'package:upi_pay/upi_pay.dart';

//-------------------------------------
// ignore: non_constant_identifier_names, must_be_immutable
class WalletHomePage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String amt;

  // ignore: non_constant_identifier_names
  String TID;

  // ignore: non_constant_identifier_names
  String Mobile;

  // ignore: non_constant_identifier_names
  WalletHomePage({
    // ignore: non_constant_identifier_names
    this.amt,
    // ignore: non_constant_identifier_names
    this.TID,
    // ignore: non_constant_identifier_names
    this.Mobile,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

//-------------------------------------
class _HomePageState extends State<WalletHomePage> {
//   // ignore: non_constant_identifier_names
//   final GlobalKey<ScaffoldState> _KeyExitApp = GlobalKey<ScaffoldState>();
// //----------------------------------------------------------------------------//
//   String _upiAddrError;
//   final _upiAddressController = TextEditingController();
//   final _amountController = TextEditingController();
//   bool _isUpiEditable = false;
//   // List<ApplicationMeta> _apps;
// //----------------------------------------------------------------------------//
//   @override
//   void initState() {
//     super.initState();
//     // we have used sample UPI address (will be used to receive amount)
//     _upiAddressController.text = 'pkonlinecenter420@okhdfcbank';
//     _amountController.text = widget.amt.toString().trim();
//     // used for getting list of UPI apps installed in current device
//     // Future.delayed(Duration(milliseconds: 0), () async {
//     //   _apps = await UpiPay.getInstalledUpiApplications(
//     //       statusType: UpiApplicationDiscoveryAppStatusType.all);
//     //   setState(() {});
//     // });
//   }

// //-------------------------------------
//   @override
//   void dispose() {
//     _amountController.dispose();
//     _upiAddressController.dispose();
//     super.dispose();
//   }

// //-------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Text(
                    'ऑनलाइन मटका कैसे खेलें ऑनलाईन मटका खेलने के लिए सबसे पहले आपको हमारे पास पैसे डिपॉजिट करवाना है, कम से कम 500 रु. डिपॉजिट करना हैं, उससे कम अमाऊंट नहीं लिया जायेगा पैसे डिपॉजिट करने के बाद आपने जितने पैसे डिपॉजिट किया हैं उसका TRANSACTION ID SCREEN SHOT हमारे WHATSAPP पर भेजीए ताकि आपके वॉलेट के उपर ONLY 30 सेकंड में पॉईंट अॅड कर दिए जायेंगे पॉईंट अॅड होने के बाद आपको नोटिफिकेशन मिलेगा की आपके वॉलेट में आपके डिपॉजिट किए हुए पैसे अॅड किए गये हैं. उसके बाद आप जो गेम खेलना चाहते हो वो गेम खेल सकते हैं, यदी आप गेम में पैसे जीत जाते हैं तो जिते हुए पैसे हमारे मटका रेट के अनुसार आपके वॉलेट में ऑटोमॅटिक अँड होंगे और आपका वॉलेट बॅलन्स बढ जाएगा. 500 Rs-500 Point Minimum Deposit - 500 Rs निचे दिए गए QR CODE पर स्कॅन करके पेमेंट भेजीए.',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset('assets/payQR.jpeg')
              ],
            ),
          ),
        ),
      ),
    );
  }

//----------------------------------------------------------------------------//
  String _validateUpiAddress(String value) {
    if (value.isEmpty) {
      return 'UPI VPA is required.';
    }
    if (value.split('@').length != 2) {
      return 'Invalid UPI VPA';
    }
    return null;
  }

//----------------------------------------------------------------------------//
  // Widget _vpa() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 32),
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           child: TextFormField(
  //             controller: _upiAddressController,
  //             enabled: _isUpiEditable,
  //             decoration: InputDecoration(
  //               border: OutlineInputBorder(),
  //               hintText: 'pkonlinecenter420@okhdfcbank',
  //               labelText: 'Receiving UPI Address',
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

//----------------------------------------------------------------------------//
  // Widget _vpaError() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 4, left: 12),
  //     child: Text(
  //       _upiAddrError,
  //       style: TextStyle(color: Colors.red),
  //     ),
  //   );
  // }

//----------------------------------------------------------------------------//
  // Widget _amount() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 12),
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           child: TextField(
  //             controller: _amountController,
  //             readOnly: true,
  //             enabled: false,
  //             decoration: InputDecoration(
  //               border: OutlineInputBorder(),
  //               labelText: 'Amount',
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

//----------------------------------------------------------------------------//
  // Widget _submitButton() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 32),
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           child: MaterialButton(
  //             onPressed: () async => await _onTap(_apps[0]),
  //             child: Text('Initiate Transaction',
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .button
  //                     .copyWith(color: Colors.white)),
  //             color: Theme.of(context).colorScheme.secondary,
  //             height: 48,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(6)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

//----------------------------------------------------------------------------//
  Widget _androidApps() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              'Pay Using Phonepay',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          // if (_apps != null) _appsGrid(_apps.map((e) => e).toList()),
        ],
      ),
    );
  }

//----------------------------------------------------------------------------//
  Widget _iosApps() {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 24),
            child: Text(
              'One of these will be invoked automatically by your phone to '
              'make a payment',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              'Detected Installed Apps',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          // if (_apps != null) _discoverableAppsGrid(),
          // Container(
          //   margin: EdgeInsets.only(top: 12, bottom: 12),
          //   child: Text(
          //     'Other Supported Apps (Cannot detect)',
          //     style: Theme.of(context).textTheme.bodyText1,
          //   ),
          // ),
          // if (_apps != null) _nonDiscoverableAppsGrid(),
        ],
      ),
    );
  }

//----------------------------------------------------------------------------//
  // GridView _discoverableAppsGrid() {
  //   List<ApplicationMeta> metaList = [];
  //   _apps.forEach((e) {
  //     if (e.upiApplication.discoveryCustomScheme != null) {
  //       metaList.add(e);
  //     }
  //   });
  //   return _appsGrid(metaList);
  // }

//----------------------------------------------------------------------------//
  // GridView _nonDiscoverableAppsGrid() {
  //   // List<ApplicationMeta> metaList = [];
  //   _apps.forEach((e) {
  //     if (e.upiApplication.discoveryCustomScheme == null) {
  //       metaList.add(e);
  //     }
  //   });
  //   return _appsGrid(metaList);
  // }

//----------------------------------------------------------------------------//
//   GridView _appsGrid(List<ApplicationMeta> apps) {
//     apps.sort((a, b) => a.upiApplication
//         .getAppName()
//         .toLowerCase()
//         .compareTo(b.upiApplication.getAppName().toLowerCase()));
//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       mainAxisSpacing: 5,
//       crossAxisSpacing: 5,
//       childAspectRatio: 2.0,
//       physics: NeverScrollableScrollPhysics(),
//       children: apps
//           .map(
//             (it) => Material(
//               key: ObjectKey(it.upiApplication),
//               color: Colors.grey[200],
//               child: InkWell(
//                 onTap: Platform.isAndroid ? () async => await _onTap(it) : null,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     it.iconImage(48),
//                     Container(
//                       margin: EdgeInsets.only(top: 4),
//                       alignment: Alignment.center,
//                       child: Text(
//                         it.upiApplication.getAppName(),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }

// //----------------------------------------------------------------------------//
// // this will open correspondence UPI Payment gateway app on which user has tapped.
//   Future<void> _onTap(ApplicationMeta app) async {
//     final err = _validateUpiAddress(_upiAddressController.text);
//     if (err != null) {
//       setState(() {
//         _upiAddrError = err;
//       });
//       return;
//     }
//     setState(() {
//       _upiAddrError = null;
//     });
//     final transactionRef = Random.secure().nextInt(1 << 32).toString();
//     final a = await UpiPay.initiateTransaction(
//       amount: _amountController.text,
//       app: app.upiApplication,
//       receiverName: 'PK Online Center',
//       receiverUpiAddress: "pkonlinecenter420@okhdfcbank",
//       transactionRef: transactionRef,
//       transactionNote: 'UPI Payment',
//     );
//     setState(() {
//       var txnId = a.txnId;
//       var responseCode = a.responseCode;
//       var approvalRefNo = a.approvalRefNo;
//       var status = a.status;
//       var txnRef = a.txnRef;
//       var rawResponse = a.rawResponse;
//       TransactionAlert(context, txnId, responseCode, approvalRefNo, status,
//           txnRef, rawResponse);
//     });
//   }

//----------------------------------------------------------------------------//
  // ignore: non_constant_identifier_names
  // Future<void> TransactionAlert(BuildContext context, txnId, responseCode,
  //     approvalRefNo, status, txnRef, rawResponse) async {
  //   setState(() {
  //     // ignore: unnecessary_statements
  //     status;
  //   });
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: true, // user must tap button!
  //     builder: (BuildContext context) => new WillPopScope(
  //         onWillPop: () async => false,
  //         key: _KeyExitApp,
  //         child: AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(12.0))),
  //           contentPadding: EdgeInsets.only(top: 0.0),
  //           content: Container(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 new Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.blue,
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(12.0),
  //                         topRight: Radius.circular(12.0)),
  //                   ),
  //                   padding: EdgeInsets.only(left: 10, right: 10),
  //                   child: Container(
  //                     padding: EdgeInsets.only(top: 15, bottom: 15),
  //                     child: Center(
  //                         child: Text("Payment Response",
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                               fontStyle: FontStyle.normal,
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 15,
  //                               letterSpacing: 1,
  //                             ))),
  //                   ),
  //                 ),
  //                 new Container(
  //                   margin: EdgeInsets.all(10),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Response',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Text(
  //                         rawResponse.toString(),
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         'Transaction ID',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Text(
  //                         txnId == null ? "N/A" : txnId.toString(),
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         'Response Code',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Text(
  //                         responseCode == null
  //                             ? "N/A"
  //                             : responseCode.toString(),
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         'ApprovalRefNo',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Text(
  //                         approvalRefNo == null
  //                             ? "N/A"
  //                             : approvalRefNo.toString(),
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         'Status',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Text(
  //                         status == null ? "N/A" : status.toString(),
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         'TransactionRef',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Text(
  //                         txnRef == null ? "N/A" : txnRef.toString(),
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           color: Color(0xff333333),
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 new Container(
  //                   child: Flexible(
  //                     child: new GestureDetector(
  //                       onTap: () async {
  //                         Navigator.pop(context);
  //                         setState(() {
  //                           // ignore: unnecessary_statements
  //                           status;
  //                           // if (status == UpiTransactionStatus.success) {
  //                           //   PaymentApiFromServer();
  //                           // } else {
  //                           //   CU.showToast(context, "Payment Failed");
  //                           // }
  //                         });
  //                       },
  //                       child: Container(
  //                         color: Colors.black,
  //                         alignment: Alignment.center,
  //                         height: 50,
  //                         child: Text(
  //                           "Thanks",
  //                           style: TextStyle(
  //                             fontStyle: FontStyle.normal,
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 14,
  //                             letterSpacing: 1,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )),
  //   );
  // }

//----------------------------PaymentApiFromServer---------------------------//
//   ClientPaymentModal clientPaymentModal = ClientPaymentModal();
//   // ignore: non_constant_identifier_names
//   Future<void> PaymentApiFromServer() async {
//     // ignore: non_constant_identifier_names
//     var GetSystemDate = DateFormat('dd/MM/y').format(DateTime.now()).trim();
//     try {
//       clientPaymentModal.clientid = MainScreenState.userInfo[k_clientid];
//       var request = http.Request(
//           'GET',
//           Uri.parse(
//               'https://pkgames.online/API/APIMatka.aspx?api=21&UserId=${clientPaymentModal.clientid}&Paymentamount=${_amountController.text}&Paymentstatus=1&Datetime=$GetSystemDate'));
//       http.StreamedResponse response = await request.send();
//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());
//         await response.stream.bytesToString().then((value) {
//           setState(() {
//             // ignore: non_constant_identifier_names
//             var ReciveJsonData = json.decode(value);
//             if (ReciveJsonData["status"] == 1) {
//               CU.showToast(context, ReciveJsonData["message"]);
//               // ignore: non_constant_identifier_names
//               var GetWalletAmount = ReciveJsonData["walletamount"]
//                   .toString()
//                   .replaceAll(',', '')
//                   .split(".")
//                   .first;
//               callService(GetWalletAmount);
//             } else {
//               CU.showToast(context, "Payment Failed");
//             }
//           });
//         });
//       } else {
//         //print(response.reasonPhrase);
//         CU.showToast(context, "Payment Failed");
//       }
//     } catch (e) {
//       return;
//     }
//   }

// //----------------------------------------------------------------------------//
//   // ignore: non_constant_identifier_names
//   Future<void> callService(GetWalletAmount) async {
//     clientPaymentModal.clientid = MainScreenState.userInfo[k_clientid];
//     clientPaymentModal.amount = int.parse(GetWalletAmount.toString());
//     Map<String, dynamic> body = <String, dynamic>{
// //      CS.token: await CU.getToken(),
//       CS.clientpayment: jsonEncode(clientPaymentModal.toJson()),
//     };
//     Map<String, dynamic> resJson;
//     if (await CU.CheckInternet()) {
//       resJson = await ApiClient.Call(context,
//           body: body, apiUrl: CS.clientPaymentSave);
//     } else {
//       CU.showNoInternetDiloag(context, callService);
//       return;
//     }
//     if (resJson[CS.status].toString() == StatusCode.Success) {
//       //CU.showToast(context, resJson[CS.message], backgroundColor: Colors.green);
//     } else if (resJson[CS.status].toString() == StatusCode.Error) {}
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => MainScreen()),
//         (Route<dynamic> route) => false);
//   }
}
