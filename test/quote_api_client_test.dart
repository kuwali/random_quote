import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:random_quote/models/models.dart';
import 'package:random_quote/repositories/quote_api_client.dart';

class MockQuoteApiClient extends Mock implements QuoteApiClient {
  QuoteApiClient _real;

  MockQuoteApiClient(http.Client httpClient) {
    _real = QuoteApiClient(httpClient: httpClient);
    when(fetchQuote()).thenAnswer((_) => _real.fetchQuote());
  }
}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('assertion', () {
    test('should assert if null', () {
      expect(
        () => QuoteApiClient(httpClient: null),
        throwsA(isAssertionError),
      );
    });
  });

  group('fetchQuote', () {
    final mockHttpClient = MockHttpClient();
    final mockQuoteApiClient = MockQuoteApiClient(mockHttpClient);
    test('return Quote if http call successfully', () async {
      // given
      final mockQuoteString = '''
        {"_id": "123", "quoteText": "abc", "quoteAuthor": "-"}
      ''';
      final mockQuote = Quote.fromJson(jsonDecode(mockQuoteString));

      when(mockHttpClient
              .get('https://quote-garden.herokuapp.com/quotes/random'))
          .thenAnswer(
              (_) async => Future.value(http.Response(mockQuoteString, 200)));

      expect(await mockQuoteApiClient.fetchQuote(), mockQuote);
      expect(mockQuote.toString(), 'Quote { id: 123 }');
    });

    test('return Exception if http call error', () async {
      when(mockHttpClient
              .get('https://quote-garden.herokuapp.com/quotes/random'))
          .thenAnswer((_) async =>
              Future.value(http.Response('error getting quotes', 202)));

      expect(() async => await mockQuoteApiClient.fetchQuote(),
          throwsA(isException));
    });
  });
}
