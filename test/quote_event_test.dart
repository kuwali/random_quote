import 'package:flutter_test/flutter_test.dart';

import 'package:random_quote/bloc/bloc.dart';

void main() {
  group('FetchQuote', () {
    test('returns correct props', () {
      expect(FetchQuote().props, []);
    });
  });
}
