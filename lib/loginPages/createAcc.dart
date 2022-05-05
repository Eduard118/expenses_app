/* -----------------------------------------------------------------------------
 * Widget pentru inregistrarea unui utilizator nou
 */

import 'package:expensesapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensesapp/services/popUpMessages.dart';

class Register extends StatefulWidget {
  final String? usEmail;

  Register({Key? key, this.usEmail}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _waiting = false;
  bool _hidePassword = true;

  FocusNode focusNodePassword = FocusNode();

  getFocusedBorder(BuildContext context, {bool shouldAddBorderSide = true}){
    if(shouldAddBorderSide) {
      return OutlineInputBorder(
        borderRadius: const BorderRadius.all(
            Radius.circular(12.0)
        ),
        borderSide: BorderSide(color: Theme
            .of(context)
            .colorScheme.secondary, width: 2),
      );
    } else {
      return const OutlineInputBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(12.0)
        ),
      );
    }

  }


  @override
  Widget build(BuildContext context) {

    return Builder(builder: (context) => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //     child: Image.asset('assets/images/newUser.png',
                //         height: 30, width: 30, fit: BoxFit.cover)
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Column(
                    children: [
                      Text(
                        'New Account',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child:
          Column(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: TextFormField(
                  enableInteractiveSelection: true,
                  initialValue: widget.usEmail ?? '',
                  validator: (input) {
                    String? retval;
                    if (input!.isEmpty) {
                      retval = 'Completeaza adresa de email';
                    }
                    return retval;
                  },
                  onSaved: (input) => _email = input,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.mail),
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white70,
                    errorBorder: getFocusedBorder(context, shouldAddBorderSide: false),
                    focusedErrorBorder: getFocusedBorder(context),
                    focusedBorder: getFocusedBorder(context),
                    enabledBorder: getFocusedBorder(context, shouldAddBorderSide: false),
                  ),
                  onFieldSubmitted: (input) {
                    _email = input;
                    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                    focusNodePassword.requestFocus();
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: TextFormField(
                    obscureText: _hidePassword,
                    enableInteractiveSelection: true,
                    focusNode: focusNodePassword,
                    validator: (input) {
                      String? retval;
                      if (input!.isEmpty) {
                        retval = 'Introduceti parola';
                      }
                      else if (input.length < 6) {
                        retval = 'Introduceți o parolă de cel puțin 6 caractere';
                      }
                      else if (input.contains(' ')) {
                        retval = 'Password';
                      }
                      return retval;
                    },
                    onSaved: (input) => _password = input,
                    onFieldSubmitted: (input) async{
                      _password = input;
                      await register();
                    },
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                        child: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                      ),
                      hintText: 'Create a password',
                      prefixIcon: const Icon(Icons.lock),
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15.0)
                          )
                      ),
                      errorBorder: getFocusedBorder(context, shouldAddBorderSide: false),
                      focusedErrorBorder: getFocusedBorder(context),
                      focusedBorder: getFocusedBorder(context),
                      enabledBorder: getFocusedBorder(context, shouldAddBorderSide: false),
                    ),
                    //obscureText: true,
                  ),
                ),
              ),
              Container(height: 10,),
              _waiting ? const CircularProgressIndicator() :
              ElevatedButton(
                onPressed: () async {
                    await register();
                  },
                child: Text('Create new account'),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  /* ---------------------------------------------------------------------------
   * Inregistrarea propriu-zisa a utilizatorului in FB
   */

  final AuthService _auth = AuthService();

  Future<void> register() async {

    setState(() {
      _waiting = true;
    });

    final formState = _formKey.currentState!;
    if (formState.validate()) {
      formState.save();
      print('$_email si $_password');
      try {
        bool result = await _auth.registerWithEmailAndPassword(_email!, _password!);


        if(result) {
          await dispMsg("Utilizator înregistrat!\nS-a trimis un email de verificare.\n\nAccesați căsuța poștala și lansați link-ul de activare", context,
            sType: 'msg', sTitle: 'Inregistrare cu succes');
        }
      }
      on FirebaseAuthException catch (e) {
        String? errorMessage;
        if (e.code == 'email-already-in-use') {
          errorMessage = Text('Utilizator deja inregistrat').toString();
          await dispMsg(errorMessage, context);
        } else {
          if (e.code == 'weak-password') {
            errorMessage = "Parola este slaba.";
            dispMsg(errorMessage, context);
          }
          else if (e.code == 'invalid-email') {
            errorMessage = 'Adresa e-mail incorecta';
            await dispMsg(errorMessage, context);
          }
          else {
            errorMessage = "$e";
            await dispMsg(errorMessage, context);
          }
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
