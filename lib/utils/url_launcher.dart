import 'package:url_launcher/url_launcher.dart';


launchURL(Uri url)async{
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }else{
    throw 'Could not launch $url';
  }
}