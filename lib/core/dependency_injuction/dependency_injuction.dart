import 'package:get_it/get_it.dart';
import 'package:last_version/auth/services/auth_service.dart';
import 'package:last_version/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/notes/services/note_services.dart';

final getIt = GetIt.instance;
void setupGetIt() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<NoteService>(() => NoteService());

  getIt.registerFactory<NoteCubit>(
    () => NoteCubit(noteService: getIt<NoteService>()),
  );
}
