import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart' as dom;
import 'dart:async';

class Scrapper {
// final String  adUrl;

//   Scrapper(this.adUrl);   //libgen.io

  Future<String> downloadUrlGenrator(String downloadPage) async {
    var client = Client();

    Response response = await client.get(downloadPage);

    if (!(200 <= response.statusCode && response.statusCode <= 299))
      return null;

    var document = parse(response.body);

    dom.Element element = document.querySelector("a");
    var url = element.attributes['href'];

    return url;
  }
}
