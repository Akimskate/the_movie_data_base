import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/show_api_client.dart';
import 'package:moviedb/domain/blocs/tv_show_list_bloc/tv_show_list_event.dart';
import 'package:moviedb/domain/blocs/tv_show_list_bloc/tv_show_list_state.dart';
import 'package:moviedb/domain/entity/popular_tv_show_response.dart';
import 'package:moviedb/domain/entity/tv_show.dart';

class TVShowListBloc extends Bloc<TvShowListEvent, TVShowListState> {
  final _showApiClient = ShowApiClient();
  TVShowListBloc(TVShowListState initialState) : super(initialState) {
    on<TvShowListEvent>((event, emit) async {
      if (event is TVShowListEventLoadNextPageEvent) {
        await onTVShowListEventLoadNextPageEvent(event, emit);
      } else if (event is TVShowListEventLoadResetEvent) {
        await onTVShowListEventLoadResetEvent(event, emit);
      } else if (event is TVShowListEventLoadSearchTVShowEvent) {
        await onListEventLoadSearchTVShowEvent(event, emit);
      }
    }, transformer: sequential());
  }

  Future<TVShowListContainer?> _loadNextPage(
    TVShowListContainer container,
    Future<PopularTvShowResponse> Function(int) loader,
  ) async {
    if (container.isComplete) return null;
    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final shows = List<TvShow>.from(container.shows)..addAll(result.tvShows);

    final newContainer = container.copyWith(
      shows: shows,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onTVShowListEventLoadNextPageEvent(
    TVShowListEventLoadNextPageEvent event,
    Emitter<TVShowListState> emit,
  ) async {
    if (state.isSearchMode) {
      final container = await _loadNextPage(
        state.searchTVShowContainer,
        (nextPage) async {
          final result = await _showApiClient.searchShow(
            nextPage,
            event.locale,
            state.searchQuerry,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(searchTVShowContainer: container);
        emit(newState);
      }
    } else {
      final container = await _loadNextPage(
        state.popularTVShowContainer,
        (nextPage) async {
          final result = await _showApiClient.popularTvShow(
            nextPage,
            event.locale,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(popularTVShowContainer: container);
        emit(newState);
      }
    }
  }

  Future<void> onTVShowListEventLoadResetEvent(
    TVShowListEventLoadResetEvent event,
    Emitter<TVShowListState> emit,
  ) async {
    emit(const TVShowListState.initial());
  }

  Future<void> onListEventLoadSearchTVShowEvent(
    TVShowListEventLoadSearchTVShowEvent event,
    Emitter<TVShowListState> emit,
  ) async {
    if (state.searchQuerry == event.querry) return;
    final newState = state.copyWith(
        searchQuerry: event.querry,
        searchTVShowContainer: const TVShowListContainer.initial());
    emit(newState);
  }
}
