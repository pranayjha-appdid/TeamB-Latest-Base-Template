import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/assets.dart';
import '../../../services/constants.dart';

class MaintenanceDialog extends StatelessWidget {
  const MaintenanceDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Dialog(
        child: IntrinsicHeight(
          child: SizedBox(
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Center(
                    child: Lottie.asset(
                      Assets.lottiesMaintenance,
                      height: size.height * 0.1,
                      width: size.width,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      AppConstants.appName,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900]),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "App is Under Maintenance",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          SystemNavigator.pop();
                        },
                        child: Container(
                          height: 40,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Center(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
