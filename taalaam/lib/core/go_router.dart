import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_app/core/Auth/ScreenAuth/controller_auth.dart';
import 'package:student_app/core/Auth/ScreenAuth/forgot_password.dart';
import 'package:student_app/core/Auth/ScreenAuth/verfication_screen.dart';
import 'package:student_app/core/Auth/data/cubit/cubit_auth.dart';
import 'package:student_app/core/data/Model/add_subject-model.dart';
import 'package:student_app/core/data/cubit/cubit.dart';
import 'package:student_app/core/screen/Courses%20Screen/courses.dart';
import 'package:student_app/core/screen/Courses%20Screen/courses_road_map_screen.dart';
import 'package:student_app/core/screen/lessons.dart';
import 'package:student_app/core/screen/splash_screen.dart';

class KRoutes {
  static const String courses = '/courses';
  static const String roadMapCourses = '/road-map-courses';
  static const String lessons = '/lessons';
  static const String showLesson = '/show-lesson';
  static const String splash = '/';
  static const String controllAuth = '/controll_auth';
  static const String verfication = '/verfication';
  static const String forgotPassword = '/forgot-password';

  static final routes = GoRouter(
    routes: [
      ShellRoute(
        pageBuilder: (context, state, child) => NoTransitionPage(
          child: BlocProvider<StudentCubit>(
            create: (context) => StudentCubit(),
            child: child,
          ),
        ),
        routes: [
          GoRoute(
            path: splash,
            pageBuilder: (context, state) => NoTransitionPage(
              // ✅ pageBuilder
              child: const SplashScreen(),
            ),
          ),
          GoRoute(
            path: courses,
            pageBuilder: (context, state) => NoTransitionPage(
              // ✅ pageBuilder
              child: const CoursesScreen(),
            ),
          ),
          GoRoute(
            path: lessons,
            pageBuilder: (context, state) => NoTransitionPage(
              // ✅ pageBuilder
              child: LessonsScreen(subject: state.extra as SubjectModel),
            ),
          ),
          GoRoute(
            path: roadMapCourses,
            pageBuilder: (context, state) => NoTransitionPage(
              // ✅ pageBuilder
              child: const RoadMapCourses(),
            ),
          ),
          GoRoute(
            path: showLesson,
            pageBuilder: (context, state) {
              final extra = state.extra as List;
              return NoTransitionPage(
                // ✅ pageBuilder
                child: ShowLessonScreen(
                  lesson: extra[0] as LessonsModel,
                  indexSubject: extra[1] as SubjectModel,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: controllAuth,
        pageBuilder: (context, state) => NoTransitionPage(
          // ✅ pageBuilder
          child: ControllerAuth(),
        ),
      ),
      GoRoute(
        path: forgotPassword,
        pageBuilder: (context, state) => NoTransitionPage(
          // ✅ pageBuilder
          child: BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(),
            child: ForgotPassword(),
          ),
        ),
      ),
      GoRoute(
        path: verfication,
        pageBuilder: (context, state) => NoTransitionPage(
          // ✅ pageBuilder
          child: VerficationScreen(cubit: state.extra as AuthCubit),
        ),
      ),
    ],
  );
}

void push(BuildContext context, String path, {Object? extra}) {
  context.push(path, extra: extra);
}

void go(BuildContext context, String path, {Object? extra}) {
  context.go(path, extra: extra);
}

void pop(BuildContext context) {
  context.pop();
}

void pushReplacement(BuildContext context, String path) {
  context.pushReplacement(path);
}
