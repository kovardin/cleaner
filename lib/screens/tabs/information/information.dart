import 'package:cleaner/components/adbanner/adbanner.dart';
import 'package:cleaner/constants.dart';
import 'package:cleaner/screens/tabs/information/components/header.dart';
import 'package:cleaner/screens/tabs/information/components/link.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            const Header(title: 'Information'),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Link(
                        title: 'About',
                        icon: 'Document',
                        press: () async => await canLaunch('https://kodazm.ru')
                            ? await launch('https://kodazm.ru')
                            : throw 'Could not launch'),
                    Divider(color: TextColor),
                    Link(
                        title: 'Feedback',
                        icon: 'Message',
                        press: () async => await canLaunch('https://kodazm.ru')
                            ? await launch('https://kodazm.ru')
                            : throw 'Could not launch'),
                    Divider(color: TextColor),
                    Link(title: 'Share', icon: 'Send', press: () => Share.share('check out https://kodazm.ru')),
                    Divider(color: TextColor),
                    Link(
                        title: 'Other application',
                        icon: 'Category',
                        press: () async => await canLaunch('https://kodazm.ru')
                            ? await launch('https://kodazm.ru')
                            : throw 'Could not launch'),
                  ],
                ),
              ),
            ),

            // banner
            const AdBanner()
          ],
        ),
      ),
    );
  }
}


