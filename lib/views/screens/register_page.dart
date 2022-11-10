import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/config.dart';
import 'package:notes/models/register_request_model.dart';
import 'package:notes/services/api_service.dart';
import 'package:notes/utils/form_helper.dart';
import 'package:notes/views/widgets/logo_space.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;
  String? confirmPassword;
  String? fullname;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF202020),
        body: ProgressHUD(
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: _registerUI(context),
          ),
        ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
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
            child: Text("Register", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color.fromARGB(255, 230, 185, 4),
            )),
          ),
          FormHelper.inputFieldWidget(
            context,
            "fullname",
            "Fullname",
            (onValidateVal) {
              if (onValidateVal!.isEmpty) {
                return "Fullname is required";
              }
              return null;
            },
            (onSavedVal) {
              fullname = onSavedVal;
            },
            prefixIcon: const Icon(Icons.person_outline),
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
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: FormHelper.inputFieldWidget(
              context,
              "confirm password",
              "Confirm Password",
              (onValidateVal) {
                if (onValidateVal!.isEmpty) {
                  return "Confirm Password is required";
                }     

                return null;
              },
              (onSavedVal) {
                confirmPassword = onSavedVal;
              },
              prefixIcon: const Icon(Icons.key_outlined),
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
          const SizedBox( height:  20),
          Center(
            child: FormHelper.submitButton(
              "Register",
              () {
                var validated = validateAndSave();
                if (password != confirmPassword ){
                  return FormHelper.showSimpleAlertDialog(
                        context,
                        'Registration Failed',
                        'password and confirm password are not the same',
                        "OK",
                        () {
                          Navigator.pop(context);
                        }
                      );
                }
                if(validated) {
                  setState(() {
                    isAPIcallProcess = true;
                  });

                  RegisterRequestModel model = RegisterRequestModel(
                    username: username!,
                    password: password!,
                    fullname: fullname!,
                  );

                  APIService.register(model).then((response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    if(response.data != null) {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "Registration Success",
                        "Please login to the account ",
                        "OK",
                        () {
                          Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false
                          );
                        }
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        response.errors![0],
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
              txtColor: const Color.fromARGB(255, 230, 185, 4),
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
                    text: "Have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  TextSpan(
                    text: 'Login',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 230, 185, 4),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.pop(context);
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