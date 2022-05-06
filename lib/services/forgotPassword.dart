/* -----------------------------------------------------------------------------
 * Widget pentru recuperarea parolei
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensesapp/services/popUpMessages.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PasswordRecover extends StatefulWidget {
  final String? usEmail;

  PasswordRecover({this.usEmail});

  @override
  _PasswordRecoverState createState() => _PasswordRecoverState();
}

class _PasswordRecoverState extends State<PasswordRecover> {
  String? _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) =>  Scaffold(
      backgroundColor: Color(0xffEBE8FC),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Password recover',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
              color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(FontAwesomeIcons.envelope),
                  Container(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: TextFormField(
                      enableInteractiveSelection: true,
                      initialValue: widget.usEmail ?? '',
                      validator: (input) {
                        String? retval;
                        if (input!.isEmpty) {
                          retval = 'Write an email address';
                        }
                        return retval;
                      },
                      onSaved: (input) => _email = input!,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15.0)
                              )
                          ),
                          labelText: 'Recovery email'),
                    ),
                  ),
                ],
              ),
              Container(height: 10,),
              _waiting ? const CircularProgressIndicator() :
              ElevatedButton(
                onPressed: () async { return await sentResetEmail(context); },
                child: Text('Reset password'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary
                          )
                      )
                ) ,
                //style: Util.bTxtSt(context),
              ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> sentResetEmail(BuildContext context) async {

    setState(() {
      _waiting = true;
    });

    final formState = _formKey.currentState!;
    var errorMessage;
    if (formState.validate()) {
      formState.save();
      try {
          await FirebaseAuth.instance.sendPasswordResetEmail(
              email: _email!.trim());

        await dispMsg(
            'Recover link sent!',
            context,
            sTitle: 'Reset Password',
            sType: 'msg');
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);

      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'ERROR_USER_NOT_FOUND':
            errorMessage ='No user found';
            dispMsg(errorMessage, context);
            break;
          case 'ERROR_NETWORK_REQUEST_FAILED':
            errorMessage ='No internet connection';

            dispMsg(errorMessage, context);
            break;
          case 'ERROR_INVALID_EMAIL':
            errorMessage ='Invalid email';

            dispMsg(errorMessage, context);
            break;

          default:
            errorMessage = e.message;
            await dispMsg(errorMessage, context);
        }
      }
      catch (e) {
        await dispMsg('$e', context);
      }
    }

    setState(() {
      _waiting = false;
    });

  }
}
