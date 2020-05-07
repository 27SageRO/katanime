import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/anime_details/event.dart';
import 'package:katanime/bloc/anime_details/state.dart';

class AnimeDetailsBloc extends Bloc<AnimeDetailsEvent, AnimeDetailsState> {
  final Jikan api;

  AnimeDetailsBloc(this.api);

  @override
  AnimeDetailsState get initialState => AnimeDetailsStateLoading();

  @override
  Stream<AnimeDetailsState> mapEventToState(AnimeDetailsEvent event) async* {
    if (event is AnimeDetailsEventReload) {
      yield AnimeDetailsStateLoading();
      try {
        final anime = await api.getAnimeInfo(event.malId);
        yield AnimeDetailsStateSuccess(anime: anime);

        // Lazy load:
        var currentState = state;
        if (currentState is AnimeDetailsStateSuccess) {
          final characterStaff = await api.getAnimeCharactersStaff(event.malId);
          yield currentState.copyWith(characterStaff: characterStaff);
        }

        currentState = state;
        if (currentState is AnimeDetailsStateSuccess) {
          final reviews = await api.getAnimeReviews(event.malId);
          yield currentState.copyWith(reviews: reviews.toList());
        }
      } catch (e) {
        yield AnimeDetailsStateError();
      }
    }
  }
}
