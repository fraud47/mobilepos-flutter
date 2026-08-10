import 'package:dio/dio.dart';
import '../../../../../config/app_config.dart';
import 'package:mobilepos/src/core/errors/exceptions.dart';
import '../../../../../imports/core_imports.dart';
import '../../models/create_unit_of_measure_request.dart';
import '../../models/unit_of_measure_model.dart';
import '../remote/units_of_measure_remote_datasource.dart';

class UnitsOfMeasureRemoteDataSourceImpl
    implements UnitsOfMeasureRemoteDataSource {

  Dio get dio => AppConfig.dio;

  UnitsOfMeasureRemoteDataSourceImpl._();

  static final UnitsOfMeasureRemoteDataSourceImpl instance =
  UnitsOfMeasureRemoteDataSourceImpl._();
  @override
  Future<UnitOfMeasureModel> createUnitOfMeasure({
    required CreateUnitOfMeasureRequest request,
  }) async {
    try {
      final response =
      await dio.post<Map<String, dynamic>>(
        '/api/v1/units-of-measure',
        data: request.toJson(),
      );

      final responseData = response.data!;

      return UnitOfMeasureModel.fromJson(
        responseData['data'],
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
        e.response?.data?['message']?.toString() ??
            e.message ??
            'Unable to create unit of measure',
      );
    }
  }

  @override
  Future<List<UnitOfMeasureModel>> getUnitsOfMeasure({
    bool includeInactive = false,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/api/v1/units-of-measure',
        queryParameters: {
          'includeInactive': includeInactive ? 1 : 0,
        },
      );

      final responseData =
      response.data as Map<String, dynamic>;

      final data =
      responseData['data'] as List<dynamic>;

      return data
          .map(
            (json) => UnitOfMeasureModel.fromJson(
          json as Map<String, dynamic>,
        ),
      )
          .toList();
    } on DioException catch (e) {
      final responseData = e.response?.data;

      String message =
          'Unable to load units of measure';

      if (responseData is Map<String, dynamic>) {
        message =
            responseData['message']?.toString() ??
                message;
      }

      throw ServerException(
        message: message,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<UnitOfMeasureModel> updateUnitOfMeasure({
    required int id,
    required CreateUnitOfMeasureRequest request,
  }) async {
    try {
      final response = await dio.put<Map<String, dynamic>>(
        '/api/v1/units-of-measure/$id',
        data: request.toJson(),
      );
      return UnitOfMeasureModel.fromJson(response.data!['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ??
            e.message ??
            'Unable to update unit of measure',
      );
    }
  }

  @override
  Future<void> deleteUnitOfMeasure({
    required int id,
  }) async {
    try {
      await dio.delete<Map<String, dynamic>>(
        '/api/v1/units-of-measure/$id',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ??
            e.message ??
            'Unable to delete unit of measure',
      );
    }
  }
}