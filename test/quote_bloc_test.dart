import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:random_quote/bloc/bloc.dart';
import 'package:random_quote/models/models.dart';
import 'package:random_quote/repositories/repositories.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  QuoteBloc quoteBloc;
  MockQuoteRepository quoteRepository;

  setUp(() {
    quoteRepository = MockQuoteRepository();
    quoteBloc = QuoteBloc(repository: quoteRepository);
  });

  tearDown(() {
    quoteBloc?.close();
  });

  test('should assert if null', () {
    expect(
      () => QuoteBloc(repository: null),
      throwsA(isAssertionError),
    );
  });

  test('initial state is correct', () {
    expect(quoteBloc.initialState, QuoteEmpty());
  });

  test('close does not emit new states', () {
    expectLater(
      quoteBloc,
      emitsInOrder([QuoteEmpty(), emitsDone]),
    );
    quoteBloc.close();
  });

  group('Bloc test', () {
    final Quote mockQuote =
        Quote(id: 123, quoteAuthor: "abc", quoteText: "def");

    blocTest(
      'emits [QuoteEmpty, QuoteLoading, QuoteLoaded] when FetchQuote is added and fetchQuote succeeds',
      build: () {
        when(quoteRepository.fetchQuote()).thenAnswer(
          (_) => Future.value(mockQuote),
        );
        return quoteBloc;
      },
      act: (bloc) => bloc.add(FetchQuote()),
      expect: [QuoteEmpty(), QuoteLoading(), QuoteLoaded(quote: mockQuote)],
    );

    blocTest(
      'emits [QuoteEmpty, QuoteLoading, QuoteError] when FetchQuote is added and fetchQuote fails',
      build: () {
        when(quoteRepository.fetchQuote())
            .thenThrow(Exception('error getting quotes'));
        return quoteBloc;
      },
      act: (bloc) => bloc.add(FetchQuote()),
      expect: [QuoteEmpty(), QuoteLoading(), QuoteError()],
    );
  });
}
