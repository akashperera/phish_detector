<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

This is a Plugin that can be use to detect phishing urls

## Features

Scan Texts and Images for Urls and scan and check whether they are safe or not

## Getting started

Just import this Package and use it on your Project

## Usage

```dart
  Phish(
                  isIcon: true,
                  iconAlignRight: false,
                  text: "your text here",
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text("Custom Widget")),
                  ),
                  onTap: (url, status, percentage) {

                    print("$url $status $percentage");
                  },
                ),
```

## Additional information
