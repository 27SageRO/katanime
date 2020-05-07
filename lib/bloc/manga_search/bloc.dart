import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:katanime/bloc/manga_search/event.dart';
import 'package:katanime/bloc/manga_search/state.dart';

class MangaSearchBloc extends Bloc<MangaSearchEvent, MangaSearchState> {
  final Jikan api;

  MangaSearchBloc(this.api);

  @override
  MangaSearchState get initialState => MangaSearchStateEmpty();

  @override
  Stream<Transition<MangaSearchEvent, MangaSearchState>> transformEvents(
      Stream<MangaSearchEvent> events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<MangaSearchState> mapEventToState(MangaSearchEvent event) async* {
    final currentState = state;
    if (event is MangaSearchEventFetch) {
      try {
        // Check if user changed the search query
        // if true, load new search data
        // if false, paginate
        if (currentState is MangaSearchStateEmpty ||
            currentState is MangaSearchStateLoading ||
            (currentState is MangaSearchStateSuccess &&
                event.query != currentState.query)) {
          yield MangaSearchStateLoading();
          final mangas = await api.search(
            Uri.encodeComponent(event.query),
            SearchType.manga,
            page: 1,
          );
          yield MangaSearchStateSuccess(
            mangas: mangas.toList(),
            query: event.query,
          );
          return;
        }

        if (currentState is MangaSearchStateSuccess) {
          final int nextPage = currentState.page + 1;
          final mangas = await api.search(
            Uri.encodeComponent(event.query),
            SearchType.manga,
            page: nextPage,
          );
          yield currentState.copyWith(
            mangas: currentState.mangas + mangas.toList(),
            page: nextPage,
            hasReachedMax: mangas.length == 0,
          );
        }
      } catch (e) {
        yield MangaSearchStateError();
        return;
      }
    }
  }
}
