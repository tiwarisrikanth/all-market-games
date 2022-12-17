import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matka/modal/ClientPaymentModal.dart';
import 'package:matka/navigation/screens/MainScreen.dart';
import 'package:matka/navigation/widget/EditingController.dart';
import 'package:matka/util/ApiClient.dart';
import 'package:matka/util/CS.dart';
import 'package:matka/util/CU.dart';
import 'package:matka/util/Enum.dart';
import 'package:upi_india/upi_india.dart';

import '../../PaymentScreen.dart';

//----------------------------------------------------------------------------//
class AddBalanceScreen extends StatefulWidget {
  @override
  _AddBalanceScreenState createState() => _AddBalanceScreenState();
}

//----------------------------------------------------------------------------//
class _AddBalanceScreenState extends State<AddBalanceScreen> {
  ClientPaymentModal clientPaymentModal = ClientPaymentModal();
  EditingController amountController = EditingController();
  EditingController paymentTypeController = EditingController();
  EditingController idController = EditingController();
  EditingController mobileController = EditingController();
  List<String> items = ["Select Payment Type", "Cheque", "Banking", "UPI"];
  var selected;
  List<UpiApp> apps;

  @override
  void initState() {
    super.initState();
  }

  // ignore: non_constant_identifier_names
  var UserSelectedRechargeIndex;

  // ignore: non_constant_identifier_names
  var widthHolder;
//----------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    var Width = MediaQuery.of(context).size.width;
    widthHolder = Width.roundToDouble();
    return Scaffold(
        appBar: CU.getAppbar(context, "Add Balance"),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                new Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        'Please Select Add Amount',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Add Amount minimum 500',
                          prefixIcon: Icon(Icons.currency_rupee),
                        ),
                        onTap: () {
                          setState(() {
                            UserSelectedRechargeIndex = null;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            UserSelectedRechargeIndex = null;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      new GridView.builder(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: widthHolder * 0.45,
                          childAspectRatio: 4 / 1,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                        ),
                        itemCount: PaymentList == null ? 0 : PaymentList.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                _onSelectedRecharge(i);
                                amountController.text =
                                    PaymentList[i]["Amount"];
                              });
                            },
                            child: Container(
                              child: Card(
                                color: UserSelectedRechargeIndex != null &&
                                        UserSelectedRechargeIndex == i
                                    ? Colors.blue
                                    : Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: new BorderSide(
                                        color: UserSelectedRechargeIndex !=
                                                    null &&
                                                UserSelectedRechargeIndex == i
                                            ? Colors.blue
                                            : Colors.black,
                                        width: 1.5)),
                                child: new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Center(
                                    child: Text(
                                      PaymentList[i]["AddWallet"],
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        color: UserSelectedRechargeIndex !=
                                                    null &&
                                                UserSelectedRechargeIndex == i
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                new Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 6),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    // ignore: deprecated_member_use
                    child: TextButton(
                      // textColor: Colors.white,
                      // color: Colors.blue,
                      child: Text('Add Balance'),
                      onPressed: () {
                        if (amountController.text.toString() == '') {
                          CU.showToast(context, "Please Add & Select Amount");
                        } else {
                          if (int.parse(amountController.text.toString()) >=
                              500) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WalletHomePage(
                                            amt: amountController.text
                                                .toString()
                                                .trim(),
                                            TID: amountController.text
                                                .toString()
                                                .trim(),
                                            Mobile: mobileController.text
                                                .toString()
                                                .trim())));
                          } else {
                            CU.showToast(
                                context, "Please add Amount minimum 500Rs.");
                          }
                        }
                      },
                    )),
              ],
            )));
  }

//-------------------------------_onSelectedRecharge--------------------------//
  _onSelectedRecharge(int index) async {
    setState(() => UserSelectedRechargeIndex = index);
  }

//----------------------------------------------------------------------------//
  @override
  void dispose() {
    super.dispose();
    // dispose text field controllers after use.
    amountController.clear();
    amountController.dispose();
    paymentTypeController.clear();
    mobileController.clear();
  }

//----------------------------------------------------------------------------//
  Future<void> callService() async {
    clientPaymentModal.clientid = MainScreenState.userInfo[k_clientid];
    clientPaymentModal.amount = int.parse(amountController.text);
    clientPaymentModal.transactionnumber = idController.text;
    clientPaymentModal.transactionmobileno = mobileController.text;
    clientPaymentModal.bankaccountid =
        paymentTypeController.text == "Google Pay"
            ? 1
            : paymentTypeController.text == "Paytm"
                ? 2
                : 3;
    Map<String, dynamic> body = <String, dynamic>{
//      CS.token: await CU.getToken(),
      CS.clientpayment: jsonEncode(clientPaymentModal.toJson()),
    };
    Map<String, dynamic> resJson;
    if (await CU.CheckInternet()) {
      resJson = await ApiClient.Call(context,
          body: body, apiUrl: CS.clientPaymentSave);
    } else {
      CU.showNoInternetDiloag(context, callService);
      return;
    }
    if (resJson[CS.status].toString() == StatusCode.Success) {
      CU.showToast(context, resJson[CS.message], backgroundColor: Colors.green);
      Navigator.of(context).pop(true);
    } else if (resJson[CS.status].toString() == StatusCode.Error) {
      CU.showToast(context, resJson[CS.message]);
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: CU.showDiloag(context, resJson[CS.message]));
    }
  }

//----------------------------------------------------------------------------//
  // ignore: non_constant_identifier_names
  bool IsValidate() {
    bool isValid = true;

    amountController.error.text = null;
    paymentTypeController.error.text = null;
    idController.error.text = null;
    mobileController.error.text = null;

    if (amountController.text.isEmpty) {
      amountController.error.text = "Please Enter Amount.";
      isValid = false;
    }
    if (selected == null) {
      paymentTypeController.error.text = "Select Payment Type.";
      isValid = false;
    }
    if (idController.text.isEmpty) {
      idController.error.text = "Please Enter Transaction Id.";
      isValid = false;
    }
    if (mobileController.text.isEmpty) {
      mobileController.error.text = "Please Enter Transaction Mobile No.";
      isValid = false;
    }
    setState(() {});

    return isValid;
  }
}

//----------------------------------------------------------------------------//
class ModalFit extends StatelessWidget {
  final ScrollController scrollController;
  final EditingController paymentTypeController;

  const ModalFit({Key key, this.scrollController, this.paymentTypeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Google Pay'),
            onTap: () => callonTap(context, 'Google Pay'),
          ),
          ListTile(
            title: Text('Paytm'),
            onTap: () => callonTap(context, 'Paytm'),
          ),
          ListTile(
            title: Text('Phone pay'),
            onTap: () => callonTap(context, 'Phone pay'),
          )
        ],
      ),
    ));
  }

  // ignore: non_constant_identifier_names
  callonTap(context, Text) {
    Navigator.of(context).pop();
    paymentTypeController.text = Text;
  }
}

//----------------------------------------------------------------------------//
// ignore: non_constant_identifier_names
List PaymentList = [
  {"id": 1, "Amount": "500", "AddWallet": "500"},
  {"id": 2, "Amount": "1000", "AddWallet": "1000"},
  {"id": 3, "Amount": "2000", "AddWallet": "2000"},
  {"id": 4, "Amount": "5000", "AddWallet": "5000"},
  /* {
    "id": 5,
    "Amount": "10000",
    "AddWallet":"10000"
  },
  {
    "id": 6,
    "Amount": "50000",
    "AddWallet":"50000"
  },
  {
    "id": 7,
    "Amount": "100000",
    "AddWallet":"100000"
  },*/
];
