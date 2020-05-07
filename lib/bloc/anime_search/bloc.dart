import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:katanime/bloc/anime_search/event.dart';
import 'package:katanime/bloc/anime_search/state.dart';

class AnimeSearchBloc extends Bloc<AnimeSearchEvent, AnimeSearchState> {
  final Jikan api;

  AnimeSearchBloc(this.api);

  @override
  AnimeSearchState get initialState => AnimeSearchStateEmpty();

  @override
  Stream<Transition<AnimeSearchEvent, AnimeSearchState>> transformEvents(
      Stream<AnimeSearchEvent> events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<AnimeSearchState> mapEventToState(AnimeSearchEvent event) async* {
    final currentState = state;
    if (event is AnimeSearchEventFetch) {
      try {
        // Check if user changed the search query
        // if true, load new search data
        // if false, paginate
        if (currentState is AnimeSearchStateEmpty ||
            currentState is AnimeSearchStateLoading ||
            (currentState is AnimeSearchStateSuccess &&
                currentState.query != event.query)) {
          yield AnimeSearchStateLoading();
          final animes = await api.search(
            Uri.encodeComponent(event.query),
            SearchType.anime,
            page: 1,
          );
          yield AnimeSearchStateSuccess(
            animes: animes.toList(),
            query: event.query,
          );
          return;
        }
        if (currentState is AnimeSearchStateSuccess) {
          if (currentState.hasReachedMax) {
            print('has reached max');
            return;
          }
          final int nextPage = currentState.page + 1;
          final animes = await api.search(
            Uri.encodeComponent(currentState.query),
            SearchType.anime,
            page: nextPage,
          );
          yield currentState.copyWith(
            animes: currentState.animes + animes.toList(),
            page: nextPage,
            hasReachedMax: animes.length == 0,
          );
          return;
        }
      } catch (e) {
        yield AnimeSearchStateError();
        return;
      }
    }
  }
}
