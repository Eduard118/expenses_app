import 'package:expensesapp/loginPages/createAcc.dart';
import 'package:expensesapp/screens/myHomePage.dart';
import 'package:expensesapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  late User firebaseUser;

  //firebaseUser = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pssw!)).user;

  String _smode = 'p';

  TextEditingController _psswController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  FocusNode focusNodeEmail = new FocusNode();
  FocusNode focusNodePassword = new FocusNode();

  List<String> _emailOptions = [];

  bool _hidePassword = true;
  bool _isKeyBoardVisible = false;
  bool _activeRemember = false;

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // inregistrare utilizator
  Future _inregistrareUtilizator(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register(usEmail: _emailController.text,)));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffEBE8FC),
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Image.asset('assets/images/wallet.png',
                          height: 50, width: 50, fit: BoxFit.cover)
                  ),
                  Column(
                    children: [
                      Text('Hi there!'),
                      Text(
                        'Please Login',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Builder(
            builder: (context) => WillPopScope(
                onWillPop: () => Future.value(false),
                child: SafeArea(
                    top: false,
                    bottom: false,
                    child: Padding(
                        padding: EdgeInsets.only(top: 1, left: 3),
                        child: ListView(children: [
                          Container(
                            height: 50,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 15,
                              ),
                              Container(
                                width: 15,
                              ),
                            ],
                          ),
                          Container(
                            height: 10,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(FontAwesomeIcons.userCheck),
                                  Container(width: 10),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: TypeAheadField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: _emailController,
                                        focusNode: focusNodeEmail,
                                        autofocus: false,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          labelText: 'Email',
                                        ),
                                        onSubmitted: (value) {
                                          FocusScope.of(context)
                                              .requestFocus(focusNodePassword);
                                        },
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        List<String> retval = [];

                                        _emailOptions.forEach((element) {
                                          if (element.toLowerCase().startsWith(
                                              pattern.toLowerCase().trim())) {
                                            retval.add(element.trim());
                                          }
                                        });

                                        if ((retval.length == 1) &&
                                            retval[0].toLowerCase() ==
                                                pattern.toLowerCase().trim())
                                          return [];
                                        else
                                          return retval;
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text('$suggestion'),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        if (mounted) {
                                          setState(() {
                                            _emailController.text =
                                                '$suggestion';
                                          });
                                        }
                                        focusNodePassword.requestFocus();
                                      },
                                      hideSuggestionsOnKeyboardHide: true,
                                      hideOnEmpty: true,
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.lockOpen),
                                Container(width: 10),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFormField(
                                    //enableInteractiveSelection: false,
                                    controller: _psswController,
                                    focusNode: focusNodePassword,
                                    obscureText: _hidePassword,
                                    keyboardType: TextInputType.text,

                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _hidePassword = !_hidePassword;
                                          });
                                        },
                                        child: Icon(_hidePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      labelText: 'Password',
                                    ),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Center(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: SizedBox(
                              width: 170,
                              child: TextButton.icon(
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text('Login'),
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    onSurface: Theme.of(context).disabledColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  onPressed: () async {
                                    await connect();
                                  }),
                            ),
                          )
                          ),
                          Container(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                              width: 170,
                              child: TextButton.icon(
                                icon: Icon(Icons.person_add),
                                label: Text('New Account'),
                                onPressed: () async {
                                  return await _inregistrareUtilizator(context);
                                  },
                              ),
                                //style: Util.bTxtSt(context),
                              ),
                            ),
                        ]
                        )
                    )
                )
            )
        )
    );
  }
  Future <void> connect()async{
    WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();

    String email = _emailController.text;
    String password = _psswController.text;
    if(!RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
        .hasMatch(email)|| password.length < 6){

      if(!RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)").hasMatch(email)){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("si_snack_invalidEmail"),
              backgroundColor: Colors.red,
            ));
        focusNodeEmail.requestFocus();
        _emailController.value = _emailController.value.copyWith(selection: TextSelection(baseOffset: 0, extentOffset: _emailController.text.length));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("si_snack_invalidPass"),
              backgroundColor: Colors.red,
            ));
        focusNodePassword.requestFocus();
        _psswController.value = _psswController.value.copyWith(selection: TextSelection(baseOffset: 0, extentOffset: _psswController.text.length));
      }

      return;
    }
    else{
      await skipLogin();
    }


  /*  if(formKey.currentState.validate()) {
      loading = true;
      await skipLogin();
    }
    else {
      focusNodePassword.requestFocus();
      _psswController.value = _psswController.value.copyWith(selection: TextSelection(baseOffset: 0, extentOffset: _psswController.text.length));
    }*/
  }
  final AuthService _auth = AuthService();


  Future<void> skipLogin()async{
    WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
    String email = _emailController.text;
    String password = _psswController.text;

    String text;
    if(mounted){
      setState(() {
        email = email.replaceAll(new RegExp(r"\s*"), '').toLowerCase();
      });
    }
    else {
      email = email.replaceAll(new RegExp(r"\s*"), '').toLowerCase();
    }

    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
    if(result!= null){
      if(result != false){

        await Navigator.push(context, MaterialPageRoute(builder: (context)=>
            MyHomePage()));
      }
    }

    else{


    }
  }
}



//   bool? isEmpty (dynamic xval) {
//     bool? retval;
//     if (xval == null) {
//       retval = true;
//     }
//     else {
//       //String stype = xval.runtimeType.toString().toLowerCase();
//
//       if (xval is String) {
//         retval = (xval.trim() == '');
//       }
//       else if (xval is int) {
//         retval = (xval == 0);
//       }
//       else if (xval is double) {
//         retval = (xval == 0);
//       }
//       else if (xval  is bool) {
//         retval = (!xval);
//       }
//       else if (xval is List) {
//         retval = (xval.isEmpty);
//       }
//       else if (xval is HashMap) {
//         retval = (xval.isEmpty);
//       }
//     }
//
//     return retval;
//   }
//
//   // Login FB + aplicatie
//   Future<void> _loginFB() async {
//
//     FocusScope.of(context).unfocus();
//     User? firebaseUser;
//
//     try {
//       _emailController.text = _emailController.text.trim();
//       String email;
//         if (isEmpty(_emailController.text)!) {
//           throw CustomException("Completeaza emailul");
//         }
//         email = _emailController.text;
//
//
//       _psswController.text = _psswController.text.trim();
//       String? pssw;
//         if (_psswController.text.isEmpty) {
//           throw new CustomException("Completeaza parola");
//         }
//         pssw = _psswController.text;
//       setState((){
//         _smode = '*';
//       });
//
//       firebaseUser = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pssw!)).user;
//
//       if (firebaseUser!.emailVerified) {
//
//         AutentificateCU.context = context;
//         if (await AutentificateCU.authUser(usEmail: email, usPssw: pssw)) {
//           if (!lDemo && !biometricCall && !autologin) {
//             // scrie parametrii cititi in fisierul de stare
//             Globals.qSN = scompany;
//             await SettingsHelpr.setString('qSN', Globals.qSN);
//             Globals.usEmail = _emailController.text;
//             await SettingsHelpr.setString('usEmail', Globals.usEmail);
//             Globals.usPssw = _psswController.text;
//             await SettingsHelpr.setString('usPssw', Pr.encode(_psswController.text));
//
//             if (_companyOptions.indexOf(Globals.qSN!) < 0) {
//               _companyOptions.add(Globals.qSN!);
//               await SettingsHelpr.setString('companyOptions', '$_companyOptions');
//             }
//
//             if (_emailOptions.indexOf(Globals.usEmail!) < 0) {
//               _emailOptions.add(Globals.usEmail!);
//               await SettingsHelpr.setString('emailOptions', '$_emailOptions');
//             }
//           }
//
//           // lanseaza modulul de start
//           await Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       Hello(message: Util.mesaje(context, 'S1Ana Assist'))
//               )
//           );
//
//         }
//         else {
//           throw new CustomException(AutentificateCU.message);
//         }
//       }
//       else {
//         throw new CustomException('${Util.mesaje(context, 'accountNotActivated')}\n\n${Util.mesaje(context, 'acctivateAccount')}');
//       }
//     }
//     catch (e, stacktrace) {
//       setState(() {
//         _smode = 'l';
//       });
//       if (e is CustomException) {
//         dispMsg(e.message, context);
//       } else if (e is PlatformException) {
//         if (e.code == 'ERROR_WRONG_PASSWORD') {
//           dispMsg(Util.mesaje(context, 'invalidPassw'), context);
//         } else if (e.code == 'ERROR_NETWORK_REQUEST_FAILED') {
//           dispMsg(Util.mesaje(context, 'noInternetConnection'), context);
//         } else {
//           dispMsg(Util.mesaje(context, 'invalidCredentials'), context);
//         }
//       } else if (e is FirebaseAuthException) {
//         if (e.code.compareTo('user-not-found') == 0) {
//           dispMsg(Util.mesaje(context, 'noUserFound'), context);
//         }
//         else if (e.code.compareTo('wrong-password') == 0) {
//           dispMsg(Util.mesaje(context, 'wrongPassword'), context);
//         }
//         else {
//           dispMsg(e.message, context);
//         }
//       }
//     }
//   }
// }
// class CustomException implements Exception {
//   final String? errorcode;
//   final String? message;
//   CustomException(this.message, {this.errorcode});
// }
