import 'package:shared_preferences/shared_preferences.dart';
class HelperFunctions{
  static String sharedPreferenceUserLoggedInKey='ISLOGGEDIN';
  static String sharedPreferenceUserNamedKey='USERNAMEKEY';
  static String sharedPreferenceUserEmailKey='USEREMAILKEY';

  //saving data to sharedpreference;
  static Future<bool> saveUserLoggedInSharedPrefernce(bool isUserLoggedin) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedin);
  }
  static Future<bool> saveUserNameInSharedPrefernce(String userName) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNamedKey, userName);
  }
  static Future<bool> saveUserEmailSharedPrefernce(String userEmail) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInSharedPrefernce() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceUserLoggedInKey);
  }
  static Future<String?> getUserNameSharedPrefernce() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserNamedKey);
  }
  static Future<String?> getUserEmailSharedPrefernce() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserEmailKey);
  }


}