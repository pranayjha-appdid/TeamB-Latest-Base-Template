import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../services/route_helper.dart';
import '../../../../services/theme.dart';
import '../../../services/enums/bussiness_setting_enum.dart';
import '../../base/custom_widget.dart/custom_html_screen.dart';

class TermsAndConditionWidget extends StatelessWidget {
  const TermsAndConditionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: "By providing my phone number , I hereby agree and accept the \n", style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 10)),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(
                        getCustomRoute(
                          child: const CustomHtmlScreen(title: 'Terms and Conditions', bussinessSettingName: BussinessSettingName.termsAndCondition),
                        ),
                      );
                    },
                  text: "Terms And Conditions",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: textPrimary, fontSize: 10, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: " & ", style: Theme.of(context).textTheme.titleSmall!.copyWith()),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(
                        getCustomRoute(
                          child: const CustomHtmlScreen(title: 'Privacy Policy', bussinessSettingName: BussinessSettingName.privacyPolicy),
                        ),
                      );
                    },
                  text: "Privacy Policy",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: textPrimary, fontSize: 10, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: " in use of this app.", style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
