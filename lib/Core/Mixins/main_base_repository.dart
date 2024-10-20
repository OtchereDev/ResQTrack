import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resq_track/Services/Local/shared_prefs_manager.dart';
import 'package:resq_track/Services/Remote/Authentication/auth_remote_service.dart';
import '../../main.dart';

mixin BaseRepository {
  AuthRemoteService auth = AuthRemoteService();
  final SharedPrefManager _sharedPrefsManager = SharedPrefManager();

  Future<http.Response> post({required String url, dynamic data}) async {
    Map<String, String> headers = await auth.setHeaders();
    String encodedData = data == null ? "{}" : jsonEncode(data);

    http.Response response =
        await http.post(Uri.parse(url), body: encodedData, headers: headers);
    if (response.statusCode == 401) {
      main();
    }

    return response;
  }

  Future<String> getCurrencySymbol() async {
    final currency = await _sharedPrefsManager.getCurrency();
    return currency;
  }
}
