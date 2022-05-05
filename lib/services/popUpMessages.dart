/* --------------------------------------------------------------------------------
 * afisare mesaje
 */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expensesapp/loginPages/createAcc.dart';


Future dispMsg(String? errMsg, BuildContext context, {String sType = 'err', String? sTitle}) async {

  Color? color;
  Widget wtitle;
  Widget  icon;
  String sErrMsg = errMsg ?? "";

  if (sTitle != null) {
    wtitle = Expanded(child: Text(sTitle));
  }
  else {
    wtitle = Text('error');
  }

  if (sType.compareTo('err') == 0) {
    color = Colors.red;
    icon = Icon(FontAwesomeIcons.bomb, color: color, size: 50,);
  }
  else {
    color = Theme.of(context).textTheme.headline1!.color;
    icon = Icon(FontAwesomeIcons.comment, color: color, size: 50,);
  }

  await showDialog(
      context: context,
      builder: (BuildContext context) =>  AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Row(children: [icon, Container(width: 30,),wtitle],),
        content: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text('$sErrMsg', style: TextStyle(color: Theme.of(context).textTheme.headline1!.color)),
        ),
        actions: [
          TextButton(
            child: Text('OK',
              style: TextStyle(color: Theme.of(context).textTheme.headline1!.color, fontSize: 20.0),
            ),
            //style: Util.bTxtSt(context),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )],
      )
  );
}
