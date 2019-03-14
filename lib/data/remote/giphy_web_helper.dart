import 'dart:collection';
import 'package:tech_test/errors.dart';
import 'package:http/http.dart' as http;

const GIPHY_API_KEY = "pqyOZdEuEUSwVEdoqTyqpzOI6WFIENDn";
const GIPHY_ENDPOINT = "api.giphy.com";
const GIPHY_SEARCH_URL = "/v1/gifs/search";

Uri getPageByQuery(int offset, String searchQuery) {
  final query = new HashMap<String, String>();
  query["api_key"] = GIPHY_API_KEY;
  query["offset"] = offset.toString();
  query["q"] = searchQuery;

  return Uri.http("$GIPHY_ENDPOINT", "$GIPHY_SEARCH_URL", query);
}


Future<http.Response> get(url, {Map<String, String> headers}) {
  return http.get(url, headers: headers).then((response) {
    if (response.statusCode < 200 || response.statusCode > 299) {
      throw Exception(
          "Failed request ${response.request.url}.\nCode == ${response.statusCode}\nReason == ${response.reasonPhrase}");
    } else if (response.statusCode == 429) {
      throw LastPageOccurred();
    }
      return response;
  });
}