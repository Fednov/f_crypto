import 'package:f_crypto/core/services/crypto/provider/crypto_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home_repository.dart';

final homeRepositoryProvider = Provider.autoDispose<HomeRepository>(
  (ref) {
    var cryptoService = ref.watch(cryptoServiceProvider);

    return HomeRepository(cryptoService: cryptoService);
  },
);
