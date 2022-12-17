class LoginModal {
  // ignore: non_constant_identifier_names
  int clientid;
  // ignore: non_constant_identifier_names
  int organizationid = 1;
  // ignore: non_constant_identifier_names
  String clientname = "";

  // ignore: non_constant_identifier_names
  String email = "";

  // ignore: non_constant_identifier_names
  String mobileno = "";

  // ignore: non_constant_identifier_names
  String otp;

  // ignore: non_constant_identifier_names
  double Walletamount;

  // ignore: non_constant_identifier_names
  LoginModal(
      {this.clientid,
      this.organizationid,
      this.clientname,
      this.email,
      this.mobileno,
      this.otp,
      // ignore: non_constant_identifier_names
      this.Walletamount});

  LoginModal.fromJson(Map<String, dynamic> json) {
    clientid = json['clientid'];
    organizationid = json['organizationid'];
    clientname = json['clientname'];
    email = json['email'];
    mobileno = json['mobileno'];
    otp = json['otp'];
    Walletamount =
        double.parse(json['Walletamount'].toString().replaceAll(",", ""));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientid'] = this.clientid;
    data['organizationid'] = this.organizationid;
    data['clientname'] = this.clientname;
    data['email'] = this.email;
    data['mobileno'] = this.mobileno;
    data['otp'] = this.otp;
    data['Walletamount'] = this.Walletamount;
    return data;
  }
}
