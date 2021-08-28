import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RateOnGooglePlay extends StatelessWidget {
  const RateOnGooglePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launch('https://play.google.com/store/apps/details?id=com.dolev.graderForMashov');
      },
      child: Container(
        margin: const EdgeInsets.only(left: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: Colors.grey[300],
        ),
        padding: const EdgeInsets.all(1.5),
        child: Container(
          padding: const EdgeInsets.only(
              left: 7, right: 7, bottom: 7, top: 7),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black.withOpacity(0.8),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("דרגו כעת ב-",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0)),
                  Text("Google play",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0))
                ],
              ),
              const Spacer(),
              Image.network(
                  "https://storage.googleapis.com/gweb-uniblog-publish-prod/images/Google_Play_Prism.max-500x500.png")
            ],
          ),
        ),
      ),
    );
  }
}
