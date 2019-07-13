import 'package:html/parser.dart';
import 'package:http/http.dart';

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

    String adUrl = document
        .querySelector("body > table > tbody >tr >td > a ")
        .attributes['href']
        .trim();

    response = await client.get(adUrl);

    if (!(200 <= response.statusCode && response.statusCode <= 299))
      return null;
    String endpoint =response.request.url.origin;
    print("\n\n\n\n\n\n\n");
    print(endpoint);

    document = parse(response.body);

    var url = endpoint + document.querySelector("a").attributes['href'];

    return url;
  }
}
