import 'package:f_crypto/core/services/logger/app_logger_developer.dart';
import 'package:f_crypto/features/home/bloc/home_bloc.dart';
import 'package:f_crypto/features/home/repository/provider/home_repository_provider.dart';
import 'package:f_crypto/features/home/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeStateProvider =
    StateNotifierProvider.autoDispose<HomeBloc, HomeState>(
  (ref) {
    var homeRepository = ref.watch(homeRepositoryProvider);
    var logger = AppLoggerDeveloper();
    var homeBloc = HomeBloc(
      homePageRepository: homeRepository,
      logger: logger,
    );

    homeBloc.init();

    return homeBloc;
  },
);
