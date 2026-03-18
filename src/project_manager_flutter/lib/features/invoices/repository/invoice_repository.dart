import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/add_line_item_request.dart';
import '../models/generate_invoice_request.dart';
import '../models/invoice_detail.dart';
import '../models/invoice_line_item.dart';
import '../models/paginated_invoices.dart';
import '../models/update_invoice_status_request.dart';

class InvoiceRepository {
  final Dio _dio;

  InvoiceRepository(this._dio);

  Future<PaginatedInvoices> listInvoices({
    String? clientId,
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.invoices,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (clientId != null) 'clientId': clientId,
          if (status != null) 'status': status,
        },
      );
      return PaginatedInvoices.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<InvoiceDetail> getInvoice(String id) async {
    try {
      final response = await _dio.get(ApiConstants.invoiceById(id));
      return InvoiceDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<Map<String, dynamic>> generateInvoice(GenerateInvoiceRequest request) async {
    try {
      final response = await _dio.post(ApiConstants.generateInvoice, data: request.toJson());
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<Map<String, dynamic>> updateInvoiceStatus(
      String id, UpdateInvoiceStatusRequest request) async {
    try {
      final response = await _dio.patch(
        ApiConstants.invoiceStatus(id),
        data: request.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<InvoiceLineItem> addLineItem(String invoiceId, AddLineItemRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.invoiceLineItems(invoiceId),
        data: request.toJson(),
      );
      return InvoiceLineItem.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }
}
