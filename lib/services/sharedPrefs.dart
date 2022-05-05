import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsHelpr {
  static SharedPreferences? prefs;

  static Future clear ({List<String>? exceptK}) async {
    if (prefs == null) {
      await _init();
    }

    List<dynamic> exval = [];
    try {
      if (exceptK != null) {
        for (String el in exceptK) {
          exval.add(prefs!.get(el));
        }
      }
    }
    catch (err) {
      print(err);
    }

    prefs!.clear();

    if (exceptK != null) {
      for (int i = 0; i < exceptK.length; i++){
        if(exval[i] != null) {
          print(exval[i].runtimeType);
          if ('String'.compareTo(exval[i].runtimeType.toString()) == 0) {
            await prefs!.setString(exceptK[i], exval[i]);
          }
          else if ('bool'.compareTo(exval[i].runtimeType.toString()) == 0) {
            await prefs!.setBool(exceptK[i], exval[i]);
          }
        }
      }
    }

  }

  static Future remove(String skey) async {
    if (prefs == null) {
      await _init();
    }

    prefs!.remove(skey);
  }

  static Future d() async {
    if (prefs == null) {
      await _init();
    }

    prefs!.remove('qSN');
  }

  static Future _init () async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool?> getBool(String key) async {
    if (prefs == null) {
      await _init();
    }

    return prefs!.getBool(key);
  }

  static Future<String?> getString(String key) async {
    if (prefs == null) {
      await _init();
    }

    return prefs!.getString(key);
  }

  static Future<bool> setBool(String key, bool lval) async {
    if (prefs == null) {
      await _init();
    }

    return await prefs!.setBool(key, lval);
  }

  static Future<bool> setString(String key, String? sval) async {
    if (prefs == null) {
      await _init();
    }

    if (sval == null) {
      return await prefs!.remove(key);
    }
    else {
      return await prefs!.setString(key, sval);
    }
  }
}
