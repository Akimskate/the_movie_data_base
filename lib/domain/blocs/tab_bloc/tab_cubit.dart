import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TabEvent {}

class NewsTabSelectedEvent extends TabEvent {}

class MovieTabSelectedEvent extends TabEvent {}

class TVShowTabSelectedEvent extends TabEvent {}

class TabSelectedCubit extends Cubit<TabSelectedState> {
  TabSelectedCubit() : super(TabSelectedState(selectedTab: 'News'));

  void newsTabSelected() {
    emit(state.copyWith(selectedTab: 'News'));
  }

  void movieTabSelected() {
    emit(state.copyWith(selectedTab: 'Movies'));
  }

  void tvShowTabSelected() {
    emit(state.copyWith(selectedTab: 'TV Shows'));
  }
}

class TabSelectedState {
  final String selectedTab;

  TabSelectedState({
    required this.selectedTab,
  });

  TabSelectedState copyWith({
    String? selectedTab,
  }) {
    return TabSelectedState(
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  bool operator ==(covariant TabSelectedState other) {
    if (identical(this, other)) return true;

    return other.selectedTab == selectedTab;
  }

  @override
  int get hashCode => selectedTab.hashCode;
}
