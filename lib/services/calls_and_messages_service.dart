import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
  void launchMap(String address) async {
    /**
     * https://www.google.com/maps/dir//Blood+Donors+Association,+Nepal,+M88F%2BJQ3,+Karuna+Rd,+Lalitpur+44700/
     */

    Uri query = Uri(
        host: "www.google.com",
        path: "/maps/search/$address/",
        scheme: "https");

    if (await canLaunchUrl(query)) {
      await launchUrl(query);
    }
  }

  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email) => launch("mailto:$email");
}
