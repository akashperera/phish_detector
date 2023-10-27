import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Phish extends StatefulWidget {
  final String? text;
  final bool isIcon;
  final bool? iconAlignRight;
  final Widget child;
  final Function(String url, String status, String percentage) onTap;
  const Phish(
      {Key? key,
      required this.text,
      required this.child,
      required this.onTap,
      required this.isIcon,
      this.iconAlignRight})
      : super(key: key);

  @override
  State<Phish> createState() => _PhishState();
}

class _PhishState extends State<Phish> {
  @override
  void initState() {
    checkUrlInText();
    super.initState();
  }

  String foundUrl = '';
  checkUrlInText() {
    var text = widget.text;
    if (text == null) {
      return;
    }
    var urls = text.split(' ');
    for (var url in urls) {
      if (url.startsWith('http')) {
        setState(() {
          foundUrl = url.trim();
        });

        checkPhishing();
        break;
      }
    }
  }

  var dataRes;
  checkPhishing() async {
    setState(() {
      isLoading = true;
    });
    log('Checking Phishing');
    try {
      var response = await http.post(
          Uri.parse('https://ap101.pythonanywhere.com/predict'),
          body: jsonEncode({'url': foundUrl.trim()}));
      log(response.body);
      var data = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        dataRes = data;
      });
    } catch (e) {}
  }

  // send the response to the user
  bool isLoading = false;
  bool isPhishing = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isLoading) {
          widget.onTap(foundUrl, "checking...", "0.0");
        } else if (foundUrl == '') {
          widget.onTap("No Url", "0", "0.0");
        } else {
          widget.onTap(
              foundUrl,
              dataRes['ypred'] == "1" ? "unsafe" : "safe",
              dataRes['ypred'] == "1"
                  ? dataRes['y_pro_phishing']
                  : dataRes['y_pro_non_phishing']);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.child,
          const Divider(
            height: 1,
          ),
          if (widget.isIcon && foundUrl != '')
            Row(
              mainAxisAlignment: widget.iconAlignRight ?? false
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : (isPhishing)
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.warning,
                              color: Colors.white,
                            ))
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            )),
              ],
            ),
        ],
      ),
    );
  }
}
