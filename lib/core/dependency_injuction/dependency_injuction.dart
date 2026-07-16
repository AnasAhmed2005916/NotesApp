import 'package:get_it/get_it.dart';
import 'package:last_version/core/services/notification_service.dart';
import 'package:last_version/features/auth/services/auth_service.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/features/notes/services/note_services.dart';

final getIt = GetIt.instance;
void setupGetIt() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<NoteService>(() => NoteService());

  getIt.registerFactory<NoteCubit>(
    () => NoteCubit(noteService: getIt<NoteService>()),
  );
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
}
