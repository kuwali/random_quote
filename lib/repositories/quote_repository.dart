import 'dart:async';

import 'package:meta/meta.dart';

import 'package:random_quote/repositories/quote_api_client.dart';
import 'package:random_quote/models/models.dart';

class QuoteRepository {
  final QuoteApiClient quoteApiClient;

  QuoteRepository({@required this.quoteApiClient})
      : assert(quoteApiClient != null);

  Future<Quote> fetchQuote() async {
    return await quoteApiClient.fetchQuote();
  }
}
