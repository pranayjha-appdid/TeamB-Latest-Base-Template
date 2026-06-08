import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/route_helper.dart';
import '../../../services/theme.dart';
import '../../base/custom_widget.dart/common_button.dart';
import 'opt_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Mobile Authentication",
          style:
              Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              "What's your",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "phone number?",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              autofocus: true,
              controller: _phoneNumberController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: "Phone number",
                hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black.withOpacity(0.3),
                    ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.3), width: 1)),
              ),
              onChanged: (txt) {
                if (txt.length == 10) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text:
                      "By tapping next you're creating an account and you agree to the ",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith()),
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () {},
                text: "Terms and condition ",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
              ),
              TextSpan(
                  text: "and acknowledge ",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith()),
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () {},
                text: "Privacy Policy ",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
              )
            ]))
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SizedBox(
            height: 50,
            child: CustomButton(
              radius: 6,
              elevation: 0,
              color: Colors.black,
              onTap: () {
                Navigator.push(
                    context,
                    getCustomRoute(
                        child: OTPVerification(
                      phone: _phoneNumberController.text,
                    )));
              },
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
