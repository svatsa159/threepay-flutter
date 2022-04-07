import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:threepay/utils/Constants.dart';

class TokenTax {
  String token;
  num totalProfit;
  num totalTax;

  TokenTax(
      {required this.token, required this.totalProfit, required this.totalTax});

  factory TokenTax.fromJson(Map<String, dynamic> json) {
    // print(json);
    return TokenTax(
        token: json['token'],
        totalProfit: (json['total_profit']),
        totalTax: json['total_tax']);
  }
}

class UploadTaxResponse {
  bool success;
  String pdfUrl;
  List<TokenTax> capitalGains;

  UploadTaxResponse(
      {required this.success,
      required this.pdfUrl,
      required this.capitalGains});

  factory UploadTaxResponse.fromJson(Map<String, dynamic> json) {
    List<TokenTax> getListOfTokenTaxes(List<dynamic> gains) {
      List<TokenTax> list = [];
      // print(gains.length);
      for (var element in gains) {
        list.add(TokenTax.fromJson(element));
      }
      return list;
    }

    print(json['PNLArray']);
    return UploadTaxResponse(
        success: json['success'],
        pdfUrl: json['pdfUrl'],
        capitalGains: getListOfTokenTaxes(json['data']));
  }
}

class ThreeTaxAdapter {
  Future<UploadTaxResponse> uploadTax(File file, String uid) async {
    Dio dio = Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    FormData formData = FormData.fromMap({
      'tax_file': MultipartFile.fromBytes(await file.readAsBytes(),
          filename: basename(file.path))
    });

    try {
      var response = (await dio.post(
          Constants().backendUrl + '/user/calculateTax/' + uid,
          data: formData));
      print("statuscode" + response.statusCode.toString());
      return UploadTaxResponse.fromJson(response.data);
    } on Exception catch (e) {
      print(e);
      return UploadTaxResponse(success: false, pdfUrl: "", capitalGains: []);
    }
  }
}
