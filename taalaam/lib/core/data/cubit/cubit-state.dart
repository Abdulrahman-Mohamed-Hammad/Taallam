abstract class AppState {}

class AppInitialState extends AppState {}

class AppLoadingState extends AppState {}

class AppChangeState extends AppState {}

class AppErrorState extends AppState {
  final String error;

  AppErrorState(this.error);
}
