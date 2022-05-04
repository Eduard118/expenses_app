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

  TextEditingController _psswController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  FocusNode focusNodeEmail = new FocusNode();
  FocusNode focusNodePassword = new FocusNode();

  List<String> _emailOptions = [];

  bool _hidePassword = true;
  bool _isKeyBoardVisible = false;
  bool _activeRemember = false;

  Widget build(BuildContext context) {
    return Scaffold(
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
                              Text(
                                'Welcome',
                                style: TextStyle(fontSize: 22),
                              )
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
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: TypeAheadField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: _emailController,
                                        focusNode: focusNodeEmail,
                                        autofocus: false,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)
                                              )
                                          ),
                                          labelText: 'Email',
                                        ),
                                        onSubmitted: (value){
                                          FocusScope.of(context).requestFocus(focusNodePassword);
                                        },
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        List<String> retval = [];

                                        _emailOptions.forEach((element) {
                                          if(element.toLowerCase().startsWith(pattern.toLowerCase().trim())) {
                                            retval.add(element.trim());
                                          }
                                        });

                                        if ((retval.length == 1) && retval[0].toLowerCase() == pattern.toLowerCase().trim()) return [];
                                        else return retval;
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text('$suggestion'),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        if (mounted) {
                                          setState(() {
                                          _emailController.text = '$suggestion';
                                        });
                                        }
                                        focusNodePassword.requestFocus();
                                      },
                                      hideSuggestionsOnKeyboardHide: true,
                                      hideOnEmpty: true,
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Container(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.lockOpen),
                                Container(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2.5,
                                  child: TextFormField(
                                    //enableInteractiveSelection: false,
                                    controller: _psswController,
                                    focusNode: focusNodePassword,
                                    obscureText: _hidePassword,
                                    keyboardType: TextInputType.text,

                                    decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              _hidePassword = !_hidePassword;
                                            });
                                          },
                                          child: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(
                                                const Radius.circular(15.0)
                                            )
                                        ),
                                      labelText: 'Password',
                                    ),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]))))));
  }
}
