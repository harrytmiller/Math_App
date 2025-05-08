import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';


class MockEmail {
  static String? lastLaunchedUrl;
  

  static Future<bool> canLaunchUrl(Uri url) async {
    return true;
  }
  

  static Future<bool> launchUrl(Uri url, {LaunchMode? mode}) async {
    lastLaunchedUrl = url.toString();
    return true;
  }
  

  static void reset() {
    lastLaunchedUrl = null;
  }
  

  static bool isValidEmailUrl(String expectedEmail) {
    if (lastLaunchedUrl == null) {
      return false;
    }
    return lastLaunchedUrl == 'mailto:$expectedEmail';
  }
  

  static Future<bool> canLaunchUrlWithResult(Uri url, bool result) async {
    return result;
  }
}