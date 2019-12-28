import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:random_quote/repositories/quote_api_client.dart';
import 'package:random_quote/repositories/quote_repository.dart';

class MockQuoteApiClient extends Mock implements QuoteApiClient {}

void main() {
  group('assertion', () {
    test('should assert if null', () {
      expect(
        () => QuoteRepository(quoteApiClient: null),
        throwsA(isAssertionError),
      );
    });
  });
}
