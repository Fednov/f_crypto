import 'package:f_crypto/core/services/worker/app_worker_service.dart';
import 'package:worker_manager/worker_manager.dart';

class AppWorkerServiceWorkerManager implements AppWorkerService {
  @override
  Future<R> execute<T, R>(T message, R Function(T) action) {
    return workerManager.execute(() => action(message));
  }
}
