import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:chat/constants.dart';
import 'package:chat/providers/user_provider.dart';
import 'package:chat/screens/auth/sign_in_screen.dart';
import 'package:chat/screens/auth/verification_screen.dart';
import 'package:chat/shared/extentions.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';



class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  late String _username, _email, _password;


  void signUp(String username, String email, String password) async {
    final signUpResult =
    await context.read<UserProvider>().signUp(username, email, password);
    signUpResult.fold(
          (error) => context.showError(error),
          (step) {
        if (step.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationScreen(username: username),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: RequiredValidator(errorText: requiredField),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'Username'),
            onSaved: (username) {
              _username = username!;
            },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            validator: RequiredValidator(errorText: requiredField),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'Email'),
            onSaved: (email) {
              _email = email!;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              validator: RequiredValidator(errorText: "Password is required"),
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
              onSaved: (password) {
                _password = password!;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  signUp(_username, _email, _password);
                }
              },
              child: context.watch<UserProvider>().isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Sign Up"),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            ),
            child: Text.rich(
              TextSpan(
                text: "Already have an account? ",
                children: [
                  TextSpan(
                    text: "Sign in",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.64),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}



