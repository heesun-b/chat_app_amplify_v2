import 'package:chat/constants.dart';
import 'package:chat/providers/user_provider.dart';
import 'package:chat/screens/auth/sign_in_screen.dart';
import 'package:chat/shared/extentions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/logo_with_title.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _otpCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LogoWithTitle(
        title: 'Verification',
        subText: "Verification code has been sent to your mail",
        children: [
          const SizedBox(height: defaultPadding),
          Form(
            key: _formKey,
            child: TextFormField(
              onSaved: (otpCode) {
                _otpCode = otpCode!;
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(hintText: "Enter OTP"),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final result = await context
                    .read<UserProvider>()
                    .confirmSignUp(username: widget.username, code: _otpCode);
                result.fold(
                      (error) => context.showError(error),
                      (isConfirmed) {
                    if (isConfirmed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("User has been confirmed"),
                          action: SnackBarAction(
                            label: "Login",
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                                    (route) => false,
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
            child: context.watch<UserProvider>().isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Validate"),
          ),
        ],
      ),
    );
  }
}
