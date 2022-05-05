// /* ---------------------------------------------------------------------------------------
//  autentificare user
//  */
//
// import 'package:flutter/material.dart';
// import 'package:expensesapp/services/sharedPrefs.dart';
//
// class AutentificateCU {
//   static String? message;
//   static BuildContext? context;
//
//   AutentificateCU();
// /* ----------------------------------------------------------------------------------------------
//    * authUser()
//    * autentificare utilizator
//    */
//   static Future<bool> authUser({required String usEmail, required String? usPssw}) async {
//     bool retval = false;
//
//     Wss wss = new Wss(context);
//     if (await wss.autentificateS()) {
//       retval = true;
//       while (!await wss.readModules(usEmail, usPssw)) {
//         if (wss.errcode!.compareTo('101') == 0) {
//           if (!await wss.creareUtilizator(usEmail, usPssw)) {
//             message = wss.message;
//             retval = false;
//             break;
//           }
//         }
//         else if (wss.errcode!.compareTo('105') == 0) {
//           if (!await wss.changePassword(usEmail, usPssw)) {
//             message = wss.message;
//             retval = false;
//             break;
//           }
//         }
//         else {
//           message = wss.message;
//           retval = false;
//           break;
//         }
//       }
//     }
//     else {
//       message = wss.message;
//     }
//     return retval;
//   }
// }
//
