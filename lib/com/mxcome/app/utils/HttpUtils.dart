import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart';
import 'package:mxcome/com/mxcome/app/model/BaseRsp.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';
import 'package:mxcome/com/mxcome/app/utils/AppUtils.dart';
import 'package:mxcome/com/mxcome/app/utils/TextUtils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HttpUtils {
  static Future<http.Response?> _postX(String url, Map<String, dynamic> reqParams) async {
    TextUtils.println("httpPost>>>$url>>>${reqParams}");
    try {
      Map<String, String> headers = {};
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      headers["X-requested-with"] = packageInfo.packageName;
      headers["accept-language"] = getHeaderLanguage();
      String token = await AppUtils.getToken();
      if (TextUtils.isNotEmpty(token)) headers['Authorization'] = token;
      return await http.post(Uri.parse(url), headers: headers, body: reqParams, encoding: Encoding.getByName('UTF-8')).timeout(const Duration(seconds: 60));
    } catch (e) {
      TextUtils.println(e.toString());

      return null;
    }
  }

  static String getHeaderLanguage() {
    switch(LanguagePage.language) {
      case 'TH':
        return 'fr_CA';
      case 'ZH':
        return 'zh_CN';
      case 'EN':
        return 'en_US';
      default:
        return 'fr_CA';
    }
  }

  static Future<http.Response?> _getX(String url, Map<String, String> reqParams) async {
    TextUtils.println("httpGet>>>$url>>>$reqParams");
    try {
      Map<String, String> headers = {};
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      headers["X-requested-with"] = packageInfo.packageName;
      headers["accept-language"] = getHeaderLanguage();
      String token = await AppUtils.getToken();
      if (TextUtils.isNotEmpty(token)) headers['Authorization'] = token;
      String urlParam = "";
      for (var element in reqParams.entries) {
        if (urlParam == "") {
          urlParam = "?${element.key}=${element.value}";
        } else {
          urlParam = "$urlParam&${element.key}=${element.value}";
        }
      }
      url = "$url$urlParam";
      TextUtils.println("httpGet>>>>$url");
      return await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 60));
    } catch (e) {
      TextUtils.println(e.toString());
      return null;
    }
  }

  static Future<BaseRsp> uploadFile(String url, Map<String, String> reqParams, List<String>? files) async {
    TextUtils.println("httpPost>>>$url>>>$reqParams");
    try {
      Map<String, String> headers = {};
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      headers["X-requested-with"] = packageInfo.packageName;
      headers["accept-language"] = getHeaderLanguage();
      String token = await AppUtils.getToken();
      if (TextUtils.isNotEmpty(token)) headers['Authorization'] = token;
      http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse(url));
      if (files != null && files.isNotEmpty) {
        for (var item in files) {
          http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', item);
          request.files.add(multipartFile);
        }
      }
      request.fields.addAll(reqParams);
      request.headers.addAll(headers);
      http.StreamedResponse? response = await request.send();
      if (response.statusCode == 200) {
        String result = await response.stream.bytesToString();
        TextUtils.println("upload rsp>>>>start| $result |end");
        return BaseRsp.parserJSON(result);
      } else {
        return BaseRsp.newErrInstance('http err>>>${response.statusCode}');
      }
    } catch (e) {
      TextUtils.println(e.toString());
      return BaseRsp.newErrInstance('upload file error');
    }
  }

  static Future<BaseRsp> get(String url, Map<String, dynamic>? params) async {
    params ??= {};
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    params['appVer'] = packageInfo.buildNumber;
    params['platform'] = Platform.isAndroid ? 'android' : 'ios';
    String installReferer = await AppUtils.getInstallReferer();
    params['installReferer'] = installReferer;
    TextUtils.println("req->$url,$params");
    Map<String, String> reqParams = {};
    for (var element in params.entries) {
      reqParams[element.key] = element.value.toString();
    }
    http.Response? response = await _getX(url, reqParams);
    // var count = 0;
    // while (response == null && count < 1) {
    //   count++;
    //   response = await _getX(url, reqParams);
    // }
    if (response == null) {
      TextUtils.println("httpGet>>>>Network error, please try again later");
      return BaseRsp.newErrInstance(null);
    }
    TextUtils.println("httpGet>>>>$url,${response.statusCode}");
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      TextUtils.println("httpGet rsp>>>>start| $body |end");
      BaseRsp rsp = BaseRsp.parserJSON(body);
      if (rsp.retCode == RspRetCode.LOGIN_TOKEN_TOUT) {
        await AppUtils.setToken("");
      }
      return rsp;
    } else {
      TextUtils.println("http err>>>${response.statusCode}");
      return BaseRsp.newErrInstance('http err>>>${response.statusCode}');
    }
  }

  static Future<BaseRsp> post(String url, Map<String, dynamic>? params) async {
    params ??= {};
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    params['appVer'] = packageInfo.buildNumber;
    params['platform'] = Platform.isAndroid ? 'android' : 'ios';
    String installReferer = await AppUtils.getInstallReferer();
    params['installReferer'] = installReferer;
    TextUtils.println("req->$url,$params");
    //Map<String, String> reqParams = {};
    //reqParams['data'] = encode(jsonEncode(params));
    http.Response? response = await _postX(url, params);
    // var count = 0;
    // while (response == null && count < 1) {
    //   count++;
    //   response = await _postX(url, params);
    // }
    if (response == null) {
      TextUtils.println("httpPost>>>>Network error, please try again later");
      return BaseRsp.newErrInstance(null);
    }
    TextUtils.println("httpPost>>>>$url,${response.statusCode}");
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      TextUtils.println("httpPost rsp>>>>start| $body |end");
      BaseRsp rsp = BaseRsp.parserJSON(body);
      if (rsp.retCode == RspRetCode.LOGIN_TOKEN_TOUT) {
        await AppUtils.setToken("");
      }
      return rsp;
    } else {
      TextUtils.println("http err>>>${response.statusCode}");
      return BaseRsp.newErrInstance('http err>>>${response.statusCode}');
    }
  }

  static final Key _key = Key.fromUtf8("9wfhjC!gWanTFz%7");

  static final IV _iv = IV.fromUtf8("vHNowBq5%vggDaYf");

  static final Encrypter _encrypter = Encrypter(
    AES(_key, mode: AESMode.ctr, padding: null),
  );

  static String encode(String str) {
    try {
      return str;
      //return _encrypter.encrypt(str, iv: _iv).base64;
    } catch (e) {
      return str;
    }
  }

  static String decode(String str) {
    try {
      return str;
      //return _encrypter.decrypt64(str, iv: _iv);
    } catch (e) {
      return str;
    }
  }

  static Future<BaseRsp> postJSON(String url, Map<String, dynamic>? params, {dynamic body}) async {
    params ??= {};
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    params['appVer'] = packageInfo.buildNumber;
    params['platform'] = Platform.isAndroid ? 'android' : 'ios';
    String installReferer = await AppUtils.getInstallReferer();
    params['installReferer'] = installReferer;
    TextUtils.println("req->$url,");
    TextUtils.println("req->$url|params->${jsonEncode(params)}|body->${jsonEncode(body)}");
    //Map<String, String> reqParams = {};
    //reqParams['data'] = encode(jsonEncode(params));
    http.Response? response = await _postXJSON(url, params, body: body);
    // var count = 0;
    // while (response == null && count < 1) {
    //   count++;
    //   response = await _postXJSON(url, params, body: body);
    // }
    if (response == null) {
      TextUtils.println("httpPost>>>>Network error, please try again later");
      return BaseRsp.newErrInstance(null);
    }
    TextUtils.println("httpPost>>>>${url},${response.statusCode}");
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      TextUtils.println("httpPost rsp>>>>start| $body |end");
      BaseRsp rsp = BaseRsp.parserJSON(body);
      if (rsp.retCode == RspRetCode.LOGIN_TOKEN_TOUT) {
        await AppUtils.setToken("");
      }
      return rsp;
    } else {
      TextUtils.println("http err>>>${response.statusCode}");

      return BaseRsp.newErrInstance('http err>>>${response.statusCode}');
    }
  }

  static Future<http.Response?> _postXJSON(String url, Map<String, dynamic> reqParams, {dynamic body}) async {
    TextUtils.println("httpPost>>>$url>>>${reqParams}");
    try {
      Map<String, String> headers = {};
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      headers["X-requested-with"] = packageInfo.packageName;
      headers["accept-language"] = getHeaderLanguage();
      //headers["language"] = LanguagePage.language;
      headers["Content-Type"] = "application/json";
      String token = await AppUtils.getToken();
      if (TextUtils.isNotEmpty(token)) headers['Authorization'] = token;
      String reqBody;
      if (body != null) {
        reqBody = jsonEncode(body);
      } else {
        reqBody = jsonEncode(reqParams);
      }
      return await http.post(Uri.parse(url), headers: headers, body: reqBody, encoding: Encoding.getByName('UTF-8')).timeout(const Duration(seconds: 60));
    } catch (e) {
      TextUtils.println(e.toString());
      return null;
    }
  }

}
