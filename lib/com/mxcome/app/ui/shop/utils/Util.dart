import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/Logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../PageConstant.dart';
import '../../../model/BaseModel.dart';
import '../../../utils/AppUtils.dart';
import 'FormatUtil.dart';

class Util {

  static bool isTimeout(String endTime) {
    var time = DateTime.parse(endTime);
    return isTimeoutDate(time);
  }

  static bool isTimeout2({String startTime = '', String endTime = ''}) {
    if(startTime == '') {
      return false;
    }
    var serviceTime = DateTime.parse(startTime);
    var time = DateTime.parse(endTime);
    // 如果剩余时间已经不足一分钟，则不必计时，直接标记超时
    if (time.millisecondsSinceEpoch - serviceTime.millisecondsSinceEpoch <
        1000) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTimeoutDate(DateTime time) {
    DateTime nowTime;
    if(IConstant.IS_DEBUG) {
      nowTime = DateTime.now();
    }else {
      nowTime = FormatUtil.getTHNowTime();
    }
    // 如果剩余时间已经不足一分钟，则不必计时，直接标记超时
    if (time.millisecondsSinceEpoch - nowTime.millisecondsSinceEpoch <
        1000) {
      return true;
    } else {
      return false;
    }
  }

  static final Key aseKey = Key.fromUtf8("9wfhjC!gWanTFz%7#aekgh1934kdk#%G");

  static final IV aseIv = IV.fromUtf8("vHNowBq5%vggDaYf");

  static final Encrypter encrypter = Encrypter(
    AES(aseKey, mode: AESMode.cbc, padding: "PKCS7"),
  );

  static String encode(String str) {
    return encrypter.encrypt(str, iv: aseIv).base64;
  }

  static String decode(String str) {
    return encrypter.decrypt64(str, iv: aseIv);
  }

  static String generateMD5(String data) {
    Uint8List content = const Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    return digest.toString();
  }

  static Future<String> encode3aes(String source) async {
    return encode(source);
  }

  static Future<String> decode3aes(String dest) async {
    return decode(dest);
  }

  static Future<String> encode3aesMd5(String source) async {
    DateTime calendar = DateTime.now();
    double hours = calendar.millisecond / 3600000;
    String destSrc = "";
    String destHour = "";
    try{
      destSrc = encode(source);
      destHour = encode("$hours");
    } catch(e) {
      Logger.log("ase error: $e");
    }
    String md5 = generateMD5("${calendar.millisecond}");
    md5 = "${md5.substring(0, 4)}${destSrc}1time1$destHour${md5.substring(28, 32)}";
    return md5;
  }

  static Future<String> decode3aesMd5(String dest) async {
    String encrypt = dest.substring(4, dest.length - 5);
    encrypt = encrypt.split("1time1")[0];
    return decode(encrypt);
  }

  static Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getShareData(dynamic item) async {
    String pocketCode = BaseModel.getString(item, "pocketCode");
    return FormatUtil.getShareContent(PageConstant.WEB_BASE_URI, pocketCode);
  }

  static String getShareKolURL(String nickname) {
    return FormatUtil.getShareContent("${PageConstant.WEB_BASE_URI}kol/", nickname);
  }

}