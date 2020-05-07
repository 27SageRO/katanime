import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/manga_details/event.dart';
import 'package:katanime/bloc/manga_details/state.dart';

class MangaDetailsBloc extends Bloc<MangaDetailsEvent, MangaDetailsState> {
  final Jikan api;
  MangaDetailsBloc(this.api);

  @override
  MangaDetailsState get initialState => MangaDetailsStateLoading();

  @override
  Stream<MangaDetailsState> mapEventToState(MangaDetailsEvent event) async* {
    final currentState = state;
    if (event is MangaDetailsEventFetch) {
      try {
        if (currentState is! MangaDetailsStateLoading) {
          yield MangaDetailsStateLoading();
        }

        final manga = await api.getMangaInfo(event.malId);
        var newState = MangaDetailsStateSuccess(manga: manga);
        yield newState;

        final characters = await api.getMangaCharacters(manga.malId);
        newState = newState.copyWith(characters: characters.toList());
        yield newState;

        final reviews = await api.getMangaReviews(manga.malId);
        newState = newState.copyWith(reviews: reviews.toList());
        yield newState;
        return;
      } catch (e) {
        yield MangaDetailsStateError();
        return;
      }
    }
  }
}
