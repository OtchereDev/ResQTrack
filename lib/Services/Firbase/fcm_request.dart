import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<void> sendFCMNotification(BuildContext context, String receiverToken,
    Map<String, dynamic> callModel) async {
  // Load the service account JSON key file (replace with your JSON credentials)
  final accountCredentials = auth.ServiceAccountCredentials.fromJson({
  "type": "service_account",
  "project_id": "sosbackend-eeb26",
  "private_key_id": "0b25b6a9bcc971dcc167e526d708af5b62385691",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC18PvgFBsqYbbP\nAzwYWXAvQ/is7tAtUR2mbNwoftd1HXW/q7PEpRjdLeA7xfd6EEYFSosCyoBBp710\n2yfBbhWQ0+XRcjKoVJWh3e2MmYV8maxq+1Ut6vH/UK3wcfQoXeI0hbUWkDNHSNHj\nsgU0VamnYxtycZSVph1JzbD4gvJmLNj+kFtheiwLrDB6vv84lCnDSHAlCWCz4qv2\nGQX7JcRKo9TUyRffWagyK0rkd/k6sDBEpsiUVDMIBi89a0xnr/KY3TMhLRfY3cHR\nWDOSf8DvZnTm5BthMR+Qz60zViZYi+3f5NYjUxCyRK+pJscpKJYSKgQgdMC4X6Lx\nt/JrCQUVAgMBAAECggEAAIGp5om9tEV9TVOwGRYU1A4S/A29OvM9b3eTDMMogSeP\nBpYmYTeJW3SIguSFyq+JiuL9P9d3zXAINHT00Tw+GYo2sUHvGKAFe4gEjkoMeFAJ\nVmsJVOtF95AAXCKepHDHQDoHR/P77I+baYqywNvQ7jC4sPWC9yzF39FMyPbutMxj\nwjCxa8utAMpkEQe22LGDlqGBbqILErxPbxkcH+CiacRflk1K0psxfxXb7LwzEXJR\n/taskrp+TiO76aQF/kqT9bpgXcUBOcA19zqFsS2uONTqIrgjKTP2n+ImgUCHlYD5\nHva1mcpAPJFcVfk7ZdNnAEnRMA6abFpsgnlHlCq2CQKBgQDxrririvFVzWEHF2P1\n10eMpqBWYpKeu3ET90B2EzABxF6nVJXWmz1LYwp70CdgEn2LHJcd8mjlsUYWw5zg\nvnR+wPey7KRIdNcVbAMl/x6MJ0a8OReT4Sunb/pzDLPUj7ZB1sTjH8SUG3V3d2qy\nOmSDw6oMlUSVEa176kBG54wLTQKBgQDAuD9VeOfVHbo6E9ncKpLZVf5CttyAm1+e\nOYi2TBMvNYmSniAjMeC00SFvbPdsR6K4RdLIlhT7xOd2ljvUzpsMbzWrMXd5yk1C\nb4mJ5o7nGlJu9mkecQmZtsiC7oFM/owbELLuXOk2VbNeKNrAINfd+D9Fs8bLJ1hY\nMRxMrWes6QKBgG1VbZWtNaBrWQmsOzxsN6IZf0+VKF9GzNELec3wwDcMbwWj7mU3\ntXL1SzjX4fhEZScZuAOENpAyslJ6C+5gOrNc+LGo/GkK8oJuar41u8wLuKRN76ym\noOkOb268wF3Y5crDLi7RoEygX3O8Qjh+0hoJ2lP28x+8746vWoS5G1HBAoGAV4lY\n+zHX2+2M0SSDKIYN/boZq6PztFber7fiaStU63Sd8ILyhgn5zyfO0BXmrMA9IQZW\nH9ZL4bAmkq7armbJ9nPtJL1rT16ciTiweHrJHh/Ooag7RyCBA9kKaq56/MYCTajg\nHXUGWS/EMVjNQ8enRaOk2bw258APWL+14v5AwUECgYEAkjRp8ObHOl67ixjFoyMe\ns/wJeNZyNQLovg8wVi/fRgveLSLipFTau0MPEvT6eM7mjN7SzC6VcqN1Sm5TWV/M\n+NAkUoGrMQcHgtRkzeQ9hpTua1h45FWByAJ2iVKuIjI0LatsIsXTPzuTiETusPAt\nf6EKwgwj3FGY3GdFiPugHRs=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-3yr3e@sosbackend-eeb26.iam.gserviceaccount.com",
  "client_id": "115260746178068214141",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-3yr3e%40sosbackend-eeb26.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  });

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  final authClient =
      await auth.clientViaServiceAccount(accountCredentials, scopes);

  const fcmUrl =
      'https://fcm.googleapis.com/v1/projects/sosbackend-eeb26/messages:send';

  final bodyMap = {
    'type': 'call',
    'title': 'New call',
    'body': jsonEncode(callModel),
  };

  final messagePayload = {
    'message': {
      'token': receiverToken,
      'data': bodyMap,
    }
  };

  try {
    final response = await authClient.post(
      Uri.parse(fcmUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(messagePayload),
    );

    if (response.statusCode == 200) {
      debugPrint('Send Notify Success: ${response.body}');
    } else {
      debugPrint(
          'Failed to send notification: ${response.statusCode} ${response.body}');
    }
  } catch (e) {
    debugPrint('Error sending FCM notification: $e');
  } finally {
    authClient.close();
  }
}
