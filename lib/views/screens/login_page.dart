import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/config.dart';
import 'package:notes/models/login_request_model.dart';
import 'package:notes/services/api_service.dart';
import 'package:notes/utils/form_helper.dart';
import 'package:notes/views/widgets/logo_space.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF202020),
        body: ProgressHUD(
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
          color: Colors.black,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: _loginUI(context),
          ),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LogoSpace(),
          const Padding(
            padding: EdgeInsets.only(
              left: 25,
              bottom: 30,
              top: 50
            ),
            child: Text("Login", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color.fromARGB(255, 230, 185, 4),
            )),
          ),
          FormHelper.inputFieldWidget(
            context,
            "username",
            "Username",
            (onValidateVal) {
              if (onValidateVal!.isEmpty) {
                return "Username is required";
              }
              return null;
            },
            (onSavedVal) {
              username = onSavedVal;
            },
            prefixIcon: const Icon(Icons.person),
            borderFocusColor: const Color.fromARGB(255, 230, 185, 4),
            borderColor: Colors.white.withOpacity(0.5),
            prefixIconColor: const Color.fromARGB(255, 230, 185, 4),
            showPrefixIcon: true,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.5),
            borderRadius: 20
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: FormHelper.inputFieldWidget(
              context,
              "password",
              "Password",
              (onValidateVal) {
                if (onValidateVal!.isEmpty) {
                  return "Password is required";
                }
                return null;
              },
              (onSavedVal) {
                password = onSavedVal;
              },
              prefixIcon: const Icon(Icons.key_rounded),
              borderFocusColor: const Color.fromARGB(255, 230, 185, 4),
              borderColor: Colors.white.withOpacity(0.5),
              prefixIconColor: const Color.fromARGB(255, 230, 185, 4),
              showPrefixIcon: true,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.5),
              obscureText: hidePassword,
              borderRadius: 20,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(0.5),
                ))
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 25),
              child: RichText(
                text: TextSpan(
                  style:  const TextStyle(
                    color: Color.fromARGB(255, 230, 185, 4),
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Forgot Password',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 230, 185, 4),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        FormHelper.showSimpleAlertDialog(
                        context,
                        "Coming soon!",
                        "This feature is not available yet.",
                        "OK",
                        () {
                          Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false
                          );
                        }
                      );
                      }
                    )
                  ],
                )
              ),
            ),
          ),
          const SizedBox( height:  20),
          Center(
            child: FormHelper.submitButton(
              "Login",
              () {
                if(validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });

                  LoginRequestModel model = LoginRequestModel(
                    username: username!,
                    password: password!
                  );

                  APIService.login(model).then((response)  {
                    setState(() {
                      isAPIcallProcess = false;
                    });

                    if(response) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "Login Failed",
                        "Invalid sername/password!",
                        "OK",
                        () {
                          Navigator.pop(context);
                        }
                      );
                    }
                  });
                }
              }, 
              btnColor: Colors.white.withOpacity(0),
              borderColor: const Color.fromARGB(255, 230, 185, 4),
              borderRadius: 20,
              txtColor: const Color.fromARGB(255, 230, 185, 4)
              ),
          ),
          const SizedBox( height:  20),
          Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color.fromARGB(255, 230, 185, 4),
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  TextSpan(
                    text: 'Sign Up',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 230, 185, 4),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.pushNamed(context, '/register');
                    }
                  )
                ],
              )
            ),
          ),
        ],
      )
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if(form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}