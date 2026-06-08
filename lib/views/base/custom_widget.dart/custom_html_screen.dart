import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';

import '../../../controllers/basic_controller.dart';
import '../../../services/enums/bussiness_setting_enum.dart';
import '../dialogs/custom_nodata_found.dart';

class CustomHtmlScreen extends StatefulWidget {
  const CustomHtmlScreen(
      {super.key,
      required this.title,
      this.htmlContent,
      this.bussinessSettingName});
  final String title;
  final String? htmlContent;
  final BussinessSettingName? bussinessSettingName;

  @override
  State<CustomHtmlScreen> createState() => _CustomHtmlScreenState();
}

class _CustomHtmlScreenState extends State<CustomHtmlScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String? htmlContent = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.htmlContent != null) {
        htmlContent = widget.htmlContent;
      } else if (widget.bussinessSettingName != null) {
        htmlContent = await Get.find<BasicController>()
            .getHtmlContent(widget.bussinessSettingName!);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
        ),
      ),
      body: htmlContent == ''
          ? const Center(
              child: CustomNoDataFoundWidget(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: SingleChildScrollView(
                child: Html(
                  data: htmlContent!.replaceAll('<br>', ''),
                ),
              ),
            ),
    );
  }
}
