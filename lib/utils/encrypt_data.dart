import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart';

class EncryptData{

  static String encryption(String msg, String type){

    if(type == "encryption"){
      final cipher = msg;
      final k = Key.fromUtf8('1234567891011123');
      final iv = IV.fromLength(16);

      final encrypter = Encrypter(AES(k));

      final encrypted = encrypter.encrypt(cipher, iv: iv);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      String encrypted_m = encrypted.base64;
      print("encrypted_m:: "+encrypted.base64);
      //print(decrypted);
      return encrypted_m;
    }
    else if(type == "decryption"){
      final cipher = msg;
      final k = Key.fromUtf8('1234567891011123');
      final iv = IV.fromLength(16);

      final encrypter = Encrypter(AES(k));

      final decrypted = encrypter.decrypt(Encrypted.fromBase64(cipher), iv: iv);

      print("decrypted:: "+decrypted);
      return decrypted;
    }
    else {
      return "ERROR -------------------------> MISSPELLING ERROR .... type encryption or decryption ";
    }


  }


}