import 'dart:convert';

import 'package:http/http.dart';
import 'package:threepay/utils/Constants.dart';

class UserAdapter {
  Future<Response> createUser(String fullName, String phone,
      String profilePicUrl, String email, String uid) {
    return post(
      Uri.parse(Constants().backendUrl + '/user/createUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'full_name': fullName,
        'phone': phone,
        'profile_pic': profilePicUrl,
        'email': email,
        'uId': uid
      }),
    );
  }

  Future<bool> toggleWaitlist(String uid) async {
    try {
      Response r = await put(
          Uri.parse(Constants().backendUrl + '/user/toggleWaitList/' + uid),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      return r.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<bool> getIsWaitlist(String uid) async {
    try {
      Response r = await get(
          Uri.parse(Constants().backendUrl + '/user/getWaitList/' + uid),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      return r.statusCode == 200 && jsonDecode(r.body)['waitlistJoined'];
    } catch (error) {
      return false;
    }
  }
}
