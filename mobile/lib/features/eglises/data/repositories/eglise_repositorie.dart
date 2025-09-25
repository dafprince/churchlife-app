import 'package:mobile/features/eglises/data/datasources/eglise_api_service.dart';
import 'package:mobile/features/eglises/data/models/eglise_model.dart';

class EgliseRepository {
  final EgliseApiService apiService;
  EgliseRepository(this.apiService);

  Future<List<EgliseModel>> getEglises() => apiService.getEglises();
}
