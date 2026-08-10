import 'package:dio/dio.dart';
import '../../../../../config/app_config.dart';
import 'package:mobilepos/src/core/errors/exceptions.dart';
import '../../../domain/entities/reciept.dart';
import '../../models/create_pos_invoice_dto.dart';
import '../remote/receipts_remote_datasource.dart';

class ReceiptsRemoteDataSourceImpl implements ReceiptsRemoteDataSource {
  ReceiptsRemoteDataSourceImpl._();

  static final ReceiptsRemoteDataSourceImpl instance = ReceiptsRemoteDataSourceImpl._();

  Dio get dio => AppConfig.dio;

  @override
  Future<List<Receipt>> getReceipts() async {
    try {
      final response = await dio.get('/api/v1/pos/invoices');
      final responseData = response.data;
      if (responseData == null || responseData['data'] == null) {
        return [];
      }
      
      final data = responseData['data'];
      if (data is List) {
        return data.map((json) => Receipt.fromJson(json)).toList();
      } else if (data is Map && data['receipts'] is List) {
        return (data['receipts'] as List).map((json) => Receipt.fromJson(json)).toList();
      }
      
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to fetch receipts',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> createInvoice(CreatePosInvoiceDto payload) async {
    try {
      await dio.post(
        '/api/v1/pos/invoices',
        data: payload.toJson(),
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to create invoice',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  @override
  Future<void> cancelInvoice(int invoiceId) async {
    try {
      await dio.post('/api/v1/pos/invoices/$invoiceId/cancel');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to cancel invoice',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
